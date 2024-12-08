import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/provider/quantity_provider.dart';
import 'package:smart_shop_app/service/products/products.dart';
import 'package:smart_shop_app/service/wishlist/wishlist_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListScreen> {
  String _filter = "";

  @override
  Widget build(BuildContext context) {
    final int rowCount = MediaQuery.of(context).size.width <= 360
        ? 1
        : MediaQuery.of(context).size.width < 600
            ? 2
            : MediaQuery.of(context).size.width < 900
                ? 3
                : 4;

    final ProductsService productsService = ProductsService(filter: _filter);

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
                    onSubmitted: (value) {
                      setState(() {
                        _filter = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Search',
                      suffixIcon: Icon(
                        Icons.search,
                      ),
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
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: FutureBuilder<List<Map<String, dynamic>>>(
                future: productsService.getAllProducts(),
                builder: (contex, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        },
                        childCount: 5,
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: Center(
                            child: Text(
                              'No Product Found',
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = snapshot.data![index];
                          return ProductItem(
                            product: ProductData.fromMap(product),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: Center(
                        child: Text(
                          'No Product Found',
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends ConsumerStatefulWidget {
  final ProductData product;
  const ProductItem({super.key, required this.product});

  @override
  ConsumerState<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final isInWishlist = WishlistService().isInWishlist(widget.product.id);
    bool isLoading = false;
    final quantityNotifier = ref.read(quantityProvider.notifier);


    return GestureDetector(
      onTap: () {
        quantityNotifier.state = 1;
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: widget.product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(int.parse('0xFF${widget.product.primary_color}')),
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
                        widget.product.name ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "\$ ${widget.product.price} / kg",
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
                  widget.product.image ?? "-",
                  fit: BoxFit.contain,
                  width: 90,
                  height: 90,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.product.totalSold} Sold",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FutureBuilder(
                      future: isInWishlist,
                      builder: (context, snapshot) {
                        return TextButton(
                          onPressed: () async {
                            try {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  isLoading == false) {
                                setState(() {
                                  isLoading = true;
                                });
                                if (snapshot.data == true) {
                                  await WishlistService()
                                      .removeWishlist(widget.product.id);
                                } else {
                                  await WishlistService()
                                      .addWishlist(widget.product.id);
                                }
                              } else {
                                setState(() {});
                                return null;
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Something went wrong: $e'),
                                  backgroundColor: Colors.red[600],
                                ),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(45, 45),
                            backgroundColor: Color(
                              int.parse(
                                  '0xFF${widget.product.secondary_color}'),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          child: snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  isLoading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.background,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  snapshot.data == true
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: Colors.white,
                                  size: 16,
                                ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
