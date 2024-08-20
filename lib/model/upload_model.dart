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
    var data = doc.data() as Map<String, dynamic>;
    var subcategories = (data['subcategories'] as List<dynamic>).map((subcat) {
      return Subcategory.fromMap(subcat);
    }).toList();

    return BookCategory(
      categoryId: data['category_id'],
      categoryName: data['category_name'],
      categoryDesc: data['category_desc'],
      subcategories: subcategories,
    );
  }
}

class Subcategory {
  final String subcategoryId;
  final String subcategoryName;

  Subcategory({
    required this.subcategoryId,
    required this.subcategoryName,
  });

  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      subcategoryId: map['subcategory_id'],
      subcategoryName: map['subcategory_name'],
    );
  }
}
