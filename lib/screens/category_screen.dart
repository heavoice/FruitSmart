import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/service/categories/categories.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final int rowCount = MediaQuery.of(context).size.width <= 360
        ? 1
        : MediaQuery.of(context).size.width < 600
            ? 2
            : MediaQuery.of(context).size.width < 900
                ? 3
                : 4;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          title: CustomAppBar(
            onTap: () {
              Navigator.pushNamed(context, "/main");
            },
          ),
          surfaceTintColor: Colors.transparent,
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(15),
              sliver: FutureBuilder(
                  future: CategoriesService().getAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          },
                          childCount: 4,
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: Text(
                                'No Category Found',
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
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final category = snapshot.data![index];
                            return CategoryItem(
                              category: Category.fromMap(category),
                            );
                          },
                          childCount: snapshot.data!.length,
                        ),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Text(
                            'No Category Found',
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key, required this.category}) : super(key: key);
  final Category category;

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
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    category.name ?? "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.network(
                category.thumbnail_url ?? "-",
                fit: BoxFit.contain,
                width: 90,
                height: 90,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({
    super.key,
    this.title,
    required this.onTap,
  });
  final title;
  final Function onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              onTap();
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
          Text(
            title ?? "All Category",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox()
        ],
      ),
    );
  }
}
