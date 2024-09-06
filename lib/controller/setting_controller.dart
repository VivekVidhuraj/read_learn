import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsController extends GetxController {
  var settings = {}.obs;

  @override
  void onInit() {
    fetchSettings();
    super.onInit();
  }

  void fetchSettings() async {
    try {
      DocumentSnapshot settingsDoc = await FirebaseFirestore.instance.collection('settings').doc('app_settings').get();
      if (settingsDoc.exists) {
        settings.value = settingsDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch settings.');
    }
  }

  void updateSettings(Map<String, dynamic> updatedSettings) async {
    try {
      await FirebaseFirestore.instance.collection('settings').doc('app_settings').update(updatedSettings);
      fetchSettings(); // Refresh settings after update
      Get.snackbar('Success', 'Settings updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update settings.');
    }
  }
}