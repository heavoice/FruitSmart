import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/service/wishlist/wishlist_service.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final wishlist = WishlistService().getWishlist();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 100,
            title: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wishlist',
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
          FutureBuilder(
            future: wishlist,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final data = snapshot.data;

              if (data == null || data.isEmpty) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Text(
                        'No Wishlist Found',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                          title: Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Image.network(
                                data[index]['product_id']['image'],
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index]['product_id']['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$ ${data[index]['product_id']['price']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            TextButton(
                                onPressed: () {
                                  WishlistService().removeWishlist(
                                      data[index]['product_id']['id']);
                                  setState(() {});
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(45, 45),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.pink.shade300,
                                  size: 22,
                                ))
                          ],
                        ),
                      ));
                    },
                    childCount: data.length,
                  ),
                );
              }

              return Text(
                'No Wishlist Found',
              );
            },
          )
        ],
      ),
    );
  }
}

