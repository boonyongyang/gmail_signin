import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmail_signin/models/app_user.dart';
import 'package:gmail_signin/services/api_service.dart';
import 'package:gmail_signin/services/auth_service.dart';
import 'package:gmail_signin/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  final AppUser user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _dateTime = '';
  int _countdownSeconds = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentDateTime();
    _startTimer();
  }

  void _getCurrentDateTime() async {
    final apiService = ApiService();
    final dateTime = await apiService.getCurrentDateTime();
    if (mounted) {
      setState(() {
        _dateTime = dateTime;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds == 1) {
        _getCurrentDateTime();
        _countdownSeconds = 10;
      } else {
        setState(() {
          _countdownSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${widget.user.name}'),
            Text(_dateTime),
            const SizedBox(height: 16),
            Text('Next update in $_countdownSeconds seconds'),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Log Out',
              onPressed: () async {
                final authService = AuthService();
                await authService.signOut();
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
