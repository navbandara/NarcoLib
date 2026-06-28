import 'package:image_picker/image_picker.dart';

/// Service to handle device camera captures and gallery image selections.
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Captures an image using the device camera.
  /// Returns the file path of the captured image, or null if cancelled/failed.
  Future<String?> captureImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return file?.path;
    } catch (e) {
      // Handle potential camera access/usage errors.
      return null;
    }
  }

  /// Selects a single image from the device gallery.
  /// Returns the file path of the selected image, or null if cancelled/failed.
  Future<String?> selectFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return file?.path;
    } catch (e) {
      // Handle potential storage access/usage errors.
      return null;
    }
  }
}
