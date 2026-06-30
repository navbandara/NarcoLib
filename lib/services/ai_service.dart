import 'dart:async';
import '../ai/ai_manager.dart';
import '../ai/prediction_result.dart';

/// Service class responsible for exposing high-level AI model workflows.
///
/// Under the hood, this service coordinates calls to the [AiManager] to initialize models,
/// run predictions on local image paths, and dispose of runtime interpreter contexts.
class AiService {
  final AiManager _aiManager;

  /// Constructs an [AiService] with an optional injected [AiManager].
  AiService({AiManager? aiManager}) : _aiManager = aiManager ?? AiManager();

  /// Loads the TFlite model binary assets and label definitions.
  ///
  /// This initializes the underlying inference engine and prepares it for prediction tasks.
  Future<void> loadModel() async {
    // Under clean architecture, delegate to AiManager coordinator
    await _aiManager.initialize();
  }

  /// Classifies a target image file and yields a detailed [PredictionResult].
  ///
  /// Uses the active model interpreter to run classification on the given [imagePath].
  /// Returns mock/real prediction results depending on the active implementation stage.
  Future<PredictionResult> classifyImage(String imagePath) async {
    // Under clean architecture, delegate inference and parsing to AiManager
    return await _aiManager.predict(imagePath);
  }

  /// Disposes of the loaded model interpreter and frees up allocated resources.
  ///
  /// Call this when the AI classification features are no longer active to prevent memory leaks.
  Future<void> disposeModel() async {
    await _aiManager.dispose();
  }
}
