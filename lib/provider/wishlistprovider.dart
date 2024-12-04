import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/service/products/products.dart';

// StateNotifier to manage the wishlist
class WishlistNotifier extends StateNotifier<List<ProductData>> {
  WishlistNotifier() : super([]);

  // Method to add a product to the wishlist
  void addProduct(ProductData product) {
    state = [...state, product];
  }

  // Method to remove a product from the wishlist
  void removeProduct(ProductData product) {
    state = state.where((p) => p != product).toList();
  }
}

// Provider to manage wishlist state
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<ProductData>>((ref) {
  return WishlistNotifier();
});
