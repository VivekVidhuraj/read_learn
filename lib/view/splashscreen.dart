import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final GetStorage _storage = GetStorage(); // Persistent storage

  @override
  Widget build(BuildContext context) {
    // Simulate a delay to show the splash screen for a short period
    Future.delayed(Duration(seconds: 2), () {
      _authController.handleUserAuth();
    });

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          "Welcome to read-learn",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
