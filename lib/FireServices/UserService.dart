import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  static const name = '';
  static const email = '';
  static const displayName = '';
}

class UserService {

  final _auth = FirebaseAuth.instance;

  final db = FirebaseFirestore.instance;

  Future<void>  signUp(String email, String password, String displayName) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await db.collection('Users').doc(user.user?.uid).set({
      '1': user.user?.uid,
      UserAuth.email: email,
      UserAuth.displayName: displayName,
    });
  }
}
