import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_shop_app/config/theme/app_theme.dart';
import 'package:smart_shop_app/screens/auth_screen.dart';
import 'package:smart_shop_app/screens/category_screen.dart';
import 'package:smart_shop_app/screens/main_screen.dart';
import 'package:smart_shop_app/screens/product_category.dart';
import 'package:smart_shop_app/screens/product_list.dart';
import 'package:smart_shop_app/screens/profile_screen.dart';
import 'package:smart_shop_app/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/screens/cart_screen.dart';
import 'package:smart_shop_app/screens/product_detail_screen.dart';
import 'package:smart_shop_app/screens/wishlist_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(
    fileName: ".env",
  );

  await Supabase.initialize(
    url: "https://giklwkgxdezeqlzbohxf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdpa2x3a2d4ZGV6ZXFsemJvaHhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMyNzgwMjYsImV4cCI6MjA0ODg1NDAyNn0.tRShy64KNkB2acq3fiNsnOwnnAxMyNcyiYinS-Aj6CY",
  );

  runApp(const NeedifyApp());
}

final supabase = Supabase.instance.client;

class NeedifyApp extends StatelessWidget {
  const NeedifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Needify',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/auth': (context) => const AuthScreen(),
          "/home": (context) => const SplashScreen(),
          '/product-list': (context) => ProductListScreen(),
          '/detail': (context) => const ProductDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/wishlist': (context) => const WishlistScreen(),
          "/main": (context) => const MainScreen(),
          'profile': (context) => ProfileScreen(),
          "/category": (context) => const CategoryScreen(),
          "/product-category": (context) => const ProductCategoryScreen(),
        },
      ),
    );
  }
}
