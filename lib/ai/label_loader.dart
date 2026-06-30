/// Interface defining the contract for loading classification labels.
///
/// Maps indices of output tensors (e.g., probability vectors) from neural network inference
/// to readable names of substances (e.g., "Heroin", "Cocaine", etc.).
abstract class LabelLoader {
  /// Loads labels from the specified [labelPath].
  ///
  /// Returns a list of label strings indexed according to the model output.
  Future<List<String>> loadLabels(String labelPath);

  /// Returns the loaded labels.
  List<String> get labels;

  /// Returns true if the labels have been loaded.
  bool get isLabelsLoaded;
}

/// Placeholder implementation of [LabelLoader].
///
/// This will eventually parse labels from a newline-separated txt file loaded from assets
/// or local storage. Currently, it returns a static mockup of substance labels.
class LabelLoaderImpl implements LabelLoader {
  final List<String> _labels = [];

  /// Constructs a [LabelLoaderImpl].
  LabelLoaderImpl();

  @override
  Future<List<String>> loadLabels(String labelPath) async {
    // TODO: Load raw text files using rootBundle or File, split by newline, and parse indices.
    
    // Simulate loading latency.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    
    _labels.clear();
    _labels.addAll([
      'Heroin (Diacetylmorphine)',
      'Cocaine Hydrochloride',
      'Methamphetamine',
      'Morphine',
      'Fentanyl',
      'Cannabis',
      'MDMA (Ecstasy)',
    ]);
    
    return List.unmodifiable(_labels);
  }

  @override
  List<String> get labels => List.unmodifiable(_labels);

  @override
  bool get isLabelsLoaded => _labels.isNotEmpty;
}
