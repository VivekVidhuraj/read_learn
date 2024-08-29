import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/my_books_controller.dart';
// Ensure the correct path is used for the controller import

class MyBooksPage extends StatelessWidget {
  final MyBooksController controller = Get.put(MyBooksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium Books Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Premium Books',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.premiumBooks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('No Premium Books found.'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.premiumBooks.length,
                itemBuilder: (context, index) {
                  final book = controller.premiumBooks[index];
                  return ListTile(
                    title: Text(book.name),
                    subtitle: Text(book.author),
                  );
                },
              );
            }),

            // Normal Books Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Normal Books',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.normalBooks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('No Normal Books found.'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.normalBooks.length,
                itemBuilder: (context, index) {
                  final book = controller.normalBooks[index];
                  return ListTile(
                    title: Text(book.name),
                    subtitle: Text(book.author),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
