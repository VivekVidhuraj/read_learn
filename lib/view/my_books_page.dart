import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read/controller/my_books_controller.dart';
import 'package:read/model/fetch_user_book_model.dart'; // Adjust the path if necessary

class MyBooksPage extends StatelessWidget {
  final MyBooksController controller = Get.put(MyBooksController());
  final Color _primaryColor = const Color(0xFF0A0E21); // Primary color
  final Color _secondaryColor = const Color(0xFFFFA726); // Secondary color

  void _showEditDialog(BuildContext context, Book book) {
    final _nameController = TextEditingController(text: book.name);
    final _authorController = TextEditingController(text: book.author);
    final _descriptionController = TextEditingController(text: book.description);
    final _pageCountController = TextEditingController(text: book.pageCount.toString());
    final _categoryController = TextEditingController(text: book.categoryId);
    final _subCategoryController = TextEditingController(text: book.subcategoryName);

    File? coverImage;
    File? pdfFile;

    Future<void> _pickCoverImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        coverImage = File(pickedFile.path);
      }
    }

    Future<void> _pickPdf() async {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result != null) {
        pdfFile = File(result.files.single.path!);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Book Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Book Name'),
                ),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(labelText: 'Author'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                TextField(
                  controller: _pageCountController,
                  decoration: InputDecoration(labelText: 'Page Count'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _subCategoryController,
                  decoration: InputDecoration(labelText: 'Subcategory'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickCoverImage,
                  child: Text('Select Cover Image'),
                ),
                if (coverImage != null) Text('Cover Image Selected'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickPdf,
                  child: Text('Select PDF'),
                ),
                if (pdfFile != null) Text('PDF Selected'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.updateBookDetails(
                  book.id,
                  _nameController.text,
                  _authorController.text,
                  _descriptionController.text,
                  int.tryParse(_pageCountController.text) ?? 0,
                  _categoryController.text,
                  _subCategoryController.text,
                  coverImage: coverImage,
                  pdfFile: pdfFile,
                );
                Get.back();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Books',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon with white color
          onPressed: () {
            Get.offNamed('/home'); // Navigate back to Home page
          },
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Books',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.premiumBooks.isEmpty) {
                    return Center(child: Text('No premium books found'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.premiumBooks.length,
                    itemBuilder: (context, index) {
                      final book = controller.premiumBooks[index];
                      return ListTile(
                        title: Text(book.name),
                        subtitle: Text(book.author),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, book),
                        ),
                      );
                    },
                  );
                }),

                SizedBox(height: 20),

                Text(
                  'Normal Books',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.normalBooks.isEmpty) {
                    return Center(child: Text('No normal books found'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.normalBooks.length,
                    itemBuilder: (context, index) {
                      final book = controller.normalBooks[index];
                      return ListTile(
                        title: Text(book.name),
                        subtitle: Text(book.author),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, book),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
