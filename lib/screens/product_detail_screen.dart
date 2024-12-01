import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/provider/cartprovider.dart';
import 'package:smart_shop_app/provider/navprovider.dart';
// import 'package:smart_shop_app/provider/wishlistprovider.dart' as provider;
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/service/products/products.dart';

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
              body: Column(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    if (quantity > 1) {
                                                      quantityNotifier.state -=
                                                          1;
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                    fixedSize:
                                                        const Size.square(50),
                                                    backgroundColor:
                                                        const Color(0xFFF5F5F5),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(0),
                                                        bottomRight:
                                                            Radius.circular(0),
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
                                                  color:
                                                      const Color(0xFFF5F5F5),
                                                  child: Center(
                                                    child: Text(
                                                      '$quantity',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    quantityNotifier.state += 1;
                                                  },
                                                  style: TextButton.styleFrom(
                                                    fixedSize:
                                                        const Size.square(50),
                                                    backgroundColor:
                                                        const Color(0xFFF5F5F5),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(0),
                                                        bottomLeft:
                                                            Radius.circular(0),
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Icon(Icons.add,
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
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          product["description"] as String,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 52,
                                      height: 52,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                              width: 2,
                                              color: Color(int.parse(
                                                  '0xFF${product["secondary_color"]}')),
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          CupertinoIcons.heart_fill,
                                          color: Color(int.parse(
                                              '0xFF${product["secondary_color"]}')),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            backgroundColor: Color(
                                              int.parse(
                                                  '0xFF${product["secondary_color"]}'),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
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
