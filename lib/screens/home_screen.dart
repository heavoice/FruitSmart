import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/constant/coupon_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_shop_app/constant/fruits_list.dart';
import 'package:smart_shop_app/screens/auth_screen.dart';
import 'package:smart_shop_app/service/auth/auth.dart';
import 'package:smart_shop_app/service/categories/categories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser = AuthService().getCurrentUser();
  CategoriesService categoriesService = CategoriesService();

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

  @override
  Widget build(BuildContext context) {
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
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedUser,
                            color: Colors.black,
                            size: 24.0,
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
                              currentUser!.userMetadata!["display_name"] ?? '-',
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
                      onPressed: () => _logOut(context),
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
                CarouselSlider(
                  items: couponList
                      .map(
                        (coupon) => CoupunCard(
                          coupon: coupon,
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 158,
                    enableInfiniteScroll: false,
                    disableCenter: false,
                    initialPage: 1,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.9,
                  ),
                ),
                SizedBox(
                  height: 20,
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
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: categoriesService.getAllCategories(),
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

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            category: Category.fromMap(
                              snapshot.data![index],
                            ),
                          );
                        },
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
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                // CarouselSlider(
                //   items: bestSellingProducts
                //       .map(
                //         (product) => BestSellingCard(
                //           product: product,
                //         ),
                //       )
                //       .toList(),
                //   options: CarouselOptions(
                //     height: 400,
                //     enableInfiniteScroll: false,
                //     disableCenter: false,
                //     aspectRatio: 2 / 3,
                //     viewportFraction: 0.9,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CoupunCard extends StatelessWidget {
  final Coupon coupon;
  const CoupunCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Image.asset(coupon.imageUrl),
          Positioned(
            right: -580,
            top: -300,
            child: Container(
              width: 750,
              height: 750,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${coupon.color}')),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Positioned(
                child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.title,
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Get ${coupon.discount}%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: AppColors.background,
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background),
                        child: Text(
                          "Grab Offer",
                          style: TextStyle(
                            color: Color(int.parse('0xFF${coupon.color}')),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({super.key, required this.category});

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
        ),
      ],
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
          height: 10,
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

class BestSellingCard extends StatelessWidget {
  final Product product;
  const BestSellingCard({super.key, required this.product});

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
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Color(int.parse('0xFF${product.color}')),
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
                        "product.name",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "\$ ${product.price} / kg",
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
                child: Image.asset(
                  "product.image",
                  fit: BoxFit.contain,
                  width: 150,
                  height: 150,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(60, 60),
                    backgroundColor: Color(
                      int.parse('0xFF${product.secondaryColor}'),
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
                    size: 24,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
