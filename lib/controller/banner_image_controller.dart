import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:read/banner_images/model/banner_image_model.dart';
class BannerImageController extends GetxController{
var bannerImages=<BannerImage>[].obs;
@override
  void onInit() {

    super.onInit();
    fetchBatchImage();
  }
  void fetchBatchImage()async{

  final snapshot = await FirebaseFirestore.instance
      .collection('banner_images')
      .orderBy('uploadedAt', descending: true)
      .get();
  final List<BannerImage> images = snapshot.docs
  .map((doc) => BannerImage.fromFirestore(doc.id,doc.data()))
  .toList();

  bannerImages.value= images;
  }
}