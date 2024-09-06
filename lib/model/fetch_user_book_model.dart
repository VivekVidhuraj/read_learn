
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String name;
  final String author;
  final double price;
  final String description;
  final String categoryId;
  final String subcategoryName;
  final String coverUrl;
  final String pdfUrl;
  final String userId;
  final DateTime createdAt;
  final int pageCount; // Added field

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.subcategoryName,
    required this.coverUrl,
    required this.pdfUrl,
    required this.userId,
    required this.createdAt,
    required this.pageCount, // Added field
  });

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Book(
      id: doc.id,
      name: data['name'] ?? '',
      author: data['author'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      categoryId: data['category_id'] ?? '',
      subcategoryName: data['subcategory_name'] ?? '',
      coverUrl: data['cover_url'] ?? '',
      pdfUrl: data['pdf_url'] ?? '',
      userId: data['user_id'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      pageCount: data['page_count'] ?? 0, // Added field
    );
  }
}
