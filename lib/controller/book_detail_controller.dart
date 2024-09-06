import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';
import '../model/book_model.dart';

class BookDetailsController extends GetxController {
  final String bookId;
  var book = Rxn<Book>();
  var isBookPurchased = false.obs; // Track if the book is purchased
  var isFavorite = false.obs; // Track if the book is a favorite

  BookDetailsController({required this.bookId});

  @override
  void onInit() {
    super.onInit();
    fetchBookDetails();
    checkIfBookPurchased(); // Check if the book has been purchased
    checkIfBookFavorite(); // Check if the book is marked as favorite
  }

  Future<void> fetchBookDetails() async {
    try {
      // First, try to fetch from 'normal_books'
      final normalBookSnapshot = await FirebaseFirestore.instance
          .collection('normal_books')
          .doc(bookId)
          .get();

      if (normalBookSnapshot.exists) {
        book.value = Book.fromDocument(normalBookSnapshot, isNormalBook: true);
        return;
      }

      // If not found in 'normal_books', try to fetch from 'premium_books'
      final premiumBookSnapshot = await FirebaseFirestore.instance
          .collection('premium_books')
          .doc(bookId)
          .get();

      if (premiumBookSnapshot.exists) {
        book.value = Book.fromDocument(premiumBookSnapshot, isNormalBook: false);
      } else {
        // Handle the case where the book is not found in either collection
        print('Book not found in both collections');
      }
    } catch (e) {
      print('Error fetching book details: $e');
    }
  }

  Future<void> checkIfBookPurchased() async {
    try {
      final userId = Get.find<AuthController>().user?.uid;
      if (userId != null) {
        final purchaseSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('purchased_books')
            .doc(bookId)
            .get();

        isBookPurchased.value = purchaseSnapshot.exists;
      }
    } catch (e) {
      print('Error checking book purchase status: $e');
    }
  }

  Future<void> markBookAsPurchased() async {
    try {
      final userId = Get.find<AuthController>().user?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('purchased_books')
            .doc(bookId)
            .set({'purchased_at': Timestamp.now()});
        isBookPurchased.value = true;
      }
    } catch (e) {
      print('Error marking book as purchased: $e');
    }
  }

  Future<void> checkIfBookFavorite() async {
    try {
      final userId = Get.find<AuthController>().user?.uid;
      if (userId == null) return;

      final favoriteSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(bookId)
          .get();

      isFavorite.value = favoriteSnapshot.exists;
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> addToFavorites() async {
    try {
      final userId = Get.find<AuthController>().user?.uid;
      if (userId == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(bookId)
          .set({'added_at': Timestamp.now()});
      isFavorite.value = true;
    } catch (e) {
      print('Error adding book to favorites: $e');
    }
  }

  Future<void> removeFromFavorites() async {
    try {
      final userId = Get.find<AuthController>().user?.uid;
      if (userId == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(bookId)
          .delete();
      isFavorite.value = false;
    } catch (e) {
      print('Error removing book from favorites: $e');
    }
  }

  void toggleFavorite() {
    if (isFavorite.value) {
      removeFromFavorites();
    } else {
      addToFavorites();
    }
  }
}
