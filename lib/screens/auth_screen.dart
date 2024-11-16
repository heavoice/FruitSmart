// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_shop_app/config/images/app_images.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/screens/main_screen.dart';
import 'package:smart_shop_app/widget/app_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  bool _isLogin = true;
  bool _isValidated = false;
  bool _isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
      } else {
        // Register
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isValidated = isValid;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please input valid email!';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.asset(
                  AppImages.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Masuk' : 'Daftar',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBackground,
                    ),
                  ),
                  Text(
                    _isLogin
                        ? "Masuk untuk melanjutkan"
                        : "Daftar untuk melanjutkan",
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grayText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: RawKeyboardListener(
                focusNode: _focusNode,
                onKey: (RawKeyEvent event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
                      _isValidated) {
                    _submit();
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            cursorColor: AppColors.primary,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: 'Masukan email Anda!',
                              hintStyle: TextStyle(
                                color: AppColors.grayText.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            cursorColor: AppColors.primary,
                            validator: _validatePassword,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: 'Masukan password Anda!',
                              hintStyle: TextStyle(
                                color: AppColors.grayText.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _submit,
                isDisabled: !_isValidated,
                isLoading: _isLoading,
                title: _isLogin ? 'Masuk' : 'Daftar',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: _isLogin
                      ? "Belum memiliki akun? "
                      : "Sudah memiliki akun? ",
                  style: const TextStyle(
                      color: AppColors.darkSecondary,
                      fontFamily: "Satoshi",
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: _isLogin ? "Daftar" : "Masuk",
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontFamily: "Satoshi",
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
