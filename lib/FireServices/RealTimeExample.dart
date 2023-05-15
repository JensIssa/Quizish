import 'dart:html';
import 'dart:math';

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

  Future<void> createGameSession(GameSession gameSession) async {
    try {
      String gamesessionId = generateRandomId(5);
      final sessionRef = _databaseReference.child('gameSessions').child(gamesessionId);
      await sessionRef.set(gameSession.toMap());
    } catch (e) {
      print('Error creating game session: $e');
    }
  }

  Stream<DatabaseEvent> listenForChanges(String sessionId) {
    final sessionRef = _databaseReference.child('gameSessions').child(sessionId);
    return sessionRef.onValue;
  }

  Future<void> addUserToSession(String sessionId, User user) async {
    try {
      final sessionRef = _databaseReference.child('gameSessions').child(sessionId);

      DataSnapshot sessionSnapshot = await sessionRef.get();
      if (sessionSnapshot.value != null) {
        final data = sessionSnapshot.value as Map<dynamic, dynamic>;
        final scores = data['scores'] as Map<dynamic, dynamic>;

        // Add the user to the scores map with an initial score of 0
        scores[user.uid] = 0;

        // Update the scores field in the database
        await sessionRef.child('scores').set(scores);
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

        // Remove the user from the scores map
        scores.remove(user.uid);

        // Update the scores field in the database
        await sessionRef.child('scores').set(scores);
      }
    } catch (e) {
      print('Error removing user from game session: $e');
    }
  }

// Other methods...
}
