import 'package:smart_shop_app/main.dart';
import 'package:smart_shop_app/service/products/products.dart';

class Cart {
  final int id;
  final int product_id;
  final String product_name;
  final String product_image;
  final int product_price;
  final int quantity;

  Cart({
    required this.id,
    required this.product_id,
    required this.quantity,
    required this.product_name,
    required this.product_image,
    required this.product_price,
  });

  factory Cart.fromMap(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      product_id: json['product_id'],
      product_name: json['product_name'],
      product_price: json['product_price'],
      product_image: json['product_image'],
      quantity: json['quantity'],
    );
  }
}

class CartService {
  addToCart(ProductData product, quantity) async {
    // Add product to cart
    final currentUser = await supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    Map<String, dynamic>? isProductInCart = await supabase
        .from('cart')
        .select()
        .eq('user_id', currentUser.id)
        .eq('product_id', product.id as int)
        .maybeSingle();

    if (isProductInCart != null) {
      await supabase
          .from('cart')
          .update({
            'quantity': isProductInCart['quantity'] + quantity,
          })
          .eq("user_id", currentUser.id)
          .eq("product_id", product.id as int);
    } else {
      await supabase.from('cart').insert({
        'user_id': currentUser.id,
        'product_id': product.id,
        'product_price': product.price,
        'product_name': product.name,
        'product_image': product.image,
        'quantity': quantity,
      });
    }
  }

  decreaseQuantity(int product_id) async {
    final currentUser = await supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    Map<String, dynamic>? isProductInCart = await supabase
        .from('cart')
        .select()
        .eq('user_id', currentUser.id)
        .eq('product_id', product_id)
        .maybeSingle();

    if (isProductInCart != null) {
      if (isProductInCart['quantity'] > 1) {
        await supabase
            .from('cart')
            .update({
              'quantity': isProductInCart['quantity'] - 1,
            })
            .eq("user_id", currentUser.id)
            .eq("product_id", product_id);
      } else {
        await removeFromCart(product_id);
      }
    }
  }

  inCreaseQuantity(int product_id) async {
    final currentUser = await supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    Map<String, dynamic>? isProductInCart = await supabase
        .from('cart')
        .select()
        .eq('user_id', currentUser.id)
        .eq('product_id', product_id)
        .maybeSingle();

    if (isProductInCart != null) {
      await supabase
          .from('cart')
          .update({
            'quantity': isProductInCart['quantity'] + 1,
          })
          .eq("user_id", currentUser.id)
          .eq("product_id", product_id);
    }
  }

  removeFromCart(int id) async {
    // Remove product from cart
    final currentUser = await supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    await supabase.from('cart').delete().eq('id', id);
  }

  Stream? getCartItems() {
    // Get all cart items
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    return supabase.from('cart').stream(primaryKey: ['id']).map((items) {
      return items.where((item) => item['user_id'] == currentUser.id).toList();
    });
  }
}
