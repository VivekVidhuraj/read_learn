import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/book_model.dart';
import '../controller/auth_controller.dart'; // Import AuthController

class BookController extends GetxController {
  var recentlyPublishedBooks = <Book>[].obs;
  final AuthController _authController = Get.find<AuthController>(); // Access AuthController

  @override
  void onInit() {
    super.onInit();
    fetchRecentlyPublishedBooks();
  }

  Future<void> fetchRecentlyPublishedBooks() async {
    try {
      final currentUserId = _authController.user?.uid; // Get the current user's ID

      // Fetch books from 'normal_books' collection
      final normalBooksQuery = FirebaseFirestore.instance
          .collection('normal_books')
          .where('user_id', isNotEqualTo: currentUserId) // Exclude books by the current user
          .limit(10) // Limit the number of books
          .get();

      // Fetch books from 'premium_books' collection
      final premiumBooksQuery = FirebaseFirestore.instance
          .collection('premium_books')
          .where('user_id', isNotEqualTo: currentUserId) // Exclude books by the current user
          .limit(10) // Limit the number of books
          .get();

      // Wait for both queries to complete
      final normalBooksSnapshot = await normalBooksQuery;
      final premiumBooksSnapshot = await premiumBooksQuery;

      // Convert documents to Book objects
      final normalBooks = normalBooksSnapshot.docs
          .map((doc) => Book.fromDocument(doc, isNormalBook: true))
          .toList();

      final premiumBooks = premiumBooksSnapshot.docs
          .map((doc) => Book.fromDocument(doc, isNormalBook: false))
          .toList();

      // Combine both lists and sort by your preferred criteria, if needed
      final allBooks = [...normalBooks, ...premiumBooks];

      // Update the observable list with combined results
      recentlyPublishedBooks.value = allBooks;

    } catch (e) {
      print('Error fetching recently published books: $e');
    }
  }
}