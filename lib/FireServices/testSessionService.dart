// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/Session.dart';
// import '../models/Quiz.dart';
// import '../models/User.dart';
//
// class GameTest {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> addUserToSession(String sessionId, User user) async {
//     try {
//       final sessionRef = _firestore.collection('gameSessions').doc(sessionId);
//       final sessionDoc = await sessionRef.get();
//       if (sessionDoc.exists) {
//         final data = sessionDoc.data() as Map<String, dynamic>;
//         final scores = data['scores'] as Map<dynamic, dynamic>;
//         // Add the user to the scores map with an initial score of 0
//         scores[user] = 0;
//         // Update the scores field in the document
//         await sessionRef.update({'scores': scores});
//       }
//     } catch (e) {
//       print('Error adding user to game session: $e');
//     }
//   }
//
//   Future<void> createGameSession(GameSession gameSession) async {
//     try {
//       final sessionRef = _firestore.collection('gameSessions').doc(gameSession.id);
//       await sessionRef.set(gameSession.toMap());
//     } catch (e) {
//       print('Error creating game session: $e');
//     }
//   }
//
//   Future<void> removeUserFromSession(String sessionId, User user) async {
//     try {
//       final sessionRef = _firestore.collection('gameSessions').doc(sessionId);
//
//       final sessionDoc = await sessionRef.get();
//       if (sessionDoc.exists) {
//         final data = sessionDoc.data() as Map<String, dynamic>;
//         final scores = data['scores'] as Map<dynamic, dynamic>;
//
//         // Remove the user from the scores map
//         scores.remove(user);
//
//         // Update the scores field in the document
//         await sessionRef.update({'scores': scores});
//       }
//     } catch (e) {
//       print('Error removing user from game session: $e');
//     }
//   }
//
//   Future<GameSession?> getGameSession(String sessionId) async {
//     try {
//       final sessionRef = _firestore.collection('gameSessions').doc(sessionId);
//
//       final sessionDoc = await sessionRef.get();
//       if (sessionDoc.exists) {
//         final data = sessionDoc.data() as Map<String, dynamic>;
//
//         // Create a GameSession object using the retrieved data
//         final gameSession = GameSession.fromMap(sessionId, data);
//         return gameSession;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error retrieving game session: $e');
//       return null;
//     }
//   }
// }
