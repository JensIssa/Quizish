import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kahoot_proof_of_concept/models/Session.dart';

import 'models/Quiz.dart';

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


}
