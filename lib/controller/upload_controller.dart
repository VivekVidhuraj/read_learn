import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // For FilePicker
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart'; // Import for FilePicker
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
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
      // Use book name to create filename
      final bookName = nameController.text.replaceAll(RegExp(r'[^\w\s]+'), '_'); // Replace special characters
      final imageRef = FirebaseStorage.instance.ref().child('book_covers/$bookName.png');
      final uploadImageTask = imageRef.putFile(selectedImage.value!);
      final imageUrl = await (await uploadImageTask).ref.getDownloadURL();

      final pdfRef = FirebaseStorage.instance.ref().child('book_pdfs/$bookName.pdf');
      final uploadPdfTask = pdfRef.putFile(selectedPdf.value!);
      final pdfUrl = await (await uploadPdfTask).ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('books').add({
        'name': nameController.text,
        'author': authorController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'description': descriptionController.text,
        'category_id': selectedCategory.value?.categoryId ?? '',
        'subcategory_name': selectedSubcategory.value?.subcategoryName ?? '',
        'cover_url': imageUrl,
        'pdf_url': pdfUrl,
        'created_at': Timestamp.now(),
      });

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
