import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload image to Supabase storage bucket
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final String fileName = "${const Uuid().v4()}.jpg"; // Unique file name
      final String bucketName = "profiles"; // Bucket name in Supabase
      final String filePath = "$userId/$fileName";

      final response = await _supabase.storage.from(bucketName).upload(
            filePath,
            imageFile,
          );

      // Check if the response has an error (Supabase's response error check)
      if (response.error != null) {
        throw Exception("Failed to upload image: ${response.error!.message}");
      }

      // Retrieve the public URL of the uploaded image
      final String publicUrl =
          _supabase.storage.from(bucketName).getPublicUrl(filePath);

      return publicUrl; // Return the public URL of the uploaded image
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  /// Update user profile image in Supabase database
  Future<void> updateProfileImage(String userId, String imageUrl) async {
    try {
      final response = await _supabase
          .from('users') // Ensure your table name is 'users'
          .update({'avatar_url': imageUrl}).eq('id', userId);

      // Check if the response has an error (Supabase's response error check)
      if (response.error != null) {
        throw Exception(
            "Failed to update profile image: ${response.error!.message}");
      }
    } catch (e) {
      print("Error updating profile image: $e");
    }
  }
}

extension on String {
  get error => null;
}
