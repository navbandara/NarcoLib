class LocationModel {
  final String id;
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;
  final String status;

  const LocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    required this.status,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
