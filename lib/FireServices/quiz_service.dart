import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/Quiz.dart';

import 'package:firebase_storage/firebase_storage.dart' as storage;


class UserKeys {
  static const name = 'name';
  static const email = 'email';
}

String generateId() {
  return Random().nextInt(2 ^ 53).toString();
}


class QuizService {

  List<Quiz> _quizzes = [];
  final _quizzesController = StreamController<List<Quiz>>.broadcast();


  QuizService() {
    _quizzesController.add(_quizzes);
  }

  Stream<List<Quiz>> get quizzes => _quizzesController.stream;

  Future<void> createQuiz(Quiz quiz) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      DocumentReference quizRef =
      FirebaseFirestore.instance.collection('quizzes').doc();
      quiz.id = quizRef.id;
      await quizRef.set(quiz.toMap());
      await quizRef.update({'author': user.uid});
      String displayName = await getUserDisplayName(user.uid);
      await quizRef.update({'authorDisplayName': displayName});
      print(quiz);
    } catch (e) {
      print('Error creating quiz: $e');
    }
  }

  Future<String> uploadImage(XFile image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("quiz_images/${generateId()}/QuestionImage");
    if (kIsWeb) {
      UploadTask uploadTask =
      ref.putData(await image.readAsBytes(), SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } else {
      await ref.putFile(File(image.path));
      return ref.getDownloadURL(); // Return the download URL directly
    }
  }

  // Get the display name for a given user ID
  Future<String> getUserDisplayName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        String displayName = userData['displayName'] ?? '';
        return displayName;
      }
    } catch (e) {
      print('Error getting user display name: $e');
    }
    return '';
  }

  Stream<List<Quiz>> getQuizzes() {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');
    final quiz = quizRef.withConverter(
      fromFirestore: (snapshot, options) => Quiz.fromMap(snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    );

    return quiz.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }


  Future<void> deleteQuiz(String quizId) async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes').doc(quizId);
    await quizRef.delete();
  }

  Future<void> getIndividualQuiz(String quizId) async{
    final quizRef = FirebaseFirestore.instance.collection('quizzes').doc(quizId);
    await quizRef.get(); //Get the quiz from the database
  }
}
