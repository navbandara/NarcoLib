/// Represents the detailed outcome of an AI substance classification task.
///
/// Encapsulates the identified substance category, model confidence, processing duration,
/// timestamp, image metadata, and associated legal classification and protocols.
class PredictionResult {
  /// The primary substance class identified by the prediction model.
  final String predictedClass;

  /// The confidence score of the prediction, ranging from 0.0 to 1.0.
  final double confidence;

  /// The duration taken by the AI processing workflow (preprocessing, inference, postprocessing).
  final Duration processingTime;

  /// The date and time when the prediction was generated.
  final DateTime predictionDate;

  /// The local filesystem path of the classified sample image.
  final String imagePath;

  /// The legal category or Ordinance ordinance schedule mapping for the identified substance.
  final String legalCategory;

  /// Recommended safety, handling, or documentation protocols for the identified substance.
  final String recommendation;

  /// Constructs a [PredictionResult].
  const PredictionResult({
    required this.predictedClass,
    required this.confidence,
    required this.processingTime,
    required this.predictionDate,
    required this.imagePath,
    required this.legalCategory,
    required this.recommendation,
  });

  /// Creates a copy of this [PredictionResult] with the given fields replaced by the new values.
  PredictionResult copyWith({
    String? predictedClass,
    double? confidence,
    Duration? processingTime,
    DateTime? predictionDate,
    String? imagePath,
    String? legalCategory,
    String? recommendation,
  }) {
    return PredictionResult(
      predictedClass: predictedClass ?? this.predictedClass,
      confidence: confidence ?? this.confidence,
      processingTime: processingTime ?? this.processingTime,
      predictionDate: predictionDate ?? this.predictionDate,
      imagePath: imagePath ?? this.imagePath,
      legalCategory: legalCategory ?? this.legalCategory,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  /// Factory constructor to create a prediction result with default empty/unclassified values.
  factory PredictionResult.empty() {
    return PredictionResult(
      predictedClass: 'Unknown',
      confidence: 0.0,
      processingTime: Duration.zero,
      predictionDate: DateTime.fromMillisecondsSinceEpoch(0),
      imagePath: '',
      legalCategory: 'Unknown',
      recommendation: 'None',
    );
  }

  /// Factory constructor to create a [PredictionResult] from a JSON map.
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json['predictedClass'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      processingTime: Duration(milliseconds: json['processingTimeMs'] as int),
      predictionDate: DateTime.parse(json['predictionDate'] as String),
      imagePath: json['imagePath'] as String,
      legalCategory: json['legalCategory'] as String,
      recommendation: json['recommendation'] as String,
    );
  }

  /// Converts this [PredictionResult] into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'predictedClass': predictedClass,
      'confidence': confidence,
      'processingTimeMs': processingTime.inMilliseconds,
      'predictionDate': predictionDate.toIso8601String(),
      'imagePath': imagePath,
      'legalCategory': legalCategory,
      'recommendation': recommendation,
    };
  }

  @override
  String toString() {
    return 'PredictionResult(predictedClass: $predictedClass, confidence: $confidence, processingTime: ${processingTime.inMilliseconds}ms)';
  }
}
