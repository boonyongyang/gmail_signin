import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:gmail_signin/firebase_options.dart';
import 'package:gmail_signin/models/app_user.dart';
import 'package:gmail_signin/screens/home_screen.dart';
import 'package:gmail_signin/screens/login_screen.dart';
import 'package:gmail_signin/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final AppUser? user = snapshot.data;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gmail Signin',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: user != null ? HomeScreen(user: user) : const LoginScreen(),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
