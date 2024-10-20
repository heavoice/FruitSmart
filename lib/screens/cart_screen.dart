import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/provider/provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 100,
              title: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/product-list');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFF5F5F5),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF130F26),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFF5F5F5),
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF130F26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFFFFF1AD),
              elevation: 0,
              pinned: true,
            ),
            cartItems.isNotEmpty
                ? SliverFillRemaining(
                    child: Container(
                      color: const Color(0xFFFFF1AD),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to FruitSmart',
                                style: GoogleFonts.poppins(
                                    fontSize: () {
                                      double screenWidth =
                                          MediaQuery.of(context).size.width;
                                      if (screenWidth >= 200) {
                                        return 20.0;
                                      }
                                      if (screenWidth >= 640) {
                                        return 24.0;
                                      } else {
                                        return 0.0;
                                      }
                                    }(),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ...List.generate(
                                cartItems.length,
                                (index) {
                                  final cartItem = cartItems[index];
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        cartItem.product.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Quantity: ${cartItem.quantity}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      leading: ClipOval(
                                        child: Image.network(
                                          cartItem.product.image,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit
                                              .cover, // Memastikan gambar terisi dengan baik dalam lingkaran
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Total: \$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (cartItem.quantity > 1) {
                                                // Kurangi jumlah jika lebih dari 1
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .addToCart(
                                                        cartItem.product, -1);
                                              }
                                            },
                                          ),
                                          Text(
                                            '${cartItem.quantity}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              // Tambahkan jumlah
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .addToCart(
                                                      cartItem.product, 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ]),
                      ),
                    ),
                  )
                : SliverFillRemaining(
                    child: Container(
                      color: const Color(
                          0xFFFFF1AD), // Latar belakang penuh untuk keranjang kosong
                      child: Center(
                        child: Text(
                          "Your cart is empty",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
