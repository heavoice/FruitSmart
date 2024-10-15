import 'package:flutter/material.dart';
import 'package:smart_shop_app/dummy/fruits_list.dart';

class Cart {
  List<CartItem> items = [];

  void add(Product product) {
    // Check if the product is already in the cart
    final existingItem = items.firstWhere(
      (item) => item.product.id == product.id, // Ensure Product has 'id'
      orElse: () => CartItem(
          product: product, quantity: 0), // Return a default item if not found
    );

    if (existingItem.quantity > 0) {
      // If exists, increase the quantity
      existingItem.quantity++;
    } else {
      // If not, add a new item
      items.add(CartItem(product: product));
    }
  }

  void clear() {
    items.clear();
  }
}

// Create an instance of Cart
final Cart cart = Cart(); // Rename cart variable to avoid conflict

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the cart items from the provider (or state management)
    final cartItems =
        cart.items; // Assuming you have a cart object that manages the cart

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(item.product.image),
                  title: Text(item.product.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing:
                      Text('Price: \$${item.product.price * item.quantity}'),
                );
              },
            ),
    );
  }
}
