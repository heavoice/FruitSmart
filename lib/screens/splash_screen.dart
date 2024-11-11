// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/images/app_images.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/screens/auth_screen.dart';
import 'package:smart_shop_app/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          color: AppColors.primary,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImages.logo,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const Column(
                children: [
                  Text(
                    'Fresh And Juicy',
                    style: TextStyle(
                        color: AppColors.background,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Satoshi"),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Get the fresh and juicy fruits at your doorstep',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 15,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
      MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      ),
    );
  }
}
