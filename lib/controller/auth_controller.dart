import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);  // Using Rx<User?> to observe changes
  RxList<String> registeredEmails = <String>[].obs; // List of registered emails

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      registeredEmails.add(email);  // Optionally add the email to the list
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void handleUserAuth() {
    if (_auth.currentUser != null) {
      Get.offAllNamed('/home');  // Navigate to home screen if user is logged in
    } else {
      Get.offAllNamed('/login'); // Navigate to login screen if no user is logged in
    }
  }
}
