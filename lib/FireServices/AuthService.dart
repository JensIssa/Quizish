import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_Auth;

import '../models/User.dart';

class AuthService{

  final firebase_Auth.FirebaseAuth _firebaseAuth;
  final db = FirebaseFirestore.instance;

  AuthService({firebase_Auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_Auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });

  }

   Future<void> signUp({
   required String email,
   required String password,
 }) async {
    try{
      _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
   }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'uid': user.uid
        });
      }
    }  catch (e) {
      throw Exception();
    }
  }


  Future<void> logOut() async {
    try{
      await Future.wait([_firebaseAuth.signOut()]);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}

extension on firebase_Auth.User {
  User get toUser {
    return User(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }
}