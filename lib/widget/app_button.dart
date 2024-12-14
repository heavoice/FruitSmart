import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isDisabled;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: AppColors.primary,
        shadowColor: Colors.transparent,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 15),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          Text(
            isLoading ? "Loading..." : title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: "Satoshi",
            ),
          ),
        ],
      ),
    );
  }
}
