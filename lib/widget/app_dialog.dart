import 'package:flutter/material.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';

class AppDialog extends StatefulWidget {
  const AppDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.onConfirm,
      required this.cancelText,
      required this.confirmText})
      : super(key: key);
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Function onConfirm;

  @override
  _AppDialogState createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          color: AppColors.darkSecondary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: 120,
        child: Text(
          widget.message,
          style: TextStyle(
            color: AppColors.grayText,
            fontSize: 16,
          ),
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
                      foregroundColor: AppColors.background,
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => {
                      Navigator.of(context).pop(),
                    },
                    child: Text(
                      widget.cancelText,
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
                      foregroundColor: Colors.red.shade100,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      widget.onConfirm();
                    },
                    child: Text(
                      widget.confirmText,
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
  }
}
