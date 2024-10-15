import 'package:flutter/material.dart';
import 'package:smart_shop_app/screens/cart_screen.dart';
import 'package:smart_shop_app/screens/home_screen.dart';
import 'package:smart_shop_app/screens/product_detail_screen.dart';
import 'package:smart_shop_app/screens/product_list.dart';

void main() {
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FruitSmart',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/product-list': (context) => const ProductListScreen(),
        '/detail': (context) => const ProductDetailScreen(),
        "/cart": (context) => const CartScreen(),
      },
    );
  }
}




