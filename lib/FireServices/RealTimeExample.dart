import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<GameSession?> createGameSession(Quiz quiz) async {
    try {
      User? _host = FirebaseAuth.instance.currentUser!;
      String gameSessionId = generateRandomId(5);
      GameSession gameSession = GameSession(
        id: gameSessionId,
        hostId: _host.uid,
        currentQuestion: 0,
        scores: null,
        quiz: null,
      );
      final sessionRef =
      _databaseReference.child('gameSessions').child(gameSessionId);
      gameSession.id = gameSessionId;
      await sessionRef.set(gameSession.toMap());
      await addQuizToSesion(gameSessionId, quiz);
      await addHostToSession(gameSessionId, _host);
      gameSession.quiz = quiz;
      return gameSession;
    } catch (e) {
      print('Error creating game session: $e');
    }
    return null;
  }

  Future<GameSession?> getGameSessionByCode(String sessionId) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(sessionId);
      DataSnapshot sessionSnapshot = await sessionRef.get();
      final dynamic sessionValue = sessionSnapshot.value;
      if (sessionValue != null && sessionValue is Map<dynamic, dynamic>) {
        final gameSessionMap = Map<String, dynamic>.from(sessionValue);
        print('----------------------');
        print(gameSessionMap);
        final quizMap = Map<String, dynamic>.from(gameSessionMap['quiz']);
        print('--------------------');
        print(quizMap);
        final quiz = Quiz.fromMap(quizMap);
        print('---------------------');
        print(quiz);
        final gameSession = GameSession.fromMap(gameSessionMap);
        print('----------------------');
        print(gameSession);
        gameSession.quiz = quiz;
        return gameSession;
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error getting game session: $e');
    }
    return null;
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

  Future<void> addQuizToSesion(String sessionId, Quiz quiz) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(
          sessionId);
      DataSnapshot sessionSnapshot = await sessionRef.get();
      final dynamic sessionValue = sessionSnapshot.value;

      if (sessionValue != null && sessionValue is Map<dynamic, dynamic>) {
        final gameSessionMap = Map<String, dynamic>.from(sessionValue);
        gameSessionMap['quiz'] = quiz.toMap();
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
        gameSessionMap['hostId'] = user.uid;
        await sessionRef.set(gameSessionMap);
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error adding host to game session: $e');
    }
  }


  Future<void> updateCurrentQuestion(String sessionId,
      int currentQuestion) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(
          sessionId);
      await sessionRef.child('currentQuestion').set(currentQuestion);
    } catch (e) {
      print('Error updating current question: $e');
    }
  }


  Future<void> removeUserFromSession(String sessionId, User user) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(
          sessionId);

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

  Stream<Map> getGameSessionData(String sessionId) {
    return _databaseReference.child('gameSessions').child(sessionId).onValue.map((event) => event.snapshot).map((event) => event.value as Map<dynamic, dynamic>);
  }

  Future<String?> getUserDisplayName(String userId) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists && userSnapshot.data() != null) {
      final userData = userSnapshot.data() as Map<dynamic, dynamic>;
      return userData['displayName'] as String?;
    } else {
      return null;
    }
  }

  Stream<List<String>> getAllUsersBySession(String? sessionId) async* {
    try {
      final gameSessionData = getGameSessionData(sessionId!);
      await for (final gameSession in gameSessionData) {
        if (gameSession.isNotEmpty) {
          final scores = gameSession['scores'] as Map<dynamic, dynamic>;
          final playerIds = scores.keys.cast<String>().toList();
          final displayNames = <String>[];
          for (var playerId in playerIds) {
            final displayName = await getUserDisplayName(playerId);
            print('Display name: $displayName');
            if (displayName != null) {
              displayNames.add(displayName);
            }
          }
          yield displayNames;
        } else {
          yield [];
        }
      }
    } catch (e) {
      print('Cannot get the users from the session $e');
      yield [];
    }
  }
}
