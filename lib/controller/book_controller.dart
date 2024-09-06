import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/book_model.dart';
import '../controller/auth_controller.dart';

class BookController extends GetxController {
  var recentlyPublishedBooks = <Book>[].obs; // List of books excluding current user's
  var notificationCount = 0.obs; // Notification count for the user
  final AuthController _authController = Get.find<AuthController>(); // Access AuthController

  @override
  void onInit() {
    super.onInit();
    fetchRecentlyPublishedBooks();
    fetchNotificationCount(); // Fetch notifications when the controller initializes
  }

  // Fetch books from Firestore excluding those uploaded by the current user
  Future<void> fetchRecentlyPublishedBooks() async {
    try {
      final currentUserId = _authController.user?.uid; // Get the current user's ID

      // Fetch books from 'normal_books' collection excluding those uploaded by current user
      final normalBooksQuery = FirebaseFirestore.instance
          .collection('normal_books')
          .where('user_id', isNotEqualTo: currentUserId)
          .limit(10) // Limit to avoid fetching too many at once
          .get();

      // Fetch books from 'premium_books' collection excluding those uploaded by current user
      final premiumBooksQuery = FirebaseFirestore.instance
          .collection('premium_books')
          .where('user_id', isNotEqualTo: currentUserId)
          .limit(10)
          .get();

      // Wait for both queries to complete asynchronously
      final normalBooksSnapshot = await normalBooksQuery;
      final premiumBooksSnapshot = await premiumBooksQuery;

      // Convert documents to Book objects, marking if it's a normal book
      final normalBooks = normalBooksSnapshot.docs
          .map((doc) => Book.fromDocument(doc, isNormalBook: true))
          .toList();

      // Convert premium books similarly
      final premiumBooks = premiumBooksSnapshot.docs
          .map((doc) => Book.fromDocument(doc, isNormalBook: false))
          .toList();

      // Combine both lists into one and optionally sort by upload time, etc.
      final allBooks = [...normalBooks, ...premiumBooks];

      // Update the observable list with the combined results
      recentlyPublishedBooks.value = allBooks;

    } catch (e) {
      print('Error fetching recently published books: $e');
    }
  }

  // Fetch the count of new notifications for the current user
  Future<void> fetchNotificationCount() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid; // Current user ID
      if (userId != null) {
        // Fetch notifications where the user is the recipient
        final snapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where('user_id', isEqualTo: userId) // Target specific user's notifications
            .where('timestamp', isGreaterThanOrEqualTo: Timestamp.now()) // Filter for new notifications
            .get();

        // Update notification count observable with the number of documents
        notificationCount.value = snapshot.docs.length;
      }
    } catch (e) {
      print('Error fetching notification count: $e');
    }
  }
}
