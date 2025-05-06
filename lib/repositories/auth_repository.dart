import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel.fromFirestore(
        userData.data() as Map<String, dynamic>,
        userCredential.user!.uid,
      );
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await user.sendEmailVerification();

      final userData = {
        'email': email,
        'name': name,
        'phone': phone,
        'isEmailVerified': false,
      };

      await _firestore.collection('users').doc(user.uid).set(userData);

      return UserModel.fromFirestore(userData, user.uid);
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromFirestore(
        userData.data() as Map<String, dynamic>,
        user.uid,
      );
    }
    return null;
  }
} 