import 'dart:async';
import '../models/evidence_model.dart';

/// Service to handle fetching and uploading of evidence gallery photos.
class GalleryService {
  /// Fetches a list of historical evidence photo models from local storage or remote database.
  Future<List<EvidenceModel>> getEvidencePhotos() async {
    // TODO: Connect database or filesystem to scan list of evidence images and construct EvidenceModel objects.
    return const [];
  }

  /// Uploads a new evidence picture into database storage.
  /// Returns a completed [EvidenceModel] representation of the uploaded asset.
  Future<EvidenceModel> uploadEvidencePhoto(String localImagePath, String substanceLabel, double confidence) async {
    // TODO: Copy local image file to persistent storage, upload metadata, and return the new model record.
    return EvidenceModel(
      id: 'mock-id',
      imageUrl: localImagePath,
      sampleId: 'SMP-MOCK',
      substanceLabel: substanceLabel,
      timestamp: DateTime.now(),
      confidence: confidence,
    );
  }
}
