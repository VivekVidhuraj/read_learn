import 'package:cloud_firestore/cloud_firestore.dart';

class BannerImage {
  final String banner_id;
  final String imageUrl;
  final DateTime uploadedAt;
  BannerImage(this.banner_id, this.imageUrl, this.uploadedAt);



  factory BannerImage.fromFirestore(String banner_id, Map< String, dynamic>data)
  {
    return BannerImage(banner_id, data['imageUrl']as String, (data['uploadedAt'] as Timestamp).toDate());
  }
}