import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';




class UserService {

  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void>  signUp(String email, String password, String displayName) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await db.collection('users').doc(user.user?.uid).set({
    });
  }

  Future<void> signIn(String email, String password) async{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}