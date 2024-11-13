import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/provider/cartprovider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
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
                                padding: const EdgeInsets.all(24),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            cartItem.product.image,
                                            width: 34,
                                            height: 34,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.product.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Quantity: ${cartItem.quantity}',
                                              style: const TextStyle(
                                                fontFamily: 'Satoshi',
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(), // This pushes the next widget to the far right
                                        Text(
                                          'Total: \$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          iconSize: 24,
                                          onPressed: () {
                                            if (cartItem.quantity > 1) {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .addToCart(
                                                      cartItem.product, -1);
                                            } else {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .removeFromCart(
                                                      cartItem.product);
                                            }
                                          },
                                          style: IconButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.secondary),
                                        ),
                                        Text(
                                          '${cartItem.quantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          iconSize: 24,
                                          onPressed: () {
                                            ref
                                                .read(cartProvider.notifier)
                                                .addToCart(cartItem.product, 1);
                                          },
                                          style: IconButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primary),
                                        ),
                                      ],
                                    ),
                                  ],
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
                            double fontSize = screenWidth <= 451 ? 7.8 : 18;

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: \$${cartItems.fold(0.0, (total, cartItem) => total + (cartItem.product.price * cartItem.quantity)).toStringAsFixed(2)}',
                                    style: TextStyle(
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
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(24),
                                      backgroundColor: AppColors.primary,
                                      textStyle: TextStyle(),
                                    ),
                                    child: Text(
                                      'Checkout',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.background,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
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
                              style: TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            )),
                      ]),
                ),
              ),
      ],
    ));
  }
}

/* child: ListTile(
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
                                      Transform.translate(
                                        offset: const Offset(0,
                                            -10), // Adjust the offset if needed
                                        child: Text(
                                          'Quantity: ${cartItem.quantity}',
                                          style: const TextStyle(
                                            fontFamily: 'Satoshi',
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: ClipOval(
                                    child: Image.network(
                                      cartItem.product.image,
                                      width: 34,
                                      height: 34,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Total: \$${(cartItem.quantity * cartItem.product.price).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        iconSize: 24,
                                        onPressed: () {
                                          if (cartItem.quantity > 1) {
                                            ref
                                                .read(cartProvider.notifier)
                                                .addToCart(
                                                    cartItem.product, -1);
                                          } else {
                                            ref
                                                .read(cartProvider.notifier)
                                                .removeFromCart(
                                                    cartItem.product);
                                          }
                                        },
                                        style: IconButton.styleFrom(
                                            foregroundColor:
                                                AppColors.secondary),
                                      ),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        iconSize: 24,
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .addToCart(cartItem.product, 1);
                                        },
                                        style: IconButton.styleFrom(
                                            foregroundColor: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ), */
