class EvidenceModel {
  final String id;
  final String? scanResultId;
  final String imageUrl;
  final String sampleId;
  final String substanceLabel;
  final DateTime timestamp;
  final double confidence;

  const EvidenceModel({
    required this.id,
    this.scanResultId,
    required this.imageUrl,
    required this.sampleId,
    required this.substanceLabel,
    required this.timestamp,
    required this.confidence,
  });

  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      id: json['id'] as String,
      scanResultId: json['scanResultId'] as String?,
      imageUrl: json['imageUrl'] as String,
      sampleId: json['sampleId'] as String,
      substanceLabel: json['substanceLabel'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanResultId': scanResultId,
      'imageUrl': imageUrl,
      'sampleId': sampleId,
      'substanceLabel': substanceLabel,
      'timestamp': timestamp.toIso8601String(),
      'confidence': confidence,
    };
  }
}
