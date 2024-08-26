// banner_image_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:read/model/banner_image_model.dart'; // Adjust this path based on your folder structure

class BannerImageController extends GetxController {
  var bannerImages = <BannerImage>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBannerImages();
  }

  void fetchBannerImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('banner_images')
          .orderBy('uploadedAt', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final List<BannerImage> images = snapshot.docs
            .map((doc) => BannerImage.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
        bannerImages.value = images;
      }
    } catch (e) {
      print("Error fetching banner images: $e");
      Get.snackbar('Error', 'Could not fetch banner images.');
    }
  }
}
