import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsService {
  late String? filter = "";

  ProductsService({this.filter});

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await Supabase.instance.client
        .from("products")
        .select(
          "id, primary_color, secondary_color, name, description, price, image, total_sold",
        )
        .ilike('name', '%$filter%');

    return response;
  }

  Future<List<Map<String, dynamic>>> getBestProducts() async {
    final response = await Supabase.instance.client
        .from("products")
        .select(
          "id, primary_color, secondary_color, name, description, price, image, total_sold",
        )
        .order("total_sold", ascending: true);

    return response;
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final response = await Supabase.instance.client
        .from("products")
        .select(
          "*",
        )
        .eq('id', id)
        .single();

    return response;
  }

  Future<List<Map<String, dynamic>>> getProductByCategoryId(int id) async {
    final response = await Supabase.instance.client
        .from("products")
        .select(
          "*",
        )
        .eq('category_id', id);

    return response;
  }
}

class ProductData {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final String? primary_color;
  final String? secondary_color;
  final int? category_id;
  final String? image;
  final int? totalSold;

  ProductData(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.primary_color,
      this.secondary_color,
      this.category_id,
      this.image,
      this.totalSold});

  // convert map -> product

  factory ProductData.fromMap(Map<String, dynamic> map) {
    return ProductData(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'] is int
            ? (map['price'] as int).toDouble()
            : map['price'],
        primary_color: map['primary_color'],
        secondary_color: map['secondary_color'],
        category_id: map['category_id'],
        image: map["image"],
        totalSold: map["total_sold"]);
  }
}
