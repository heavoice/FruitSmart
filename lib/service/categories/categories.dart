import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesService {
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return await Supabase.instance.client.from("categories").select().limit(4);
  }
}

class Category {
  int id;
  String? name;
  String? thumbnail_url;

  Category({required this.id, this.name, this.thumbnail_url});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      thumbnail_url: map['thumbnail_url'],
    );
  }
}
