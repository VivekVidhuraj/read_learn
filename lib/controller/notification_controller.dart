import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();
      notifications.value = snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(id)
          .delete();
      notifications.removeWhere((notification) => notification.id == id);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      notifications.clear();
    } catch (e) {
      print('Error deleting all notifications: $e');
    }
  }
}
