import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // For FilePicker
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart'; // Import for FilePicker
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Authentication
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Import for PDF page count
import 'package:read/model/upload_model.dart'; // Ensure this import is correct

class UploadController extends GetxController {
  var categories = <BookCategory>[].obs;
  var selectedCategory = Rxn<BookCategory>();
  var selectedSubcategory = Rxn<Subcategory>();
  var selectedPdf = Rxn<File>();
  var selectedImage = Rxn<File>();

  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      categories.value = snapshot.docs.map((doc) => BookCategory.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void setSelectedCategory(BookCategory? category) {
    selectedCategory.value = category;
    selectedSubcategory.value = null; // Reset subcategory when category changes
  }

  void setSelectedSubcategory(Subcategory? subcategory) {
    selectedSubcategory.value = subcategory; // Ensure this is the exact object instance
  }

  Future<void> pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result != null) {
        selectedPdf.value = File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking PDF file: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        selectedImage.value = File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking image file: $e');
    }
  }

  Future<int> getPdfPageCount(File pdfFile) async {
    try {
      final documentBytes = await pdfFile.readAsBytes();
      final document = PdfDocument(inputBytes: documentBytes);
      return document.pages.count;
    } catch (e) {
      print('Error getting PDF page count: $e');
      return 0; // Return 0 if there's an error
    }
  }

  Future<void> sendNotification(String bookName) async {
    try {
      final notification = {
        'title': 'New Book Uploaded',
        'body': 'A new book "$bookName" has been uploaded!',
        'timestamp': Timestamp.now(),
      };

      // Store the notification in a Firestore collection
      await FirebaseFirestore.instance.collection('notifications').add(notification);
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> uploadBook() async {
    if (nameController.text.isEmpty || authorController.text.isEmpty || priceController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (selectedPdf.value == null || selectedImage.value == null) {
      Get.snackbar('Error', 'Please select both a PDF and an image',
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      // Get current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not logged in',
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      // Use book name to create filename
      final bookName = nameController.text.replaceAll(RegExp(r'[^\w\s]+'), '_'); // Replace special characters
      final imageRef = FirebaseStorage.instance.ref().child('book_covers/$bookName.png');
      final uploadImageTask = imageRef.putFile(selectedImage.value!);
      final imageUrl = await (await uploadImageTask).ref.getDownloadURL();

      final pdfRef = FirebaseStorage.instance.ref().child('book_pdfs/$bookName.pdf');
      final uploadPdfTask = pdfRef.putFile(selectedPdf.value!);
      final pdfUrl = await (await uploadPdfTask).ref.getDownloadURL();

      // Get PDF page count
      final pageCount = await getPdfPageCount(selectedPdf.value!);

      // Determine collection based on page count
      final collectionName = pageCount > 20 ? 'premium_books' : 'normal_books';

      // Upload book details to the determined collection
      await FirebaseFirestore.instance.collection(collectionName).add({
        'name': nameController.text,
        'author': authorController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'description': descriptionController.text,
        'category_id': selectedCategory.value?.categoryId ?? '',
        'subcategory_name': selectedSubcategory.value?.subcategoryName ?? '',
        'cover_url': imageUrl,
        'pdf_url': pdfUrl,
        'page_count': pageCount,
        'created_at': Timestamp.now(),
        'user_id': userId, // Add user ID
      });

      // Send notification to other users
      await sendNotification(nameController.text);

      Get.snackbar('Success', 'Book uploaded successfully',
          backgroundColor: Color(0xFF0A0E21),
          colorText: Colors.white);

      // Clear all fields after upload
      nameController.clear();
      authorController.clear();
      priceController.clear();
      descriptionController.clear();
      selectedPdf.value = null;
      selectedImage.value = null;
      selectedCategory.value = null;
      selectedSubcategory.value = null;

    } catch (e) {
      print('Error uploading book: $e');
      Get.snackbar('Error', 'Failed to upload book',
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    authorController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
