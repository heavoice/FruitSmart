import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/constant/fruits_list.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListScreen> {
  List<Product> filteredProduct = products;

  filterProduct(String query) {
    setState(() {
      filteredProduct = products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    cursorColor: AppColors.primary,
                    onChanged: filterProduct,
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredProduct.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Menonaktifkan scrollbar
                    itemBuilder: (context, index) =>
                        ProductItem(product: filteredProduct[index]),
                  ),
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
  final Product product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

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
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "\$ ${product.price} / kg",
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
                child: Image.asset(
                  product.image,
                  fit: BoxFit.contain,
                  width: 90,
                  height: 90,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(45, 45), 
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
                    size: 18,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
