// ignore_for_file: use_build_context_synchronously
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_shop_app/provider/navprovider.dart';
import 'package:smart_shop_app/screens/auth_screen.dart';
import 'package:smart_shop_app/service/auth/auth.dart';
import 'package:smart_shop_app/service/categories/categories.dart';
import 'package:smart_shop_app/service/products/products.dart';
import 'package:smart_shop_app/service/wishlist/wishlist_service.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = AuthService().getCurrentUser();
    final categoriesService = CategoriesService();
    final productsService = ProductsService();

 
    Future<void> _logOut(BuildContext context) async {
      try {
        await AuthService().logOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign out: $e')),
        );
      }
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'profile');
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[200],
                              child: const Icon(
                                    Icons.person_add_alt_1,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi There!",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grayText.withOpacity(0.9),
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              currentUser?.userMetadata?["display_name"] ?? '-',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: AppColors.darkSecondary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to log out?',
                              style: TextStyle(
                                color: AppColors.grayText,
                                fontSize: 16,
                              ),
                            ),
                            actions: <Widget>[
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 35,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.background,
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () => {
                                            Navigator.of(context).pop(),
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 35,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                Colors.red.shade100,
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () => {
                                            _logOut(context),
                                          },
                                          child: const Text(
                                            'Log Out',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        foregroundColor: AppColors.darkSecondary,
                      ),
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedLogout01,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkSecondary),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.pushNamed(context, "/category"),
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: categoriesService.getCategoriesWithLimit(5),
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: 4,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CategorySkeleton();
                        },
                      );
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Center(child: Text("No Categories Found"));
                      }

                      return CarouselSlider(
                        options: CarouselOptions(
                          height: 100,
                          enableInfiniteScroll: false,
                          disableCenter: true,
                          aspectRatio: 1 / 1,
                          viewportFraction: 0.3,
                          padEnds: false,
                        ),
                        items: snapshot.data!
                            .map(
                              (category) => CategoryItem(
                                category: Category.fromMap(category),
                              ),
                            )
                            .toList(),
                      );
                    }

                    return Text("No Categories Found");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Best Selling",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkSecondary),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.pushNamed(context, "/main"),
                        ref.read(navigationProvider.notifier).updateIndex(1)
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: productsService.getBestProducts(),
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CarouselSlider(
                        items: [1, 2, 3, 4]
                            .map(
                              (data) => Container(
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                          disableCenter: false,
                          aspectRatio: 2 / 3,
                          viewportFraction: 0.9,
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Center(child: Text("No Categories Found"));
                      }

                      return CarouselSlider(
                        items: snapshot.data!
                            .map(
                              (product) => BestSellingCard(
                                product: ProductData.fromMap(product),
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                          disableCenter: false,
                          aspectRatio: 2 / 3,
                          viewportFraction: 0.9,
                        ),
                      );
                    }

                    return Text("No Best Product Found");
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension on Map<String, dynamic>? {
  // ignore: unused_element
  get display_name => null;
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-category',
          arguments: {
            "category_id": category.id,
            "category_name": category.name,
          },
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  category.thumbnail_url!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            category.name!,
            style: TextStyle(
              color: AppColors.darkSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}

class BestSellingCard extends StatefulWidget {
  final ProductData product;
  const BestSellingCard({super.key, required this.product});

  @override
  State<BestSellingCard> createState() => _BestSellingCardState();
}

class _BestSellingCardState extends State<BestSellingCard> {

  @override
  Widget build(BuildContext context) {

    final isInWishlist = WishlistService().isInWishlist(widget.product.id);
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: widget.product.id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
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
                        widget.product.name as String,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "\$ ${widget.product.price} / kg",
                        style: const TextStyle(
                          fontSize: 16,
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
                  width: 150,
                  height: 150,
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
                            onPressed: () {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data == true) {
                                  WishlistService()
                                      .removeWishlist(widget.product.id);
                                  setState(() {});
                                } else {
                                  WishlistService()
                                      .addWishlist(widget.product.id);
                                  setState(() {});
                                }
                              } else {
                                return null;
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(60, 60),
                              backgroundColor: Color(
                                int.parse(
                                    '0xFF${widget.product.secondary_color}'),
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                            ),
                          child:
                              snapshot.connectionState == ConnectionState.done
                                  ? Icon(
                                      snapshot.data == true
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.background,
                                        strokeWidth: 2,
                                      ),
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
