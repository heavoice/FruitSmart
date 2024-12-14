import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/main.dart';
import 'package:smart_shop_app/service/cart/cart_service.dart';
import 'package:smart_shop_app/service/transaction/transaction_service.dart';
import 'package:smart_shop_app/widget/app_dialog.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double _calculateTotalPrice(List<Map<String, dynamic>> cartItems) {
      if (cartItems.isEmpty) return 0;

      return cartItems.fold(
          0.0, (sum, item) => sum + (item["product_price"] * item["quantity"]));
    }

    return Scaffold(
      body: StreamBuilder(
        stream: CartService().getCartItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data.isEmpty ||
              snapshot.connectionState == ConnectionState.waiting) {
            return CustomScrollView(slivers: [
              SliverAppBar(
                toolbarHeight: 100,
                title: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cart',
                        style: TextStyle(
                          color: AppColors.darkBackground,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Satoshi",
                        ),
                      ),
                    ],
                  ),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.background,
                elevation: 0,
                pinned: false,
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        title: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(45),
                        ),
                      );
                    },
                    childCount: 4,
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Text(
                        'No Product Found',
                      ),
                    ),
                  ),
                ),
            ]);
          }

          // Extract cart data
          final cartItems = snapshot.data;
          final totalPrice = _calculateTotalPrice(cartItems);

          return Stack(
            children: [
              // Main content (Scrollable content)
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    toolbarHeight: 100,
                    title: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cart',
                            style: TextStyle(
                              color: AppColors.darkBackground,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Satoshi",
                            ),
                          ),
                        ],
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.background,
                    elevation: 0,
                    pinned: false,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ListTile(
                            title: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(20),
                              child: CartItem(
                                cartItem: Cart.fromMap(cartItems[index]),
                              ),
                            ),
                          );
                        },
                        childCount: cartItems.length,
                      ),
                    ),
                  ),
                ],
              ),

              // Fixed Bottom Section
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: AppColors.background,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkBackground,
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AppDialog(
                                  title: "Checkout",
                                  message: "Are you sure want to checkout?",
                                  onConfirm: () async {
                                    try {
                                      final currentUser =
                                          supabase.auth.currentUser;

                                      if (currentUser == null) {
                                        return;
                                      }

                                      final payload = cartItems.map((item) {
                                        return {
                                          "product_id": item["product_id"],
                                          "quantity": item["quantity"],
                                          "total_price": item["product_price"] *
                                              item["quantity"],
                                          "status": "process",
                                          "user_id": currentUser.id,
                                        };
                                      }).toList();

                                      final res = await TransactionService()
                                          .addTransaction(payload);

                                      if (res) {
                                        await CartService().clearCart();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Transaction successfully completed!"),
                                          backgroundColor: AppColors.primary,
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Failed to complete transaction!"),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ));
                                    } finally {
                                      Navigator.pop(context);
                                    }
                                  },
                                  cancelText: "Cancel",
                                  confirmText: "Checkout",
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({Key? key, required this.cartItem}) : super(key: key);
  final Cart cartItem;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.network(
              widget.cartItem.product_image,
              width: 50,
              height: 50,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cartItem.product_name,
                  style: TextStyle(
                    color: AppColors.darkBackground,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Satoshi",
                  ),
                ),
                Text(
                  '\$ ${widget.cartItem.product_price * widget.cartItem.quantity}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.grayText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Satoshi",
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                onPressed: () async {
                  if (widget.cartItem.quantity == 1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AppDialog(
                          title: "Remove from cart!",
                          message: "Are you sure want to remove this product?",
                          onConfirm: () async {
                            try {
                              await CartService()
                                  .removeFromCart(widget.cartItem.id);
                            } catch (e) {
                            } finally {
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          cancelText: "Cancel",
                          confirmText: "Remove",
                        );
                      },
                    );
                  } else {
                    await CartService().decreaseQuantity(
                      widget.cartItem.product_id,
                    );
                  }
                },
                icon: Icon(
                  Icons.remove,
                  size: 14,
                ),
                color: AppColors.background,
                alignment: Alignment.center,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.red[400],
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  widget.cartItem.quantity.toString(),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                onPressed: () async {
                  await CartService().inCreaseQuantity(
                    widget.cartItem.product_id,
                  );
                },
                icon: Icon(
                  Icons.add,
                  size: 14,
                ),
                color: AppColors.background,
                alignment: Alignment.center,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.primary,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
