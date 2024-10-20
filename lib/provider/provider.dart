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
    final existingItemIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Jika item sudah ada di keranjang, tambahkan jumlahnya
      state[existingItemIndex].quantity += quantity;
      state = [...state]; // Perbarui state untuk memicu UI update
    } else {
      // Jika item tidak ada, tambahkan item baru dengan jumlah tertentu
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) {
  return CartProvider();
});
