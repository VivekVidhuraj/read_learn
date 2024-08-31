import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String name;
  String author;
  double price;
  String description;
  String categoryId;
  String subcategoryName;
  String coverUrl;
  String pdfUrl;
  int pageCount;
  String userId;
  Timestamp createdAt;

  Book({
    required this.name,
    required this.author,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.subcategoryName,
    required this.coverUrl,
    required this.pdfUrl,
    required this.pageCount,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'author': author,
      'price': price,
      'description': description,
      'category_id': categoryId,
      'subcategory_name': subcategoryName,
      'cover_url': coverUrl,
      'pdf_url': pdfUrl,
      'page_count': pageCount,
      'created_at': createdAt,
      'user_id': userId,
    };
  }

  static Book fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book(
      name: data['name'],
      author: data['author'],
      price: data['price'],
      description: data['description'],
      categoryId: data['category_id'],
      subcategoryName: data['subcategory_name'],
      coverUrl: data['cover_url'],
      pdfUrl: data['pdf_url'],
      pageCount: data['page_count'],
      createdAt: data['created_at'],
      userId: data['user_id'],
    );
  }
}
