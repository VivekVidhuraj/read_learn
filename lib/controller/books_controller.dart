import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read/model/upload_model.dart'; // Ensure your model imports are correct

class BooksController extends GetxController {
  var allBooks = <Book>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  void fetchBooks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not logged in',
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final booksSnapshot = await FirebaseFirestore.instance
          .collection('books') // Collection containing all books
          .where('user_id', isNotEqualTo: userId) // Exclude books by the current user
          .get();

      allBooks.value = booksSnapshot.docs
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
