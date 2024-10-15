import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop_app/dummy/fruits_list.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final Product? product =
        ModalRoute.of(context)!.settings.arguments as Product?;

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
        backgroundColor: Color(int.parse('0xFF${product.color}')),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              height: 250,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  product.image,
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(product.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text('\$ ${product.price} / kg',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: const Color.fromARGB(
                                        255, 164, 162, 162),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 0) {
                                              quantity--;
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          fixedSize: const Size.square(50),
                                          backgroundColor:
                                              const Color(0xFFF5F5F5),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(0),
                                              bottomRight: Radius.circular(0),
                                            ),
                                          ),
                                        ),
                                        child: const Icon(Icons.remove,
                                            color: Colors.black),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        color: const Color(0xFFF5F5F5),
                                        child: Center(
                                          child: Text(
                                            '$quantity',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              quantity++;
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                            fixedSize: const Size.square(50),
                                            backgroundColor:
                                                const Color(0xFFF5F5F5),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                bottomLeft: Radius.circular(0),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          child: const Icon(Icons.add,
                                              color: Colors.black)),
                                    ],
                                  ),
                                  Text(
                                      '\$ ${(product.price * quantity).toStringAsFixed(1)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "Description",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      product.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            )
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
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        width: 2,
                                        color: Color(int.parse(
                                            '0xFF${product.secondaryColor}')),
                                      ),
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Color(int.parse(
                                        '0xFF${product.secondaryColor}')),
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
                                              '0xFF${product.secondaryColor}'),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "Add to cart",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/product-list");
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFF5F5F5),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF130F26),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/cart"),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFF5F5F5),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF130F26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
