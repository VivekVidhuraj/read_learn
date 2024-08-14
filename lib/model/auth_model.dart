import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> checkUserExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print("Error checking if user exists: $e");
      return false;
    }
  }
}
