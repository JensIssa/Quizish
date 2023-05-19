import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Quiz.dart';

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

// Create a new quiz in Firebase
  Future<void> createQuiz(Quiz quiz) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      // Create a new document in the "quizzes" collection
      DocumentReference quizRef =
      FirebaseFirestore.instance.collection('quizzes').doc();

      // Set the data for the quiz document
      await quizRef.set(quiz.toMap());
      quiz.id = quizRef.id;
      // Update the "author" field with the current user's ID
      await quizRef.update({'author': user.uid});

      print('Quiz created successfully!');
    } catch (e) {
      print('Error creating quiz: $e');
    }
  }

  Future<void> getQuizzes() async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');
    final quiz = await quizRef.get();
    _quizzes = quiz.docs.map((doc) => Quiz.fromMapWithID(doc.id, doc.data())).toList();
    _quizzesController.add(_quizzes);
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
