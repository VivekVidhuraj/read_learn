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
  final bool isNormalBook;
  final String pdfUrl;
  double? rating; // Add this field for rating

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
    required this.isNormalBook,
    required this.pdfUrl,
    this.rating, // Initialize this field
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
      isNormalBook: isNormalBook,
      pdfUrl: data['pdf_url'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(), // Initialize the rating
    );
  }
}
