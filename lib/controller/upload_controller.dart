import 'dart:io'; // Import for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // For FilePicker
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart'; // Import for FilePicker
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
    // Implement book upload logic
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
