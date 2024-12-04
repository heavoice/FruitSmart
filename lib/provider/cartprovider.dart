import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/service/products/products.dart';

final quantityProvider = StateProvider<int>((ref) => 1);

class CartItem {
  final ProductData product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends StateNotifier<List<CartItem>> {
  CartProvider() : super([]);

  void addToCart(ProductData product, int quantity) {
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

  void removeFromCart(ProductData product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) {
  return CartProvider();
});
