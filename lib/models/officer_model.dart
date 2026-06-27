class OfficerModel {
  final String id;
  final String name;
  final String badgeNumber;
  final String agency;
  final String email;
  final String? profileImageUrl;

  const OfficerModel({
    required this.id,
    required this.name,
    required this.badgeNumber,
    required this.agency,
    required this.email,
    this.profileImageUrl,
  });

  factory OfficerModel.fromJson(Map<String, dynamic> json) {
    return OfficerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      badgeNumber: json['badgeNumber'] as String,
      agency: json['agency'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'badgeNumber': badgeNumber,
      'agency': agency,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }
}
