import 'dart:developer' as developer;
import 'image_preprocessor.dart';
import 'label_loader.dart';
import 'model_loader.dart';
import 'prediction_engine.dart';
import 'prediction_result.dart';

/// Facade/Coordinator class that integrates individual AI components to perform substance classifications.
///
/// Orchestrates the workflow of loading models, loading labels, preprocessing images,
/// running inference, and structuring prediction outputs into a [PredictionResult].
class AiManager {
  final ModelLoader _modelLoader;
  final LabelLoader _labelLoader;
  final ImagePreprocessor _imagePreprocessor;
  final PredictionEngine _predictionEngine;

  dynamic _modelInterpreter;
  bool _isInitialized = false;

  /// Constructs an [AiManager] with optional overrides for components to support DI and testing.
  AiManager({
    ModelLoader? modelLoader,
    LabelLoader? labelLoader,
    ImagePreprocessor? imagePreprocessor,
    PredictionEngine? predictionEngine,
  })  : _modelLoader = modelLoader ?? ModelLoaderImpl(),
        _labelLoader = labelLoader ?? LabelLoaderImpl(),
        _imagePreprocessor = imagePreprocessor ?? const ImagePreprocessorImpl(),
        _predictionEngine = predictionEngine ?? const PredictionEngineImpl();

  /// Initializes the AI Manager by loading both the model and the label assets.
  Future<void> initialize({
    String modelPath = 'assets/models/mobilenet_v3.tflite',
    String labelPath = 'assets/labels/labels.txt',
  }) async {
    if (_isInitialized) return;

    try {
      _modelInterpreter = await _modelLoader.loadModel(modelPath);
      await _labelLoader.loadLabels(labelPath);
      _isInitialized = true;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to initialize AI Manager',
        error: e,
        stackTrace: stackTrace,
        name: 'AiManager',
      );
      rethrow;
    }
  }

  /// Classifies an image file path and outputs a structured [PredictionResult].
  ///
  /// Assumes [initialize] has been called successfully first.
  Future<PredictionResult> predict(String imagePath) async {
    if (!_isInitialized || _modelInterpreter == null) {
      throw StateError(
        'AiManager is not initialized. Please call initialize() before predicting.',
      );
    }

    final stopwatch = Stopwatch()..start();

    try {
      // 1. Preprocess the input image (Target shape 224x224 for MobileNetV3)
      final inputBuffer = await _imagePreprocessor.preprocessImage(
        imagePath,
        targetWidth: 224,
        targetHeight: 224,
      );

      // 2. Run inference
      final probabilities = await _predictionEngine.runInference(
        _modelInterpreter,
        inputBuffer,
      );

      stopwatch.stop();

      // 3. Map raw outputs to substance label names
      final loadedLabels = _labelLoader.labels;
      if (probabilities.isEmpty || loadedLabels.isEmpty) {
        return PredictionResult.empty();
      }

      // Find the highest confidence class
      var primaryIndex = 0;
      var maxConfidence = -1.0;
      final alternativeMatches = <String, double>{};

      for (var i = 0; i < probabilities.length; i++) {
        if (i >= loadedLabels.length) break;
        final confidence = probabilities[i];
        final labelName = loadedLabels[i];

        if (confidence > maxConfidence) {
          maxConfidence = confidence;
          primaryIndex = i;
        }

        // Add to alternatives if it meets a low threshold (e.g., > 0.1%)
        if (confidence > 0.001) {
          alternativeMatches[labelName] = confidence;
        }
      }

      final primaryLabel = loadedLabels[primaryIndex];
      // Remove primary label from alternatives to keep it clean
      alternativeMatches.remove(primaryLabel);

      return PredictionResult(
        predictedClass: primaryLabel,
        confidence: maxConfidence,
        processingTime: stopwatch.elapsed,
        predictionDate: DateTime.now(),
        imagePath: imagePath,
        legalCategory: primaryLabel.contains('Heroin') || primaryLabel.contains('Cocaine')
            ? 'Poisons, Opium and Dangerous Drugs Ordinance (Part I)'
            : 'Poisons Ordinance (General)',
        recommendation: primaryLabel.contains('Heroin') || primaryLabel.contains('Cocaine')
            ? 'Submit sample for laboratory confirmation.'
            : 'Handle according to standard narcotic protocols.',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error during classification',
        error: e,
        stackTrace: stackTrace,
        name: 'AiManager',
      );
      rethrow;
    }
  }

  /// Unloads resources when no longer needed.
  Future<void> dispose() async {
    await _modelLoader.unloadModel();
    _modelInterpreter = null;
    _isInitialized = false;
  }
}
