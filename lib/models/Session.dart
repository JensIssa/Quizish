import 'package:firebase_auth/firebase_auth.dart';

import 'Quiz.dart';

class GameSession {
  String id;
  String gameID;
  User host;
  Quiz quiz;
  int currentQuestion;
  Map<User, int> scores;

  GameSession(
      {required this.id,
      required this.gameID,
      required this.host,
      required this.quiz,
      required this.currentQuestion,
      required this.scores});

  GameSession.fromMap(this.id, Map<String, dynamic> data)
      : gameID = data['gameID'],
        host = data['host'],
        quiz = data['quiz'],
        currentQuestion = data['currentQuestion'],
        scores = data['scores'];

  Map<String, dynamic> toMap() {
    return {
      'gameID': gameID,
      'host': host,
      'quiz': quiz,
      'currentQuestion': currentQuestion,
      'scores': scores,
    };
  }
}
