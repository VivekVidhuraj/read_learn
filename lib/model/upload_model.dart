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
