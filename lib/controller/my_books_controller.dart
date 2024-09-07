import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/model/fetch_user_book_model.dart'; // Ensure your model imports are correct

class MyBooksController extends GetxController {
  var premiumBooks = <Book>[].obs;
  var normalBooks = <Book>[].obs;
  var categories = <String>[].obs; // For categories dropdown
  var subcategories = <String>[].obs; // For subcategories dropdown

  @override
  void onInit() {
    super.onInit();
    fetchUserBooks();
    fetchCategories();
  }

  Future<String> _uploadFile(File file, String folder) async {
    final fileName = file.uri.pathSegments.last;
    final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void fetchUserBooks() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final premiumBooksQuery = FirebaseFirestore.instance
            .collection('premium_books')
            .where('user_id', isEqualTo: userId)
            .orderBy('created_at', descending: true)
            .limit(10)
            .snapshots();

        final normalBooksQuery = FirebaseFirestore.instance
            .collection('normal_books')
            .where('user_id', isEqualTo: userId)
            .orderBy('created_at', descending: true)
            .limit(10)
            .snapshots();

        premiumBooksQuery.listen((snapshot) {
          premiumBooks.value = snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
        });

        normalBooksQuery.listen((snapshot) {
          normalBooks.value = snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
        });
      }
    } catch (e) {
      print('Error fetching books: $e');
      Get.snackbar('Error', 'Failed to fetch books',
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      categories.value = snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      Get.snackbar('Error', 'Failed to fetch categories',
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void fetchSubcategories(String categoryId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('subcategories')
          .where('category_id', isEqualTo: categoryId)
          .get();
      subcategories.value = snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print('Error fetching subcategories: $e');
      Get.snackbar('Error', 'Failed to fetch subcategories',
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void updateBookDetails(
      String bookId,
      String name,
      String author,
      String description,
      int pageCount,
      String categoryId,
      String subcategoryName, {
        File? coverImage,
        File? pdfFile,
      }) async {
    try {
      final updates = {
        'name': name,
        'author': author,
        'description': description,
        'page_count': pageCount,
        'category_id': categoryId,
        'subcategory_name': subcategoryName,
      };

      if (coverImage != null) {
        final coverUrl = await _uploadFile(coverImage, 'covers');
        updates['cover_url'] = coverUrl;
      }

      if (pdfFile != null) {
        final pdfUrl = await _uploadFile(pdfFile, 'pdfs');
        updates['pdf_url'] = pdfUrl;
      }

      final bookRef = FirebaseFirestore.instance.collection('books').doc(bookId);
      await bookRef.update(updates);

      // Refresh the list after update
      fetchUserBooks();
      Get.snackbar('Success', 'Book details updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print('Error updating book details: $e');
      Get.snackbar('Error', 'Failed to update book details',
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
