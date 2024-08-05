import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:read/view/home_screen.dart';
import 'package:read/view/login.dart';
import 'package:read/view/otp_validation_screen.dart'; // Import the OTPValidationScreen
import 'package:read/view/register.dart';
import 'package:read/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashScreen()),
            GetPage(name: '/login', page: () => const LoginScreen()),
            GetPage(name: '/otpvalidation', page: () {
              final email = Get.parameters['email'];
              if (email == null) {
                throw ArgumentError('email parameter is required for OTPValidationScreen');
              }
              return OTPValidationScreen(email: email);
            }), // Define the OTPValidationScreen route
            GetPage(name: '/register', page: () => const RegisterScreen()),
            GetPage(name: '/homescreen', page: () => const HomeScreen()),
          ],
        );
      },
    );
  }
}
