import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/constant/navigation_items.dart';
import 'package:smart_shop_app/screens/cart_screen.dart';
import 'package:smart_shop_app/screens/home_screen.dart';
import 'package:smart_shop_app/screens/product_list.dart';
import 'package:smart_shop_app/screens/wishlist_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


// Provider untuk mengatur state navigasi
final navigationProvider =
    StateNotifierProvider<NavigationController, int>((ref) {
  return NavigationController();
});

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    final screens = [
      const HomeScreen(),
      const ProductListScreen(),
      const CartScreen(),
      const WishlistScreen(),
      const HomeScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GNav(
          backgroundColor: Colors.white,
          gap: 8,
          padding: const EdgeInsets.all(10),
          selectedIndex: currentIndex,
          onTabChange: (index) {
            ref.read(navigationProvider.notifier).updateIndex(index);
          },
          tabBackgroundColor: AppColors.primary.withOpacity(0.2),
          tabs: [
            for (var item in navigationItems)
              GButton(
                icon: Icons.place,
                leading: item.icon,
                text: item.label,
              ),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends StateNotifier<int> {
  NavigationController() : super(0);

  void updateIndex(int index) {
    state = index;
  }
}
