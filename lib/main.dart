import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:read/controller/auth_controller.dart';
import 'package:read/view/homescreen.dart';
import 'package:read/view/loginscreen.dart';
import 'package:read/view/signup.dart';

import 'package:read/view/splashscreen.dart';
import 'package:read/view/upload_book_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());  // Initialize the AuthController
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360,690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Read & Learn',
        debugShowCheckedModeBanner: true,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => HomeScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/register', page: () => SignUpScreen()),
          // GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/uploadbook', page: ()=> UploadBookView()),

        ],
      ),
    );
  }
}
