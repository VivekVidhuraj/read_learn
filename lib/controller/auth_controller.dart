
import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_firebaseAuth.authStateChanges());
  }

  Future<User?> login(String email, String password, {bool rememberMe = false}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          final userDoc = await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            if (rememberMe) {
              await _saveCredentials(email, password);
            } else {
              await _clearCredentials();
            }
            return user;
          } else {
            await _firebaseAuth.signOut();
            Get.snackbar('Error', 'User data not found in the database.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white);
            return null;
          }
        } else {
          await _firebaseAuth.signOut();
          Get.snackbar('Error', 'Please verify your email address.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return null;
        }
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      final errorMessage = _getErrorMessage(e.code);
      if (errorMessage.isNotEmpty) {
        Get.snackbar('Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
      return null;
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<void> signUp(String username, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateProfile(displayName: username);

        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'profilePicture': '', // Default profile picture URL or empty string
          'createdAt': FieldValue.serverTimestamp(),
        });

        await user.sendEmailVerification();
        Get.snackbar('Success', 'Verification email sent. Please check your inbox.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.offAllNamed('/login');
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      if (errorMessage.isNotEmpty) {
        Get.snackbar('Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent. Check your inbox.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      if (errorMessage.isNotEmpty) {
        Get.snackbar('Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }
  Future<void> updateUserName(String newName) async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        // Update the user's display name in Firebase Authentication
        await currentUser.updateProfile(displayName: newName);

        // Update the user's username in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'username': newName,
        });

        // Refresh the user data
        await currentUser.reload();
        _user.value = _firebaseAuth.currentUser;

        Get.snackbar('Success', 'Username updated successfully.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update username.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }


  Future<void> updateProfilePicture(String imagePath) async {
    final File imageFile = File(imagePath);

    // Read the image file
    final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image != null) {
      // Define desired width and height
      const int targetWidth = 200;
      const int targetHeight = 200;

      // Resize the image
      final img.Image resizedImage = img.copyResize(image, width: targetWidth, height: targetHeight);

      // Convert resized image back to file
      final List<int> resizedImageBytes = img.encodeJpg(resizedImage);
      final File resizedImageFile = File(imageFile.path)..writeAsBytesSync(resizedImageBytes);

      // Upload the resized image to Firebase Storage
      String fileName = path.basename(imageFile.path);
      firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
      firebase_storage.UploadTask uploadTask = storageRef.putFile(resizedImageFile);
      await uploadTask;

      // Get the download URL
      String downloadURL = await storageRef.getDownloadURL();

      // Update the user's photo URL in Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      await user!.updatePhotoURL(downloadURL);

      // Update the photo URL in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'profilePicture': downloadURL,
      });

      // Refresh the user data
      _user.value = FirebaseAuth.instance.currentUser;
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'The user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
