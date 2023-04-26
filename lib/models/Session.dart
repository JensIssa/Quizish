import 'package:firebase_auth/firebase_auth.dart';
import 'package:kahoot_proof_of_concept/models/Quiz.dart';

class GameSession {
  String id;
  String gameID;
  User host;
  List<User> players; //Duplicate data, use the players in the scores map instead
  Quiz quiz;
  int currentQuestion;
  Map<User, int> scores;

  GameSession(
      {required this.id,
      required this.gameID,
      required this.host,
      required this.players,
      required this.quiz,
      required this.currentQuestion,
      required this.scores});

  GameSession.fromMap(this.id, Map<String, dynamic> data)
      : gameID = data['gameID'],
        host = data['host'],
        players = data['players'],
        quiz = data['quiz'],
        currentQuestion = data['currentQuestion'],
        scores = data['scores'];

  Map<String, dynamic> toMap() {
    return {
      'gameID': gameID,
      'host': host,
      'players': players,
      'quiz': quiz,
      'currentQuestion': currentQuestion,
      'scores': scores,
    };
  }
}
