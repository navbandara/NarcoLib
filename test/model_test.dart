import 'package:flutter_test/flutter_test.dart';

import 'package:narcolib_app/models/officer_model.dart';
import 'package:narcolib_app/models/scan_result_model.dart';
import 'package:narcolib_app/models/evidence_model.dart';
import 'package:narcolib_app/models/location_model.dart';
import 'package:narcolib_app/models/report_model.dart';

void main() {
  group('NarcoLib Data Models Serialization Tests', () {
    test('OfficerModel serialization', () {
      final json = {
        'id': 'off-1',
        'name': 'Officer John Doe',
        'badgeNumber': 'B-12345',
        'agency': 'NCB',
        'email': 'john@ncb.gov',
        'profileImageUrl': 'https://example.com/profile.jpg',
      };

      final model = OfficerModel.fromJson(json);
      expect(model.id, 'off-1');
      expect(model.name, 'Officer John Doe');
      expect(model.badgeNumber, 'B-12345');
      expect(model.agency, 'NCB');
      expect(model.email, 'john@ncb.gov');
      expect(model.profileImageUrl, 'https://example.com/profile.jpg');

      final serialized = model.toJson();
      expect(serialized, json);
    });

    test('ScanResultModel serialization', () {
      final json = {
        'id': 'scan-1',
        'officerId': 'off-1',
        'timestamp': '2026-06-27T18:36:31.000Z',
        'predictedSubstance': 'Heroin (Diacetylmorphine)',
        'confidence': 94.7,
        'riskLevel': 'HIGH RISK',
        'legalReference': 'Section 54',
        'latitude': 6.9271,
        'longitude': 79.8612,
        'address': 'Colombo, Sri Lanka',
        'alternativeMatches': {
          'Cocaine': 4.2,
          'Meth': 1.1,
        },
      };

      final model = ScanResultModel.fromJson(json);
      expect(model.id, 'scan-1');
      expect(model.predictedSubstance, 'Heroin (Diacetylmorphine)');
      expect(model.confidence, 94.7);
      expect(model.alternativeMatches['Cocaine'], 4.2);

      final serialized = model.toJson();
      expect(serialized['id'], 'scan-1');
      expect(serialized['alternativeMatches']['Cocaine'], 4.2);
    });

    test('EvidenceModel serialization', () {
      final json = {
        'id': 'ev-1',
        'scanResultId': 'scan-1',
        'imageUrl': 'assets/sample.png',
        'sampleId': 'SMP-8902',
        'substanceLabel': 'Cocaine',
        'timestamp': '2026-06-27T12:00:00.000Z',
        'confidence': 98.2,
      };

      final model = EvidenceModel.fromJson(json);
      expect(model.id, 'ev-1');
      expect(model.scanResultId, 'scan-1');
      expect(model.substanceLabel, 'Cocaine');
      expect(model.confidence, 98.2);

      final serialized = model.toJson();
      expect(serialized, json);
    });

    test('LocationModel serialization', () {
      final json = {
        'id': 'loc-1',
        'latitude': 6.9271,
        'longitude': 79.8612,
        'accuracy': 3.4,
        'timestamp': '2026-06-27T12:00:00.000Z',
        'status': 'active',
      };

      final model = LocationModel.fromJson(json);
      expect(model.id, 'loc-1');
      expect(model.latitude, 6.9271);
      expect(model.accuracy, 3.4);
      expect(model.status, 'active');

      final serialized = model.toJson();
      expect(serialized, json);
    });

    test('ReportModel serialization', () {
      final json = {
        'id': 'rep-1',
        'scanResultId': 'scan-1',
        'reportNumber': 'REP-2026-001',
        'officerId': 'off-1',
        'generatedAt': '2026-06-27T12:00:00.000Z',
        'pdfUrl': 'https://example.com/report.pdf',
        'status': 'signed',
      };

      final model = ReportModel.fromJson(json);
      expect(model.id, 'rep-1');
      expect(model.scanResultId, 'scan-1');
      expect(model.reportNumber, 'REP-2026-001');
      expect(model.pdfUrl, 'https://example.com/report.pdf');
      expect(model.status, 'signed');

      final serialized = model.toJson();
      expect(serialized, json);
    });
  });
}
