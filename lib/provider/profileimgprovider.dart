import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/service/user/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userProfileImageProvider = FutureProvider<String?>((ref) async {
  // Get the current user from Supabase authentication
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    // Fetch the user's profile image using the UserService
    final userService = UserService();
    return await userService.getUserProfileImage(user.id);
  } else {
    return null; // Return null if the user is not authenticated
  }
});
