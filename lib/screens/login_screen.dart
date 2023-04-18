import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmail_signin/models/app_user.dart';
import 'package:gmail_signin/screens/home_screen.dart';
import 'package:gmail_signin/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final authService = AuthService();
            final User? user = await authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    user: AppUser(
                      uid: user.uid,
                      name: user.displayName,
                      email: user.email,
                    ),
                  ),
                ),
              );
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
