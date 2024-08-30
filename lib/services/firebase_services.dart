import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class FirebaseService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Generic method to fetch books from any collection
  Future<List<Book>> getBooks({required String collection}) async {
    try {
      final snapshot = await _firestore.collection(collection).get();
      return snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching books from $collection: $e');
      return [];
    }
  }

  Future<List<Book>> getFeaturedBooks() async {
    return getBooks(collection: 'featuredBooks');
  }

  Future<List<Book>> getRecentlyPublishedBooks() async {
    return getBooks(collection: 'recentlyPublishedBooks');
  }

  Future<List<Book>> getBookmarkedBooks() async {
    try {
      final userId = Get.find<AuthController>().user!.uid;
      final snapshot = await _firestore.collection('users').doc(userId).collection('bookmarks').get();
      return snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching bookmarked books: $e');
      return [];
    }
  }

  Future<List<Book>> getPremiumBooks() async {
    try {
      final userId = Get.find<AuthController>().user!.uid;
      final snapshot = await _firestore.collection('premium_books').get();
      return snapshot.docs
          .map((doc) => Book.fromDocument(doc))
          .where((book) => book.uploaderId != userId) // Exclude books by current user
          .toList();
    } catch (e) {
      print('Error fetching premium books: $e');
      return [];
    }
  }

  Future<List<Book>> getNormalBooks() async {
    try {
      final userId = Get.find<AuthController>().user!.uid;
      final snapshot = await _firestore.collection('normal_books').get();
      return snapshot.docs
          .map((doc) => Book.fromDocument(doc))
          .where((book) => book.uploaderId != userId) // Exclude books by current user
          .toList();
    } catch (e) {
      print('Error fetching normal books: $e');
      return [];
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) => Category.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String coverImageUrl;
  final String pdfUrl;
  final String uploaderId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImageUrl,
    required this.pdfUrl,
    required this.uploaderId,
  });

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      uploaderId: data['uploaderId'] ?? '',
    );
  }
}

class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class Author {
  final String name;
  final String imageUrl;

  Author({
    required this.name,
    required this.imageUrl,
  });
}
