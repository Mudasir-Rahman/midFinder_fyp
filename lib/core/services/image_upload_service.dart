import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadService {
  final SupabaseClient _supabaseClient;

  ImageUploadService(this._supabaseClient);

  Future<String?> uploadMedicineImage(
      XFile imageFile,
      String medicineId, {
        Function(double)? onProgress,
      }) async {
    try {
      // Convert XFile to File
      final file = File(imageFile.path);

      // Get file bytes
      final bytes = await file.readAsBytes();

      // Get file extension and create unique file name
      final fileExtension = path.extension(imageFile.path);
      final fileName = 'medicine_${medicineId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      // Upload to Supabase Storage - Use uploadBinary for bytes
      final response = await _supabaseClient.storage
          .from('medicine_images')
          .uploadBinary(
        fileName,
        bytes,
        fileOptions: FileOptions(
          upsert: true,
          contentType: _getMimeType(fileExtension), // This method is defined below
        ),
      );

      // Get public URL
      final publicUrl = _supabaseClient.storage
          .from('medicine_images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // ADD THIS METHOD - Helper method to determine MIME type
  String _getMimeType(String fileExtension) {
    switch (fileExtension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default to jpeg if unknown
    }
  }

  // Optional: Alternative method using file path (more efficient for large files)
  Future<String?> uploadMedicineImageFromPath(
      String imagePath,
      String medicineId,
      ) async {
    try {
      final file = File(imagePath);
      final fileExtension = path.extension(imagePath);
      final fileName = 'medicine_${medicineId}_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      // Upload using the file directly
      await _supabaseClient.storage
          .from('medicine_images')
          .upload(
        fileName,
        file,
        fileOptions: FileOptions(
          upsert: true,
          contentType: _getMimeType(fileExtension),
        ),
      );

      // Get public URL
      final publicUrl = _supabaseClient.storage
          .from('medicine_images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> deleteMedicineImage(String imageUrl) async {
    try {
      // Extract file name from URL
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        final fileName = segments.last;
        await _supabaseClient.storage
            .from('medicine_images')
            .remove([fileName]);
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Method to check if image exists
  Future<bool> checkImageExists(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      if (segments.length >= 2) {
        final fileName = segments.last;
        final response = await _supabaseClient.storage
            .from('medicine_images')
            .list(path: fileName);
        return response.isNotEmpty;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
