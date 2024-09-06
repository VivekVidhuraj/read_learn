
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  RxList<String> registeredEmails = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    // Fetch registered emails and assign to registeredEmails
  }

  void signOut() async {
    await _auth.signOut();
  }
}
