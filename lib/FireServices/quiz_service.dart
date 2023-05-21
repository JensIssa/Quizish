import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/Quiz.dart';

class UserKeys {
  static const name = 'name';
  static const email = 'email';
}

String generateId() {
  return Random().nextInt(2 ^ 53).toString();
}


class QuizService {

  List<Quiz> _quizzes = [];
  final _quizzesController = StreamController<List<Quiz>>.broadcast();


  QuizService() {
    _quizzesController.add(_quizzes);
  }

  Stream<List<Quiz>> get quizzes => _quizzesController.stream;

// Create a new quiz in Firebase
  Future<void> createQuiz(Quiz quiz) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      // Create a new document in the "quizzes" collection
      DocumentReference quizRef =
      FirebaseFirestore.instance.collection('quizzes').doc();
      // Set the data for the quiz document
      quiz.id = quizRef.id;

      await quizRef.set(quiz.toMap());
      // Update the "author" field with the current user's ID
      await quizRef.update({'author': user.uid});
      String displayName = await getUserDisplayName(user.uid);
      await quizRef.update({'authorDisplayName': displayName});
      print(quiz);
      print('Quiz created successfully by!${user.displayName!}');
    } catch (e) {
      print('Error creating quiz: $e');
    }
  }
  // Get the display name for a given user ID
  Future<String> getUserDisplayName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        String displayName = userData['displayName'] ?? '';
        return displayName;
      }
    } catch (e) {
      print('Error getting user display name: $e');
    }
    return '';
  }

  Future<List<Quiz>> getQuizzes() async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes');
    final quiz = quizRef.withConverter(fromFirestore: (snapshot, options) => Quiz.fromMap(snapshot.data()!), toFirestore: (value, options) => value.toMap());
    return quiz.get().then((value) => value.docs.map((e) => e.data()).toList());
  }

  Future<void> deleteQuiz(String quizId) async {
    final quizRef = FirebaseFirestore.instance.collection('quizzes').doc(quizId);
    await quizRef.delete();
  }

  Future<void> getIndividualQuiz(String quizId) async{
    final quizRef = FirebaseFirestore.instance.collection('quizzes').doc(quizId);
    await quizRef.get(); //Get the quiz from the database
  }
}
