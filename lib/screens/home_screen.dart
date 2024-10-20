import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 0),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1AD),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: Image.asset(
                          'assets/img/fruits.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: Center(
                        child: Text(
                          "Fresh & Juicy",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          "Get the fresh and juicy fruits at your doorstep.",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: () {
                        double screenWidth = MediaQuery.of(context).size.width;
                        if (screenWidth >= 1080) {
                          return 600.0;
                        } else if (screenWidth >= 768) {
                          return 200.0;
                        } else if (screenWidth >= 640) {
                          return 100.0;
                        } else if (screenWidth >= 320) {
                          return 20.0;
                        } else {
                          return 10.0;
                        }
                      }(),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/product-list',
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        backgroundColor: const Color(0xFFFFF1AD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Shop Now',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
