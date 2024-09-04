import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Books Section
                Text(
                  'Premium Books',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.premiumBooks.isEmpty) {
                    return Center(
                      child: Text('No Premium Books found.', style: TextStyle(fontSize: 16)),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.premiumBooks.length,
                    itemBuilder: (context, index) {
                      final book = controller.premiumBooks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: book.coverUrl.isNotEmpty
                              ? Image.network(book.coverUrl, width: 50, height: 75, fit: BoxFit.cover)
                              : Icon(Icons.book, size: 50, color: _primaryColor),
                          title: Text(book.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.author, style: TextStyle(fontSize: 16)),
                              Text('Page Count: ${book.pageCount}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Category: ${book.categoryId}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Subcategory: ${book.subcategoryName}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Description: ${book.description}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditDialog(context, book),
                          ),
                        ),
                      );
                    },
                  );
                }),

                SizedBox(height: 20),

                // Normal Books Section
                Text(
                  'Normal Books',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.normalBooks.isEmpty) {
                    return Center(
                      child: Text('No Normal Books found.', style: TextStyle(fontSize: 16)),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.normalBooks.length,
                    itemBuilder: (context, index) {
                      final book = controller.normalBooks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: book.coverUrl.isNotEmpty
                              ? Image.network(book.coverUrl, width: 50, height: 75, fit: BoxFit.cover)
                              : Icon(Icons.book, size: 50, color: _primaryColor),
                          title: Text(book.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.author, style: TextStyle(fontSize: 16)),
                              Text('Page Count: ${book.pageCount}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Category: ${book.categoryId}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Subcategory: ${book.subcategoryName}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text('Description: ${book.description}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditDialog(context, book),
                          ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle bottom navigation bar taps
          switch (index) {
            case 0:
              Get.toNamed('/home'); // Navigate to Home
              break;
            case 1:
            // Already on MyBooksPage
              break;
            case 2:
              Get.toNamed('/bookmarks'); // Navigate to Bookmarks
              break;
            case 3:
              Get.toNamed('/profile'); // Navigate to Profile
              break;
          }
        },
      ),
    );
  }
}
