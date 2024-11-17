import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesService {
  final SupabaseClient db = Supabase.instance.client;

  Stream<Object?> getAllCategories() {
    final response = db.from("categories").stream(primaryKey: ["id"]);

    return response;
  }

  Future getCategoryById(String id) {
    final response = db.from("categories").select().eq("id", id);

    return response;
  }
}
