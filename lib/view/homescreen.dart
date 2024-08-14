import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';


class HomeScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authController.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, ${_authController.user?.email ?? ''}!'),
      ),
    );
  }
}
