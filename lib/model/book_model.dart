import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String name;
  final String author;
  final double price;
  final String coverUrl;
  final String categoryId;
  final String userId;

  Book({
    required this.name,
    required this.author,
    required this.price,
    required this.coverUrl,
    required this.categoryId,
    required this.userId,
  });

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      name: data['name'] ?? '',
      author: data['author'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      coverUrl: data['cover_url'] ?? '',
      categoryId: data['category_id'] ?? '',
      userId: data['user_id'] ?? '',
    );
  }
}
  