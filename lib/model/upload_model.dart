import 'package:cloud_firestore/cloud_firestore.dart';

class BookCategory {
  final String categoryId;
  final String categoryName;
  final String categoryDesc;
  final List<Subcategory> subcategories;

  BookCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDesc,
    required this.subcategories,
  });

  factory BookCategory.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return BookCategory(
      categoryId: data['category_id'] ?? '',
      categoryName: data['category_name'] ?? '',
      categoryDesc: data['category_desc'] ?? '',
      subcategories: (data['subcategory'] as List<dynamic>?)
          ?.map((subcategoryData) => Subcategory.fromMap(subcategoryData))
          .toList() ??
          [],
    );
  }
}

class Subcategory {
  final String subcategoryName;
  final String subcategoryDesc;

  Subcategory({
    required this.subcategoryName,
    required this.subcategoryDesc,
  });

  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      subcategoryName: map['subcategory_name'] ?? '',
      subcategoryDesc: map['subcategory_desc'] ?? '',
    );
  }
}

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
    );
  }
}