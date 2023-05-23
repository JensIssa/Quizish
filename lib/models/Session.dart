import 'package:firebase_auth/firebase_auth.dart';

import 'Quiz.dart';

class GameSession {
  String id;
  String hostId;
  Quiz? quiz;
  int currentQuestion;
  Map<String?, dynamic>? scores;

  GameSession(
      {required this.id,
        required this.hostId,
        required this.quiz,
        required this.currentQuestion,
        required this.scores});

  GameSession.fromMap(Map<String, dynamic> data)
      : hostId = data['hostId'],
        currentQuestion = data['currentQuestion'],
        id = data['id'],
        scores = data['scores'] as Map<String?, dynamic>?,
        quiz = Quiz.fromMap(data['quiz'] as Map<String, dynamic>); // Create a Quiz object from the map


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
