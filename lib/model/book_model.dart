import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String bookId;
  final String name;
  final String author;
  final double price;
  final String coverUrl;
  final String categoryId;
  final String userId;
  final String description;
  final int pageCount;
  final bool isNormalBook; // New field
  final String pdfUrl; // New field

  Book({
    required this.bookId,
    required this.name,
    required this.author,
    required this.price,
    required this.coverUrl,
    required this.categoryId,
    required this.userId,
    required this.description,
    required this.pageCount,
    required this.isNormalBook, // Initialize this field
    required this.pdfUrl, // Initialize this field
  });

  factory Book.fromDocument(DocumentSnapshot doc, {required bool isNormalBook}) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      bookId: doc.id,
      name: data['name'] ?? '',
      author: data['author'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      coverUrl: data['cover_url'] ?? '',
      categoryId: data['category_id'] ?? '',
      userId: data['user_id'] ?? '',
      description: data['description'] ?? '',
      pageCount: data['page_count'] ?? 0,
      isNormalBook: isNormalBook, // Set this value
      pdfUrl: data['pdf_url'] ?? '', // Make sure to add pdf_url to Firestore documents
    );
  }
}
