import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizish/models/Quiz.dart';

import '../models/Session.dart';

class GameSessionService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  String generateRandomId(int length) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  //Have host and quiz as parameters.
  Future<void> createGameSession(Quiz quiz) async {
    try {
      User? _host = FirebaseAuth.instance.currentUser!;
      String gameSessionId = generateRandomId(5);
      GameSession gameSession = GameSession(
        id: gameSessionId,
        host: null,
        currentQuestion: 0,
        scores: null,
      );
      final sessionRef =
      _databaseReference.child('gameSessions').child(gameSessionId);
      gameSession.id = gameSessionId;
      await sessionRef.set(gameSession.toMap());
      await addQuizToSesion(gameSessionId, quiz);
      await addHostToSession(gameSessionId, _host);
    } catch (e) {
      print('Error creating game session: $e');
    }
  }

  Future<void> addUserToSession(String sessionId, User? user) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(
          sessionId);
      DataSnapshot sessionSnapshot = await sessionRef.get();
      final dynamic sessionValue = sessionSnapshot.value;

      if (sessionValue != null && sessionValue is Map<dynamic, dynamic>) {
        final scores = sessionValue['scores'];
        final updatedScores = scores != null ? Map.from(scores) : {
        }; // Initialize scores if null
        updatedScores[user?.uid] = 0;
        await sessionRef.child('scores').set(updatedScores);
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error adding user to game session: $e');
    }
  }

  Future<void> addQuizToSesion(String sessionId,  Quiz quiz) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(sessionId);
      DataSnapshot sessionSnapshot = await sessionRef.get();
      final dynamic sessionValue = sessionSnapshot.value;

      if (sessionValue != null && sessionValue is Map<dynamic, dynamic>) {
        final gameSessionMap = Map<String, dynamic>.from(sessionValue);
        final quizMap = Map<String, dynamic>.from(gameSessionMap['quiz'] ?? {});
        quizMap[quiz.id] = quiz.toMap();
        gameSessionMap['quiz'] = quizMap;

        await sessionRef.set(gameSessionMap);
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error adding quiz to game session: $e');
    }
  }
  //Add host to session
  Future<void> addHostToSession(String sessionId, User user) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(
          sessionId);
      DataSnapshot sessionSnapshot = await sessionRef.get();
      final dynamic sessionValue = sessionSnapshot.value;

      if (sessionValue != null && sessionValue is Map<dynamic, dynamic>) {
        final gameSessionMap = Map<String, dynamic>.from(sessionValue);
        gameSessionMap['host'] = user.uid;
        await sessionRef.set(gameSessionMap);
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error adding host to game session: $e');
    }
  }


  Future<void> updateCurrentQuestion(String sessionId, int currentQuestion) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(sessionId);
      await sessionRef.child('currentQuestion').set(currentQuestion);
    } catch (e) {
      print('Error updating current question: $e');
    }
  }


  Future<void> removeUserFromSession(String sessionId, User user) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(sessionId);

      DataSnapshot sessionSnapshot = await sessionRef.get();
      if (sessionSnapshot.value != null) {
        final data = sessionSnapshot.value as Map<dynamic, dynamic>;
        final scores = data['scores'] as Map<dynamic, dynamic>;
        scores.remove(user.uid);
        await sessionRef.child('scores').set(scores);
      }
    } catch (e) {
      print('Cant remove the player from the session $e');
    }
  }
}
