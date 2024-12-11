import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient db = Supabase.instance.client;

  /// Fungsi untuk membuat atau memperbarui profil pengguna
  Future<void> createUserProfile(
      String userId, String username, String profileImageUrl) async {
    try {
      // Menyisipkan atau memperbarui data pengguna di tabel "users"
      final response = await db.from('users').upsert({
        'id': userId, // Primary key (id)
        'username': username,
        'profile_image': profileImageUrl,
      }).select();

      if (response.isEmpty) {
        throw Exception("Failed to insert or update user profile.");
      }
    } catch (e) {
      throw Exception("Failed to create user profile: $e");
    }
  }

  /// Fungsi untuk mengambil profil pengguna berdasarkan userId
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      // Mengambil data pengguna berdasarkan id
      final response =
          await db.from('users').select().eq('id', userId).single();
      return response;
    } catch (e) {
      throw Exception("Failed to fetch user profile: $e");
    }
  }

  /// Fungsi untuk memperbarui gambar profil pengguna
  Future<void> updateUserProfileImage(String userId, String imageUrl) async {
    try {
      final response = await db
          .from('users')
          .update({'profile_image': imageUrl}) // Memperbarui URL gambar profil
          .eq('id', userId)
          .select();

      if (response.error != null) {
        throw Exception(
            'Error updating profile image: ${response.error!.message}');
      }
    } catch (e) {
      throw Exception("Failed to update user profile image: $e");
    }
  }

  Future<String?> getUserProfileImage(String userId) async {
    try {
      final response = await db
          .from('users')
          .select('profile_image')
          .eq('id', userId)
          .single();
      return response['profile_image'] as String?;
    } catch (e) {
      throw Exception("Failed to fetch profile image: $e");
    }
  }
}

extension on PostgrestList {
  get error => null;
}
