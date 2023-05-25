import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      // Create a new document reference in Firestore
      DocumentReference quizRef =
      FirebaseFirestore.instance.collection('quizzes').doc();
      quiz.id = quizRef.id;
      // Set quiz data in Firestore
      await quizRef.set(quiz.toMap());
      // Update author and authorDisplayName
      await quizRef.update({'author': user.uid});
      String displayName = await getUserDisplayName(user.uid);
      await quizRef.update({'authorDisplayName': displayName});
      // Upload images to Firebase Storage and get the download URLs
      List<String> imageUrls = await _uploadImages(quiz.questions);
      // Update quiz data with image URLs
      for (int i = 0; i < quiz.questions.length; i++) {
        Question question = quiz.questions[i];
        if (question.imageUrl != null) {
          question.imageUrl = imageUrls[i];
          print(question.imageUrl);
        }
      }
      print(quiz);
    } catch (e) {
      print('Error creating quiz: $e');
    }
  }
  Future<List<String>> _uploadImages(List<Question> questions) async {
    List<String> imageUrls = [];
    for (Question question in questions) {
      if (question.imageUrl != null) {
        try {
          http.Response response =
          await http.get(Uri.parse(question.imageUrl!));
          Uint8List imageData = response.bodyBytes;
          String imageName = DateTime.now().microsecondsSinceEpoch.toString();
          String imagePath = 'quiz_images/$imageName.jpg';
          storage.Reference imageRef =
          storage.FirebaseStorage.instance.ref().child(imagePath);
          await imageRef.putData(imageData);
          String downloadUrl = await imageRef.getDownloadURL();
          imageUrls.add(downloadUrl);
        } catch (e) {
          print('Error uploading image: $e');
          imageUrls.add(''); // Add empty URL if upload fails
        }
      } else {
        imageUrls.add(''); // Add empty URL for questions without images
      }
    }

    return imageUrls;
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

  Future<List<Quiz>> getQuizzes() async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');
    final quiz = quizRef.withConverter(fromFirestore: (snapshot, options) => Quiz.fromMap(snapshot.data()!), toFirestore: (value, options) => value.toMap());
    return quiz.get().then((value) => value.docs.map((e) => e.data()).toList());
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
