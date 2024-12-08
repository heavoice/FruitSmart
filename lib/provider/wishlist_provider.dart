import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/service/wishlist/wishlist_service.dart';

final wishlistProvider =
    FutureProvider.family<bool, int>((ref, productId) async {
  return WishlistService().isInWishlist(productId);
});
