import 'package:firebase_auth/firebase_auth.dart';

import 'Quiz.dart';

class GameSession {
  String id;
  String hostId;
  Quiz? quiz;
  int? currentQuestion;
  Map<User?, int>? scores;

  GameSession(
      {required this.id,
        required this.hostId,
        required this.quiz,
        required this.currentQuestion,
        required this.scores});

  GameSession.fromMap(Map<String, dynamic> data)
      :hostId = data['hostId'],
        quiz = data['quiz'],
        currentQuestion = data['currentQuestion'],
        id = data['id'],
        scores = data['scores'];

  Map<String, dynamic> toMap() {
    return {
      'hostId': hostId,
      'quiz': quiz,
      'currentQuestion': currentQuestion,
      'scores': scores,
      'id': id
    };
  }
}
