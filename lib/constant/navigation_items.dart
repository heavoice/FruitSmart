import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';

class NavigationItem {
  final Widget icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}

List<NavigationItem> navigationItems = [
  const NavigationItem(
    icon: HugeIcon(
      icon: HugeIcons.strokeRoundedHome03,
      color: AppColors.darkSecondary,
      size: 24.0,
    ),
    label: 'Home',
  ),
  const NavigationItem(
    icon: HugeIcon(
      icon: HugeIcons.strokeRoundedGridView,
      color: AppColors.darkSecondary,
      size: 24.0,
    ),
    label: 'Produk',
  ),
  const NavigationItem(
    icon: HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBasket01,
      color: AppColors.darkSecondary,
      size: 24.0,
    ),
    label: 'Keranjang',
  ),
  const NavigationItem(
    icon: HugeIcon(
      icon: HugeIcons.strokeRoundedFavourite,
      color: AppColors.darkSecondary,
      size: 24.0,
    ),
    label: 'Wishlist',
  ),
  const NavigationItem(
    icon: HugeIcon(
      icon: HugeIcons.strokeRoundedInvoice01,
      color: AppColors.darkSecondary,
      size: 24.0,
    ),
    label: 'Transaksi',
  ),
];
