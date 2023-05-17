import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> createQuiz(Quiz quiz) async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes').doc();
    quiz.id = quizRef.id;
    await quizRef.set(quiz.toMap());
  }

  Future<void> getQuizzes() async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');
    final quiz = await quizRef.get();
    _quizzes = quiz.docs.map((doc) => Quiz.fromMap(doc.id, doc.data())).toList();
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
