import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/upload_controller.dart';
import 'package:read/model/models_book.dart';

class UploadBookView extends StatelessWidget {
  final UploadController controller = Get.put(UploadController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Book', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0A0E21),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: 'Book Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.priceController,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Obx(() => DropdownButtonFormField<BookCategory?>(
                items: controller.categories.map((category) {
                  return DropdownMenuItem<BookCategory?>(
                    value: category,
                    child: Text(category.categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.setSelectedCategory(value as BookCategory?);
                },
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              )),
              Obx(() => controller.selectedCategory.value != null
                  ? DropdownButtonFormField<Subcategory?>(
                items: controller.selectedCategory.value!.subcategories
                    .map((subcategory) {
                  return DropdownMenuItem<Subcategory?>(
                    value: subcategory,
                    child: Text(subcategory.subcategoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.setSelectedSubcategory(
                      value as Subcategory?);
                },
                decoration: InputDecoration(labelText: 'Subcategory'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a subcategory';
                  }
                  return null;
                },
              )
                  : SizedBox()),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.picture_as_pdf),
                onPressed: controller.pickPdf,
                tooltip: 'Select PDF',
              ),
              Obx(() => controller.selectedPdf.value != null
                  ? Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                      'Selected PDF: ${controller.selectedPdf.value!.path.split('/').last}'),
                ],
              )
                  : SizedBox()),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.image),
                onPressed: controller.pickImage,
                tooltip: 'Select Book Cover',
              ),
              Obx(() => controller.selectedImage.value != null
                  ? Column(
                children: [
                  SizedBox(height: 10),
                  Image.file(
                    controller.selectedImage.value!,
                    height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                      'Selected Cover: ${controller.selectedImage.value!.path.split('/').last}'),
                ],
              )
                  : SizedBox()),
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
                  backgroundColor: Color(0xFF0A0E21),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
