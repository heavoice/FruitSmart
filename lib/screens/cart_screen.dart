import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/provider/cartprovider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              toolbarHeight: 100,
              title: Padding(
                padding: EdgeInsets.all(20),
                child: Row(children: [
                  Text(
                    'Checkout',
                    style: TextStyle(
                      color: AppColors.darkBackground,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Satoshi",
                    ),
                  ),
                ]),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.background,
              elevation: 0,
              pinned: true,
            ),
            cartItems.isNotEmpty
                ? SliverFillRemaining(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Expanded(
                              child: ListView.builder(
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final cartItem = cartItems[index];
                                  return Container(
                                    padding: const EdgeInsets.all(4),
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
                                    child: Builder(
                                      builder: (context) {
                                        double screenWidth =
                                            MediaQuery.of(context).size.width;
                                        double fontSize =
                                            screenWidth <= 451 ? 7 : 18;
                                        double iconSize =
                                            screenWidth <= 451 ? 14 : 24;

                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            cartItem.product.name,
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                offset: Offset(
                                                  0, // No horizontal translation
                                                  screenWidth <= 451
                                                      ? -10
                                                      : 0, // Move the widget up by 10 pixels when the screen width is <= 451, otherwise no translation
                                                ),
                                                child: Text(
                                                  'Quantity: ${cartItem.quantity}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontSize - 2,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          leading: ClipOval(
                                            child: Image.network(
                                              cartItem.product.image,
                                              width: iconSize + 10,
                                              height: iconSize + 10,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Total: \$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(2)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontSize - 2,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                iconSize: iconSize,
                                                onPressed: () {
                                                  if (cartItem.quantity > 1) {
                                                    ref
                                                        .read(cartProvider
                                                            .notifier)
                                                        .addToCart(
                                                            cartItem.product,
                                                            -1);
                                                  } else {
                                                    ref
                                                        .read(cartProvider
                                                            .notifier)
                                                        .removeFromCart(
                                                            cartItem.product);
                                                  }
                                                },
                                              ),
                                              Text(
                                                '${cartItem.quantity}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                iconSize: iconSize,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .addToCart(
                                                          cartItem.product, 1);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // Define responsive styles based on screen width
                                double screenWidth =
                                    MediaQuery.of(context).size.width;
                                double fontSize = screenWidth <= 451 ? 7 : 18;

                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total: \$${cartItems.fold(0.0, (total, cartItem) => total + (cartItem.product.price * cartItem.quantity)).toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .clearCart();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'You have checked out \$${cartItems.fold(0.0, (total, cartItem) => total + (cartItem.product.price * cartItem.quantity)).toStringAsFixed(2)}!'),
                                              backgroundColor: Colors.green,
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(),
                                          backgroundColor: Colors.white,
                                          textStyle: TextStyle(),
                                        ),
                                        child: Text(
                                          'Checkout',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverFillRemaining(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 8),
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 300,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Your cart is empty",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                )),
                          ]),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
