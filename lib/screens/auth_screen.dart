// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_shop_app/config/images/app_images.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/screens/main_screen.dart';
import 'package:smart_shop_app/widget/app_button.dart';
import 'package:smart_shop_app/service/auth/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
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
    _usernameController.addListener(_validateForm);
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isLogin) {
        await AuthService()
            .signInWithEmail(_emailController.text, _passwordController.text);
      } else {
        // Register
        await AuthService().signUpWithEmail(_emailController.text,
            _passwordController.text, _usernameController.text);
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red[600],
        ),
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
      return 'Email should not be empty';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please input valid email!';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password should not be empty';
    }
    if (value.length <= 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username should not be empty';
    }
    if (value.length <= 6) {
      return 'Username should be at least 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Sign In' : 'Register',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBackground,
                    ),
                  ),
                  Text(
                    _isLogin ? "Sign in to continue" : "Register to continue",
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grayText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                      if (!_isLogin)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Username",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _usernameController,
                              cursorColor: AppColors.primary,
                              validator: _validateUsername,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                hintText: 'Input your username!',
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
                              keyboardType: TextInputType.name,
                            ),
                          ],
                        ),
                      if (!_isLogin) const SizedBox(height: 10),
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
                              hintText: 'Input your email!',
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
                      const SizedBox(height: 10),
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
                              hintText: 'Input your password!',
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
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _submit,
                isDisabled: !_isValidated,
                isLoading: _isLoading,
                title: _isLogin ? 'Sign In' : 'Register',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Or",
              style: TextStyle(
                color: AppColors.grayText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.lightGrey.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _submit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.google,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: AppColors.darkSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: _isLogin
                      ? "Dont have an account yet? "
                      : "Already have an account? ",
                  style: const TextStyle(
                      color: AppColors.darkSecondary,
                      fontFamily: "Satoshi",
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: _isLogin ? "Register" : "Login",
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontFamily: "Satoshi",
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _emailController.clear();
                          _passwordController.clear();
                          _usernameController.clear();
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
