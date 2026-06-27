class ReportModel {
  final String id;
  final String scanResultId;
  final String reportNumber;
  final String officerId;
  final DateTime generatedAt;
  final String? pdfUrl;
  final String status;

  const ReportModel({
    required this.id,
    required this.scanResultId,
    required this.reportNumber,
    required this.officerId,
    required this.generatedAt,
    this.pdfUrl,
    required this.status,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      scanResultId: json['scanResultId'] as String,
      reportNumber: json['reportNumber'] as String,
      officerId: json['officerId'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      pdfUrl: json['pdfUrl'] as String?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanResultId': scanResultId,
      'reportNumber': reportNumber,
      'officerId': officerId,
      'generatedAt': generatedAt.toIso8601String(),
      'pdfUrl': pdfUrl,
      'status': status,
    };
  }
}
