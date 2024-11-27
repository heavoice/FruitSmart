import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_shop_app/config/theme/app_theme.dart';
import 'package:smart_shop_app/screens/auth_screen.dart';
import 'package:smart_shop_app/screens/main_screen.dart';
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
    url: dotenv.env["DB_URL"] as String,
    anonKey: dotenv.env["DB_API_KEY"] as String,
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
        title: 'FruitSmart',
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
        },
      ),
    );
  }
}
