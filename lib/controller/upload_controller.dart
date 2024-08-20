import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:read/model/models_book.dart';

// Import the model class

class UploadController extends GetxController {
  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Observable fields for categories and subcategories
  var categories = <BookCategory>[].obs;
  var selectedCategory = Rxn<BookCategory>();
  var selectedSubcategory = Rxn<Subcategory>();

  // Observable fields for selected files
  var selectedPdf = Rxn<File>();
  var selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      categories.value = snapshot.docs.map((doc) {
        return BookCategory.fromDocument(doc);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  // Set selected category and update subcategories
  void setSelectedCategory(BookCategory? category) {
    selectedCategory.value = category;
    selectedSubcategory.value = null; // Reset selected subcategory
  }

  // Set selected subcategory
  void setSelectedSubcategory(Subcategory? subcategory) {
    selectedSubcategory.value = subcategory;
  }

  // Pick PDF file
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      selectedPdf.value = File(result.files.single.path!);
    }
  }

  // Pick Image for book cover
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Upload book details to Firestore
  Future<void> uploadBook() async {
    if (selectedPdf.value == null || selectedImage.value == null) return;

    try {
      // Upload PDF
      final pdfRef = FirebaseStorage.instance
          .ref('books/${selectedPdf.value!.path.split('/').last}');
      await pdfRef.putFile(selectedPdf.value!);
      String pdfUrl = await pdfRef.getDownloadURL();

      // Upload Image
      final imageRef = FirebaseStorage.instance
          .ref('book_covers/${selectedImage.value!.path.split('/').last}');
      await imageRef.putFile(selectedImage.value!);
      String imageUrl = await imageRef.getDownloadURL();

      // Save book data in Firestore
      await FirebaseFirestore.instance.collection('books').add({
        'name': nameController.text,
        'author': authorController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'category': selectedCategory.value?.categoryName,
        'subcategory': selectedSubcategory.value?.subcategoryName,
        'pdf_url': pdfUrl,
        'image_url': imageUrl,
      });

      // Clear the form
      nameController.clear();
      authorController.clear();
      priceController.clear();
      descriptionController.clear();
      selectedPdf.value = null;
      selectedImage.value = null;
      selectedCategory.value = null;
      selectedSubcategory.value = null;

      Get.snackbar('Success', 'Book uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload book');
    }
  }
}
