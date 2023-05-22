import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizish/models/Quiz.dart';


import '../models/Session.dart';

class GameSessionService {
  final CollectionReference _gameSessionsCollection =
  FirebaseFirestore.instance.collection('gameSessions');

  String generateRandomId(int length) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String result = '';
    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }

  Future<GameSession> createGameSession(Quiz quiz) async {
    User? _host = FirebaseAuth.instance.currentUser!;
    String gameSessionId = generateRandomId(5);
    Map<String, dynamic> scores = {}; // Empty scores map
    GameSession gameSession = GameSession(
      id: gameSessionId,
      hostId: _host.uid,
      currentQuestion: 0,
      scores: scores,
      quiz: null,
    );
    DocumentReference sessionRef = _gameSessionsCollection.doc(gameSessionId);
    gameSession.id = gameSessionId;
    await sessionRef.set(gameSession.toMap());
    await addQuizToSession(gameSessionId, quiz);
    await addHostToSession(gameSessionId, _host);
    gameSession.quiz = quiz;
    return gameSession;
  }

  Future<void> incrementCurrentQuestion(String sessionId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('incrementCurrentQuestion');
      final Map<String, dynamic> data = {'sessionId': sessionId};
      final result = await callable.call(data);
      final int newCurrentQuestion = result.data['currentQuestion'];
      print('Current question incremented to: $newCurrentQuestion');
    } catch (e) {
      print('Error incrementing current question: $e');
    }
  }



  Future<GameSession?> getGameSessionByCode(String sessionId) async {
    try {
      DocumentSnapshot sessionSnapshot = await _gameSessionsCollection.doc(sessionId).get();
      final dynamic sessionValue = sessionSnapshot.data();

      if (sessionValue != null && sessionValue is Map<String, dynamic>) {
        final gameSessionMap = Map<String, dynamic>.from(sessionValue);
        final quizMap = Map<String, dynamic>.from(gameSessionMap['quiz']);
        final quiz = Quiz.fromMap(quizMap); // Ensure Quiz.fromMap returns Quiz?
        final gameSession = GameSession.fromMap(gameSessionMap);
        gameSession.quiz = quiz; // Make sure the assignment is compatible
        return gameSession;
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error retrieving game session: $e');
    }
    return null;
  }


  Future<void> addUserToSession(String sessionId, User? user) async {
    try {
      DocumentSnapshot sessionSnapshot =
      await _gameSessionsCollection.doc(sessionId).get();
      final dynamic sessionValue = sessionSnapshot.data();

      if (sessionValue != null && sessionValue is Map<String, dynamic>) {
        final scores = sessionValue['scores'];
        final updatedScores = scores != null ? Map.from(scores) : {};
        updatedScores[user?.uid] = 0;
        await _gameSessionsCollection
            .doc(sessionId)
            .update({'scores': updatedScores});
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error adding user to game session: $e');
    }
  }

  Future<void> addQuizToSession(String sessionId, Quiz quiz) async {
    try {
      await _gameSessionsCollection
          .doc(sessionId)
          .update({'quiz': quiz.toMap()});
    } catch (e) {
      print('Error adding quiz to game session: $e');
    }
  }

  Future<void> addHostToSession(String sessionId, User user) async {
    try {
      await _gameSessionsCollection.doc(sessionId).update({'hostId': user.uid});
    } catch (e) {
      print('Error adding host to game session: $e');
    }
  }

  Future<void> updateCurrentQuestion(String sessionId, int currentQuestion) async {
    try {
      await _gameSessionsCollection.doc(sessionId).update({'currentQuestion': currentQuestion});
    } catch (e) {
      print('Error updating current question: $e');
    }
  }

  Future<void> removeUserFromSession(String sessionId, User user) async {
    try {
      DocumentSnapshot sessionSnapshot = await _gameSessionsCollection.doc(sessionId).get();
      if (sessionSnapshot.exists) {
        final data = sessionSnapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
        final scores = data?['scores'] as Map<dynamic, dynamic>?; // Cast to Map<dynamic, dynamic>?
        if (scores != null) {
          scores.remove(user.uid);
          await _gameSessionsCollection.doc(sessionId).update({'scores': scores});
        }
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error removing user from game session: $e');
    }
  }


  Stream<DocumentSnapshot> getGameSessionData(String sessionId) {
    return _gameSessionsCollection.doc(sessionId).snapshots();
  }

  Future<String?> getUserDisplayName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        final userData = userSnapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
        final displayName = userData?['displayName'] as String?;
        print('Retrieved displayName: $displayName');
        return displayName;
      } else {
        print('User snapshot does not exist or data is null for userId: $userId');
      }
    } catch (e) {
      print('Error retrieving user display name for userId: $userId - $e');
    }
    return null;
  }




  Stream<List<String>> getAllUsersBySession(String? sessionId) async* {
    try {
      final gameSessionData = getGameSessionData(sessionId!);
      await for (final gameSession in gameSessionData) {
        if (gameSession.exists && gameSession.data() != null) {
          final scores = gameSession['scores'];
          if (scores != null && scores is Map<dynamic, dynamic>) {
            final playerIds = scores.keys.cast<String>().toList();
            final displayNames = <String>[];
            for (var playerId in playerIds) {
              final displayName = await getUserDisplayName(playerId);
              if (displayName != null) {
                displayNames.add(displayName);
              }
            }
            yield displayNames;
            print(displayNames);
          }
        } else {
          yield [];
        }
      }
    } catch (e) {
      print('Error retrieving users from game session: $e');
      yield [];
    }
  }
}