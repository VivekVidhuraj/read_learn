// banner_image_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerImage {
  final String id;
  final String imageUrl;
  final DateTime uploadedAt;

  BannerImage({
    required this.id,
    required this.imageUrl,
    required this.uploadedAt,
  });

  factory BannerImage.fromFirestore(String id, Map<String, dynamic> data) {
    return BannerImage(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
    );
  }
}
