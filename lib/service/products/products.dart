import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsService {
  String filter;

  ProductsService({required this.filter}) {
    print("Filter: $filter");
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await Supabase.instance.client
        .from("products")
        .select("*, categories(name)")
        .ilike('name', '%$filter%');

    return response;
  }
}

class ProductData {
  final int? id;
  final String? name;
  final String? description;
  final double price;
  final String? primary_color;
  final String? secondary_color;
  final int category_id;
  final String? image;

  ProductData(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.primary_color,
      required this.secondary_color,
      required this.category_id,
      required this.image});

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
        image: map["image"]);
  }

  // convert product -> map

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'description': description,
  //     'price': price,
  //     "primary_color": primary_color,
  //     "secondary_color": secondary_color
  //   };
  // }
}
