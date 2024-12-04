import 'dart:developer';

import 'package:smart_shop_app/main.dart';
import 'package:smart_shop_app/service/products/products.dart';

class Wishlist {
  final int id;
  final ProductData product;
  final int user_id;

  Wishlist({required this.id, required this.product, required this.user_id});

  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      id: map['id'],
      product: map['product'],
      user_id: map['user_id'],
    );
  }
}

class WishlistService {
  Future<List<Map<String, dynamic>>>? getWishlist() {
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    final res = supabase
        .from("wishlist")
        .select("* , product_id(*)")
        .eq("user_id", currentUser.id);

    return res;
  }

  Future<bool> isInWishlist(int? productId) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return false;
    if (productId == null) return false;

    final res = await supabase
        .from('wishlist')
        .select()
        .eq('user_id', currentUser.id)
        .eq('product_id', productId);

    log(res.toString());

    if (res.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> addWishlist(int? product_id) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return null;
    if (product_id == null) return null;

    final res = await supabase.from("wishlist").upsert([
      {"product_id": product_id, "user_id": currentUser.id}
    ]);

    return res;
  }

  Future<void> removeWishlist(int? product_id) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return null;
    if (product_id == null) return null;

    final res = await supabase
        .from("wishlist")
        .delete()
        .eq("user_id", currentUser.id)
        .eq("product_id", product_id);

    return res;
  }
}
