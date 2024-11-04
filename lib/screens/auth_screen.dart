// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop_app/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  Future<void> _submit() async {
    try {
      if (_isLogin) {
        // Login
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        // Register
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      // Show specific error messages
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to FruitSmart',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0), // Padding around the container
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: () {
                    double screenWidth = MediaQuery.of(context).size.width;
                    if (screenWidth >= 1080) {
                      return 400.0;
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
                child: Column(
                  // Add a Column to arrange TextFields vertically
                  children: [
                    TextField(
                      style: GoogleFonts.poppins(
                          color: Colors.black), // Set text color
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.poppins(
                            color: Colors.black), // Set label color
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0), // Space between TextFields
                    TextField(
                      style: GoogleFonts.poppins(
                          color: Colors.black), // Set text color
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.poppins(
                            color: Colors.black), // Set label color
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submit,
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
                _isLogin ? 'Login' : 'Register',
                style: GoogleFonts.poppins(
                  color: Colors.black, // Set button text color
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
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
                _isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login',
                style: GoogleFonts.poppins(
                  color: Colors.black, // Set button text color
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
