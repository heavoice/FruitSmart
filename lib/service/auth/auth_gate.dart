/*
Auth Gate - This is the gate that will be used to check if the user is authenticated or not. 

  unauthorized -> Login Page
  authorized -> Home Page
*/

import 'package:flutter/material.dart';
import 'package:smart_shop_app/screens/auth_screen.dart';
import 'package:smart_shop_app/screens/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return const MainScreen();
          }
          return const AuthScreen();
        });
  }
}
