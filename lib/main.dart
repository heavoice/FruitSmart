import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/screens/cart_screen.dart';
import 'package:smart_shop_app/screens/home_screen.dart';
import 'package:smart_shop_app/screens/product_detail_screen.dart';
import 'package:smart_shop_app/screens/product_list.dart';
import 'package:smart_shop_app/screens/wishlist_screen.dart';

void main() {
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'FruitSmart',
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        routes: {
          '/homescreen': (context) => const HomeScreen(),
          '/product-list': (context) => const ProductListScreen(),
          '/detail': (context) => const ProductDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/wishlist': (context) => const WishlistScreen(),
        },
      ),
    );
  }
}
