import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_Auth;
import '../models/User.dart';

class AuthService{

  final firebase_Auth.FirebaseAuth _firebaseAuth;

  AuthService({firebase_Auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_Auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  /**
   * This method returns a stream of the user, if the user is logged in
   */
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });

  }

  /**
   * This method returns the current authenticated user
   */
  firebase_Auth.User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }


  /**
   * This method signs up the user with the email and password provided, and send it to firebase
   */
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create the user account using Firebase Authentication.
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create a new user profile with the display name and user ID.
      final userProfile = {
        'displayName': displayName,
        'email': email,
        'userId': userCredential.user!.uid,
      };
      // Add the user profile to the 'users' collection in Firebase Firestore.
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(userProfile);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /**
   * This method updates the password of the current user
   */
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /**
   * This method updates the display name of the current user
   */
  Future<void> updateDisplayName(String newDisplayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(newDisplayName);

      await FirebaseFirestore.instance.collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'displayName': newDisplayName});
      currentUser = currentUser.copyWith(displayName: newDisplayName);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }


  /**
   * This method updates the email of the current user
   */
  Future<void> updateEmail(String newEmail) async {
    try {
      await _firebaseAuth.currentUser?.updateEmail(newEmail);

      await FirebaseFirestore.instance.collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'email': newEmail});
      currentUser = currentUser.copyWith(email: newEmail);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }


  /**
   * This method logs in the user with the email and password provided
   */

  Future<void> loginWithEmailAndPassword({
  required String email,
  required String password,
  }) async
  {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /**
   * this method logs out the current user
   */
  Future<void> logOut() async {
    try{
      await Future.wait([_firebaseAuth.signOut()]);
    } on firebase_Auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}

/**
 * This extension is used to convert a firebase user to a user
 */
extension on firebase_Auth.User {
  User get toUser {
    return User(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }
}