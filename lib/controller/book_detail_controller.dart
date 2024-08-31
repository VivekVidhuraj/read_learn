import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/book_model.dart';

class BookDetailsController extends GetxController {
  final String bookId;
  var book = Rxn<Book>();

  BookDetailsController({required this.bookId});

  @override
  void onInit() {
    super.onInit();
    fetchBookDetails();
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
}
