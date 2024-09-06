import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';
import '../model/book_model.dart';

class FavoritesController extends GetxController {
  var favoriteBooks = <Book>[].obs; // Observable list of favorite books

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteBooks();
  }

  Future<void> fetchFavoriteBooks() async {
    try {
      final userId = Get.find<AuthController>().user?.uid;
      if (userId == null) return;

      // Fetch favorite book IDs
      final favoritesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      final favoriteBookIds = favoritesSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch details for each favorite book
      final List<Book> books = [];
      for (var bookId in favoriteBookIds) {
        final normalBookSnapshot = await FirebaseFirestore.instance
            .collection('normal_books')
            .doc(bookId)
            .get();

        if (normalBookSnapshot.exists) {
          books.add(Book.fromDocument(normalBookSnapshot, isNormalBook: true));
        } else {
          final premiumBookSnapshot = await FirebaseFirestore.instance
              .collection('premium_books')
              .doc(bookId)
              .get();
          if (premiumBookSnapshot.exists) {
            books.add(Book.fromDocument(premiumBookSnapshot, isNormalBook: false));
          }
        }
      }

      favoriteBooks.value = books;
    } catch (e) {
      print('Error fetching favorite books: $e');
    }
  }
}
