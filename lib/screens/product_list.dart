import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/service/products/products.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    final int rowCount = MediaQuery.of(context).size.width < 400
        ? 1
        : MediaQuery.of(context).size.width < 600
            ? 2
            : MediaQuery.of(context).size.width < 900
                ? 3
                : 4;

    final _filterController = TextEditingController();
    final ProductsService productsService = ProductsService(filter: "");

    

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  width: double.infinity,
                  child: const Text(
                    "Explore Fruits & Berries",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    cursorColor: AppColors.primary,
                    onChanged: (value) {
                      _filterController.text = value;
                      productsService.setFilter(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      fillColor: const Color(0xFFF5F5F5),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: productsService.getAllProducts(),
                      builder: (contex, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        log(snapshot.data.toString());
                        if (snapshot.hasData) {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: rowCount,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.7,
                            ),
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final product = snapshot.data![index];
                              return ProductItem(
                                product: ProductData.fromMap(product),
                              );
                            },
                          );
                        }
                        return Center(child: Text("No Products Found"));
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final ProductData product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: product,
        );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 30,
        decoration: BoxDecoration(
          color: Color(int.parse('0xFF${product.primary_color}')),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        product.name ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "\$ ${product.name} / kg",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.network(
                  product.image ?? "-",
                  fit: BoxFit.contain,
                  width: 90,
                  height: 90,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(45, 45),
                    backgroundColor: Color(
                      int.parse('0xFF${product.secondary_color}'),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
