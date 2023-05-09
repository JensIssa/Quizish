import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends Equatable {
  final String? uid;
  final String? email;
  final String? displayName;

  const User({required this.uid,  this.email, this.displayName});

  static const empty = User(uid: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [uid, email, displayName];
}



class UserService {

  final _auth = FirebaseAuth.instance;

  final db = FirebaseFirestore.instance;

  Future<void>  signUp(String email, String password, String displayName) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await db.collection('users').doc(user.user?.uid).set({
      UserAuth.uid: user.user?.uid,
      UserAuth.email: email,
      UserAuth.displayName: displayName,
    });
  }

  Future<void> signIn(String email, String password) async{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
