import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read/model/upload_model.dart'; // Ensure your model imports are correct

class MyBooksController extends GetxController {
  var premiumBooks = <Book>[].obs;
  var normalBooks = <Book>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserBooks();
  }

  void fetchUserBooks() async {
    try {
      // Get current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not logged in',
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      // Fetch premium books
      final premiumSnapshot = await FirebaseFirestore.instance
          .collection('premium_books')
          .where('user_id', isEqualTo: userId)
          .get();
      premiumBooks.value = premiumSnapshot.docs
          .map((doc) => Book.fromDocument(doc))
          .toList();

      // Fetch normal books
      final normalSnapshot = await FirebaseFirestore.instance
          .collection('normal_books')
          .where('user_id', isEqualTo: userId)
          .get();
      normalBooks.value = normalSnapshot.docs
          .map((doc) => Book.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching books: $e');
      Get.snackbar('Error', 'Failed to fetch books',
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
