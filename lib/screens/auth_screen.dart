// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_shop_app/config/images/app_images.dart';
import 'package:smart_shop_app/config/theme/app_colors.dart';
import 'package:smart_shop_app/main.dart';
import 'package:smart_shop_app/screens/main_screen.dart';
import 'package:smart_shop_app/widget/app_button.dart';
import 'package:smart_shop_app/service/auth/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_shop_app/service/profile/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  final _usernameController = TextEditingController(text: "");
  bool _isEmailTouched = false;
  bool _isPasswordTouched = false;
  bool _isUsernameTouched = false;

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  bool _isLogin = true;
  bool _isValidated = false;
  bool _isLoading = false;
  String errorMessage = '';
  Uint8List? _webImage;
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
  }

  Future<void> _uploadImageToSupabase() async {
    if (_webImage == null && _imageFile == null) {
      debugPrint("Tidak ada gambar untuk diunggah");
      return;
    }

    try {
      // Nama file unik untuk gambar
      final String fileName =
          'avatar_${DateTime.now().millisecondsSinceEpoch}.png';
      final String bucketPath = 'profiles/$fileName';

      if (_webImage != null) {
        // Jika berjalan di Web, gunakan _webImage (Uint8List)
        await supabase.storage.from('profiles').uploadBinary(
              bucketPath,
              _webImage!,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else if (_imageFile != null) {
        // Jika berjalan di Mobile/Desktop, gunakan _imageFile (File)
        await supabase.storage.from('profiles').upload(
              bucketPath,
              _imageFile!,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
      }

      // Dapatkan URL publik dari gambar yang diunggah
      final String publicUrl =
          supabase.storage.from('profiles').getPublicUrl(bucketPath);

      // Simpan URL gambar di shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_url', publicUrl);

      debugPrint('Gambar berhasil diunggah ke Supabase: $publicUrl');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar berhasil diunggah: $publicUrl')),
      );
    } catch (e) {
      debugPrint('Gagal mengunggah gambar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah gambar')),
      );
    }
  }

  Future<void> _pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        // Web: Baca gambar sebagai byte
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _webImage = imageBytes;
        });
      } else {
        // Mobile/Desktop: Gunakan objek File
        setState(() {
          _imageFile = File(image.path);
        });
      }

      // Setelah gambar dipilih, unggah ke Supabase
      await _uploadImageToSupabase();
    }
  }

  Future<void> _submit() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Jika login
      if (_isLogin) {
        // Login with email and password
        await AuthService()
            .signInWithEmail(_emailController.text, _passwordController.text);
      } else {
        // Jika registrasi
        final email = _emailController.text;

        // Gunakan email sebagai userId
        final userId = email;

        // Setelah pendaftaran, lakukan login dan dapatkan userId dari email
        await AuthService().signUpWithEmail(
          email,
          _passwordController.text,
          _usernameController.text,
        );

        // Upload avatar jika ada
        if (_imageFile != null) {
          final imageService = ImageService();
          // Upload the image to Supabase storage
          final imageUrl =
              await imageService.uploadImage(File(_imageFile!.path), userId);

          if (imageUrl != null) {
            // Update the profile image URL if image upload is successful
            await imageService.updateProfileImage(userId, imageUrl);
          }
        }
      }

      // Setelah berhasil login atau register, pindah ke halaman utama
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } on AuthException catch (error) {
      // Handle authentication error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red[600],
        ),
      );
    } catch (e) {
      // Handle any general errors (e.g., image upload errors)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
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
    if (!_isEmailTouched) return null;
    if (value == null) {
      return 'Email should not be empty';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please input valid email!';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (_isPasswordTouched) {
      if (value == null) {
        return 'Password should not be empty';
      }
      if (value.length <= 4) {
        return 'Password should be at least 6 characters';
      }
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (!_isUsernameTouched) return null;
    final specialCharRegex = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');

    if (value == null) {
      return 'Username should not be empty';
    }

    if (value.contains(" ")) {
      return 'Username should not contain space';
    }

    if (specialCharRegex.hasMatch(value)) {
      return 'Username should not contain special characters';
    }

    if (value.length <= 4) {
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
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
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
                        _isLogin
                            ? "Sign in to continue"
                            : "Register to continue",
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
                            GestureDetector(
                              onTap: _pickAvatar,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: _webImage != null
                                    ? MemoryImage(_webImage!)
                                        as ImageProvider<Object>?
                                    : _imageFile != null
                                        ? FileImage(_imageFile!)
                                            as ImageProvider<Object>?
                                        : null,
                                child: _webImage == null && _imageFile == null
                                    ? const Icon(
                                        Icons.person_add_alt_1,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
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
                                  onChanged: (value) {
                                    setState(() {
                                      _isUsernameTouched = true;
                                    });
                                  },
                                  validator: _validateUsername,
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    hintText: 'Input your username!',
                                    hintStyle: TextStyle(
                                      color:
                                          AppColors.grayText.withOpacity(0.5),
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
                                onChanged: (value) {
                                  setState(() {
                                    _isEmailTouched = true;
                                  });
                                },
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
                                onChanged: (value) {
                                  setState(() {
                                    _isPasswordTouched = true;
                                  });
                                },
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
        ),
      ),
    );
  }
}
