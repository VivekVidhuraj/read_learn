import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/favorites_controller.dart';
import 'package:read/model/book_model.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesController controller = Get.put(FavoritesController());
  final Color _primaryColor = const Color(0xFF0A0E21); // Primary color
  final Color _cardColor = const Color(0xFFFAF3E0); // Soft beige for classic look
  final Color _shadowColor = const Color(0xFFE0E0E0); // Soft shadow color

  @override
  void initState() {
    super.initState();
    // Call fetchFavoriteBooks when the page is initialized
    controller.fetchFavoriteBooks();
  }

  void _showBookDetailsDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.coverUrl.isNotEmpty)
                  Image.network(book.coverUrl, width: 100, height: 150, fit: BoxFit.cover),
                Text('Title: ${book.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Author: ${book.author}', style: TextStyle(fontSize: 16)),
                Text('Page Count: ${book.pageCount}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Category: ${book.categoryId}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Description: ${book.description}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: SafeArea(
        child: Obx(() {
          final favoriteBooks = controller.favoriteBooks;
          if (favoriteBooks.isEmpty) {
            return Center(
              child: Text('No Favorites found.', style: TextStyle(fontSize: 16)),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];
              return Card(
                color: _cardColor,
                elevation: 6,
                shadowColor: _shadowColor,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: book.coverUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(book.coverUrl, width: 50, height: 75, fit: BoxFit.cover),
                  )
                      : Icon(Icons.book, size: 50, color: _primaryColor),
                  title: Text(
                    book.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800], // Elegant brown color for title
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.author, style: TextStyle(fontSize: 16, color: Colors.brown[600])),
                      SizedBox(height: 5),
                      Text(
                        'Page Count: ${book.pageCount}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'Category: ${book.categoryId}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.brown[700]),
                    onPressed: () => _showBookDetailsDialog(context, book),
                  ),
                ),
              );
            },
          );
        }),
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
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 2, // Set current index to Favorites
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle bottom navigation bar taps
          switch (index) {
            case 0:
              Get.toNamed('/home'); // Navigate to Home
              break;
            case 1:
              Get.toNamed('/mybooks'); // Navigate to My Books
              break;
            case 2:
            // Already on FavoritesPage
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
