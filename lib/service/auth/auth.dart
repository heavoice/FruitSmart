
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient db = Supabase.instance.client;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await db.auth.signInWithPassword(password: password, email: email);
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final res = await db.from('users').select().eq('email', email).single();
      if (res.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String username) async {
    bool isRegistered = await isEmailRegistered(email);

    if (isRegistered) {
      throw Exception("Email already registered");
    }

    await db.auth.signUp(password: password, email: email, data: {
      "display_name": username,
    });
  }

  Future<void> logOut() async {
    await db.auth.signOut();
  }

  // Get the current user

  User? getCurrentUser() {
    final user = db.auth.currentUser;

    return user;
  }
}
