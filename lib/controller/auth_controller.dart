import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read/model/auth_model.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthModel _authModel = AuthModel();
  final Rxn<User> _firebaseUser = Rxn<User>();

  final GetStorage _storage = GetStorage(); // Persistent storage

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_authModel.authStateChanges());
  }

  Future<void> handleUserAuth() async {
    if (_storage.read('uid') != null) {
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the email is verified
      if (user != null && user.emailVerified) {
        Get.offAllNamed('/home'); // Navigate to home screen
      } else {
        // If not verified, prompt user to verify their email
        Get.offAllNamed('/login'); // Or another screen informing about verification
        Get.snackbar('Email Not Verified', 'Please verify your email to access the home screen.');
      }
    } else {
      Get.offAllNamed('/login'); // Navigate to login screen
    }
  }

  Future<void> login(String email, String password) async {
    try {
      User? user = await _authModel.signInWithEmailAndPassword(email, password);
      if (user != null && !user.emailVerified) {
        await _authModel.sendEmailVerification(user);
        Get.snackbar('Verification Email Sent', 'Please verify your email.');
        Get.offAllNamed('/login'); // Navigate to login or verification screen
      } else {
        bool userExists = await _authModel.checkUserExists(user!.uid);
        if (userExists) {
          _storage.write('uid', user.uid); // Save the user’s UID persistently
          Get.offAllNamed('/home'); // Navigate to home screen
        } else {
          Get.offAllNamed('/login'); // Navigate to login screen
        }
      }
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      User? user = await _authModel.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        await _authModel.sendEmailVerification(user);
        Get.snackbar('Verification Email Sent', 'Please verify your email.');

        // Don't navigate to home yet, wait for verification
        _storage.write('uid', user.uid); // Save the user’s UID persistently
        Get.offAllNamed('/login'); // Navigate to login or verification screen
      }
    } catch (e) {
      Get.snackbar('Sign Up Failed', e.toString());
    }
  }

  Future<void> signOut() async {
    await _authModel.signOut();
    _storage.remove('uid'); // Remove the user’s UID from persistent storage
    Get.offAllNamed('/login'); // Navigate to login screen
  }
}
