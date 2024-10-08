import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:read/controller/auth_controller.dart';
import 'package:read/controller/banner_image_controller.dart';
import 'package:read/view/favorites.dart';
import 'package:read/view/homescreen.dart';
import 'package:read/view/loginscreen.dart';
import 'package:read/view/noticiation.dart';

import 'package:read/view/profile_view.dart';
import 'package:read/view/purchased_book.dart';
import 'package:read/view/reading_history_page.dart';
import 'package:read/view/signup.dart';
import 'package:read/view/splashscreen.dart';
import 'package:read/view/upload_book_view.dart';
import 'package:read/view/my_books_page.dart';

import 'controller/subscription_controller.dart';


// Import the new VerifyEmailScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register controllers
  Get.put(AuthController());  // Initialize the AuthController
  Get.put(BannerImageController());
  Get.put(SubscriptionController()); // Initialize the BannerImageController

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Read',
        debugShowCheckedModeBanner: false, // Hide debug banner
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/register', page: () => SignUpScreen()),
         GetPage(name: '/uploadbook', page: () => UploadBookView()),
          GetPage(name: '/mybooks', page: () => MyBooksPage()),
          GetPage(name: '/profile', page: () => ProfileManagementPage()),
          GetPage(name: '/notification', page: () => NotificationPage()),
          GetPage(name: '/purchasedbook', page: () => PurchasedBooksView()),
          GetPage(name: '/favorite', page: () => FavoritesPage()),
          GetPage(name: '/history', page: () => ReadingHistoryPage()),

          // Add new route
           // Add new route
        ],
      ),
    );
  }
}
