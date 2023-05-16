import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<void> createGameSession() async {
    try {
      String gameSessionId = generateRandomId(5);
      GameSession gameSession = GameSession(
        id: gameSessionId,
        host: null,
        quiz: null,
        currentQuestion: 0,
        scores: null,
      );
      final sessionRef =
      _databaseReference.child('gameSessions').child(gameSessionId);
      await sessionRef.set(gameSession.toMap());
    } catch (e) {
      print('Error creating game session: $e');
    }
  }

  Future<void> addUserToSession(String sessionId, User? user) async {
    try {
      final sessionRef =
          _databaseReference.child('gameSessions').child(sessionId);
      DataSnapshot sessionSnapshot = await sessionRef.get();
      final dynamic sessionValue = sessionSnapshot.value;

      if (sessionValue != null && sessionValue is Map<dynamic, dynamic>) {
        final scores = sessionValue['scores'] as Map<dynamic, dynamic>;
        scores[user?.uid] = 0;
        await sessionRef.child('scores').set(scores);
      } else {
        print('Error: Invalid data or session does not exist');
      }
    } catch (e) {
      print('Error adding user to game session: $e');
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
