// lib/view/splashscreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:read/controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Show splash for 2 seconds

    final user = _authController.user;

    if (user != null) {
      // User is logged in
      Get.offAllNamed('/home'); // Navigate to home screen
    } else {
      // User is not logged in
      Get.offAllNamed('/login'); // Navigate to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your Lottie animation
            SizedBox(
              height: 200, // Set a fixed height for the Lottie animation
              child: Lottie.asset('asset/lottie/splashScreen.json'), // Replace with your Lottie animation file
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Read', // Replace with your app's tagline
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
