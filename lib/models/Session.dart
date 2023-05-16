import 'package:firebase_auth/firebase_auth.dart';

import 'Quiz.dart';

class GameSession {
  String id;
  User? host;
  Quiz? quiz;
  int? currentQuestion;
  Map<User?, int>? scores;

  GameSession(
      {required this.id,
      required this.host,
      required this.quiz,
      required this.currentQuestion,
      required this.scores});

  GameSession.fromMap(Map<String, dynamic> data)
      :host = data['host'],
        quiz = data['quiz'],
        currentQuestion = data['currentQuestion'],
        id = data['id'],
        scores = data['scores'];

  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'quiz': quiz,
      'currentQuestion': currentQuestion,
      'scores': scores,
      'id': id
    };
  }
}
