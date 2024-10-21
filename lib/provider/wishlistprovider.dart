import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/dummy/fruits_list.dart'; // Import the correct Product class

// StateNotifier to manage the wishlist
class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]);

  // Method to add a product to the wishlist
  void addProduct(Product product) {
    state = [...state, product];
  }

  // Method to remove a product from the wishlist
  void removeProduct(Product product) {
    state = state.where((p) => p != product).toList();
  }
}

// Provider to manage wishlist state
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<Product>>((ref) {
  return WishlistNotifier();
});
