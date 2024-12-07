import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/provider/navprovider.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/provider/quantity_provider.dart';
import 'package:smart_shop_app/service/products/products.dart';
import 'package:smart_shop_app/service/wishlist/wishlist_service.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = ModalRoute.of(context)!.settings.arguments as int?;
    final ProductsService productsService = ProductsService();
    final quantityNotifier = ref.read(quantityProvider.notifier);

    if (productId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          title: const CustomAppBar(),
        ),
        body: const Center(
          child: Text('Product not found.'),
        ),
      );
    }

    return FutureBuilder(
        future: productsService.getProductById(
          productId,
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          final product = snapshot.data;

          if (product == null) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                toolbarHeight: 80,
                title: const CustomAppBar(),
              ),
              body: const Center(
                child: Text('Product not found.'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              toolbarHeight: 80,
              title: const CustomAppBar(),
              surfaceTintColor: Colors.transparent,
            ),
            backgroundColor:
                Color(int.parse('0xFF${product["primary_color"]}')),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      height: 250,
                      width: double.infinity,
                      child: Center(
                        child: Image.network(
                          product["image"] as String,
                          fit: BoxFit.contain,
                          width: 250,
                          height: 250,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 100),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product["name"] as String,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$ ${product["price"]} / kg',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: const Color.fromARGB(
                                              255, 164, 162, 162),
                                        ),
                                      ),
                                      Consumer(
                                        builder: (context, ref, child) {
                                          final quantity =
                                              ref.watch(quantityProvider);

                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        if (quantity > 1) {
                                                          quantityNotifier
                                                              .state -= 1;
                                                        }
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        fixedSize:
                                                            const Size.square(
                                                                50),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFF5F5F5),
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                          Icons.remove,
                                                          color: Colors.black),
                                                    ),
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      color: const Color(
                                                          0xFFF5F5F5),
                                                      child: Center(
                                                        child: Text(
                                                          '$quantity',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        quantityNotifier
                                                            .state += 1;
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        fixedSize:
                                                            const Size.square(
                                                                50),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFF5F5F5),
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                          Icons.add,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '\$ ${(product["price"] as double) * quantity} / kg',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Description',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              product["description"] as String,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                PosisionedButton(
                  product: ProductData.fromMap(product),
                ),
              ],
            ),
          );
        });
  }
}

class PosisionedButton extends StatefulWidget {
  const PosisionedButton({Key? key, required this.product}) : super(key: key);
  final ProductData product;
  @override
  _PosisionedButtonState createState() => _PosisionedButtonState();
}

class _PosisionedButtonState extends State<PosisionedButton> {
  @override
  Widget build(BuildContext context) {
    final isInWishlist = WishlistService().isInWishlist(widget.product.id);
    bool isLoading = false;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: FutureBuilder(
                  future: isInWishlist,
                  builder: (context, snapshot) {
                    return TextButton(
                      onPressed: () {
                        if (snapshot.connectionState == ConnectionState.done &&
                            isLoading == false) {
                          setState(() {
                            isLoading = true;
                          });
                          if (snapshot.data == true) {
                            WishlistService().removeWishlist(widget.product.id);
                          } else {
                            WishlistService().addWishlist(widget.product.id);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {});
                          return null;
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            width: 2,
                            color: Color(int.parse(
                                '0xFF${widget.product.secondary_color}')),
                          ),
                        ),
                      ),
                      child:
                          snapshot.connectionState == ConnectionState.waiting ||
                                  isLoading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Color(int.parse(
                                        '0xFF${widget.product.secondary_color}')),
                                    strokeWidth: 3,
                                  ),
                                )
                              : Icon(
                                  snapshot.data == true
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: Color(int.parse(
                                      '0xFF${widget.product.secondary_color}')),
                                  size: 22,
                                ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color(
                        int.parse('0xFF${widget.product.secondary_color}'),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add to cart",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFF5F5F5),
                    width: 1,
                  ),
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF130F26),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, "/main"),
              ref.read(navigationProvider.notifier).updateIndex(2)
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFF5F5F5),
                    width: 1,
                  ),
                  shape: BoxShape.circle),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingBag03,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
