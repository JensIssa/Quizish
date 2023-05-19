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
      quiz.id = quizRef.id;

      await quizRef.set(quiz.toMap());
      // Update the "author" field with the current user's ID
      await quizRef.update({'author': user.displayName});

      print('Quiz created successfully!');
    } catch (e) {
      print('Error creating quiz: $e');
    }
  }

  Future<List<Quiz>> getQuizzes() async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');
    final quiz = await quizRef.withConverter(fromFirestore: (snapshot, options) => Quiz.fromMap(snapshot.data()!), toFirestore: (value, options) => value.toMap());
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
