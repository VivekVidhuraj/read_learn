import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/upload_controller.dart';
import 'package:read/model/upload_model.dart';

class UploadBookView extends StatelessWidget {
  final UploadController controller = Get.put(UploadController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Upload Book', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0A0E21),
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Help or information action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: 'Book Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter book name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.authorController,
                        decoration: InputDecoration(
                          labelText: 'Author',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter author name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Obx(() => DropdownButtonFormField<BookCategory?>(
                        value: controller.selectedCategory.value,
                        items: controller.categories.map((category) {
                          return DropdownMenuItem<BookCategory?>(
                            value: category,
                            child: Row(
                              children: [
                                Icon(Icons.category, color: Color(0xFF0A0E21)),
                                SizedBox(width: 10),
                                Text(category.categoryName),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.setSelectedCategory(value as BookCategory?);
                        },
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      )),
                      SizedBox(height: 16.0),
                      Obx(() => controller.selectedCategory.value != null
                          ? DropdownButtonFormField<Subcategory?>(
                        value: controller.selectedSubcategory.value,
                        items: controller.selectedCategory.value!.subcategories
                            .map((subcategory) {
                          return DropdownMenuItem<Subcategory?>(
                            value: subcategory,
                            child: Row(
                              children: [
                                Icon(Icons.subdirectory_arrow_right, color: Color(0xFF0A0E21)),
                                SizedBox(width: 10),
                                Text(subcategory.subcategoryName),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.setSelectedSubcategory(value as Subcategory?);
                        },
                        decoration: InputDecoration(
                          labelText: 'Subcategory',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a subcategory';
                          }
                          return null;
                        },
                      )
                          : SizedBox()),
                      SizedBox(height: 20),
                      _UploadSection(
                        title: 'Select Book Cover',
                        icon: Icons.image,
                        onPressed: controller.pickImage,
                        file: controller.selectedImage.value,
                        fileType: 'Cover',
                      ),
                      SizedBox(height: 20),
                      _UploadSection(
                        title: 'Select PDF',
                        icon: Icons.picture_as_pdf,
                        onPressed: controller.pickPdf,
                        file: controller.selectedPdf.value,
                        fileType: 'PDF',
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              controller.selectedPdf.value != null &&
                              controller.selectedImage.value != null) {
                            await controller.uploadBook();
                            Get.snackbar('Success', 'Book uploaded successfully',
                                backgroundColor: Color(0xFF0A0E21),
                                colorText: Colors.white);
                          }
                        },
                        child: Text('Upload Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0A0E21), // Background color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Increase padding for larger button
                          minimumSize: Size(double.infinity, 60), // Make the button full-width and taller
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final File? file;
  final String fileType;

  _UploadSection({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.file,
    required this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              icon: Icon(icon, size: 30),
              onPressed: onPressed,
              color: Color(0xFF0A0E21),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                file != null
                    ? fileType == 'Cover'
                    ? 'Cover selected: ${file!.path.split('/').last}'
                    : 'PDF selected: ${file!.path.split('/').last}'
                    : 'No $fileType selected',
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        file != null
            ? fileType == 'Cover'
            ? Image.file(
          file!,
          height: 150,
          width: 100,
          fit: BoxFit.cover,
        )
            : Container(
          height: 100,
          color: Colors.grey[200],
          child: Center(
            child: Text(
              'PDF File',
              style: TextStyle(fontSize: 14),
            ),
          ),
        )
            : SizedBox.shrink(),
      ],
    );
  }
}
