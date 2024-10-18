import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/dummy/fruits_list.dart';

final quantityProvider = StateProvider<int>((ref) => 0);

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends StateNotifier<List<CartItem>> {
  CartProvider() : super([]);

  void addToCart(Product product, int quantity) {
    final existingItem = state.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++; // Increase quantity if exists
    } else {
      state = [...state, CartItem(product: product)]; // Add new item
    }
  }

  void clearCart() {
    state = [];
  }
}

// Define the provider
final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) {
  return CartProvider();
});
