class ScanResultModel {
  final String id;
  final String officerId;
  final DateTime timestamp;
  final String predictedSubstance;
  final double confidence;
  final String riskLevel;
  final String legalReference;
  final double latitude;
  final double longitude;
  final String address;
  final Map<String, double> alternativeMatches;

  const ScanResultModel({
    required this.id,
    required this.officerId,
    required this.timestamp,
    required this.predictedSubstance,
    required this.confidence,
    required this.riskLevel,
    required this.legalReference,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.alternativeMatches = const {},
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    final altMap = <String, double>{};
    if (json['alternativeMatches'] != null) {
      final matches = json['alternativeMatches'] as Map<String, dynamic>;
      matches.forEach((key, value) {
        altMap[key] = (value as num).toDouble();
      });
    }

    return ScanResultModel(
      id: json['id'] as String,
      officerId: json['officerId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      predictedSubstance: json['predictedSubstance'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      legalReference: json['legalReference'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      alternativeMatches: altMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'officerId': officerId,
      'timestamp': timestamp.toIso8601String(),
      'predictedSubstance': predictedSubstance,
      'confidence': confidence,
      'riskLevel': riskLevel,
      'legalReference': legalReference,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'alternativeMatches': alternativeMatches,
    };
  }
}
