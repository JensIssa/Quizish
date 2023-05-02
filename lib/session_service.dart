import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/Session.dart';

class SessionService {
  GameSession? _currentSession;
  final _currentSessionController = StreamController<GameSession>.broadcast();

  SessionService() {
    _currentSessionController.add(_currentSession!);
  }

  Stream<GameSession> get currentSession => _currentSessionController.stream;

  Future<void> createSession(GameSession session) async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc();
    session.id = sessionRef.id;
    await sessionRef.set(session.toMap());
  }

  Future<void> joinSession(String sessionId) async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc(sessionId);
    final session = await sessionRef.get();
    _currentSession = GameSession.fromMap(session.id, session.data()!);
    _currentSessionController.add(_currentSession!);
  }

  Future<void> leaveSession() async {
    _currentSession = null;
    _currentSessionController.add(_currentSession!);
  }

  Future<void> startSession() async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc(_currentSession!.id);
    await sessionRef.update({'currentQuestion': 0});
  }

  Future<void> nextQuestion() async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc(_currentSession!.id);
    await sessionRef.update({'currentQuestion': _currentSession!.currentQuestion + 1});
  }

  Future<void> endSession() async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc(_currentSession!.id);
    await sessionRef.update({'currentQuestion': _currentSession!.quiz.questions.length});
  }

  Future<void> answerQuestion(int answer) async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc(_currentSession!.id);
    final session = await sessionRef.get();
    final currentSession = GameSession.fromMap(session.id, session.data()!);
    final currentQuestion = currentSession.quiz.questions[currentSession.currentQuestion];
    final correctAnswer = currentQuestion.correctAnswer;
    if (answer == correctAnswer) {
      final scores = currentSession.scores;
      scores[currentSession.host] = scores[currentSession.host]! + 1;
      await sessionRef.update({'scores': scores});
    }
  }

  Future<void> removePlayer(User user) async {
    final sessionRef = FirebaseFirestore.instance.collection('sessions').doc(_currentSession!.id);
    final session = await sessionRef.get();
    final currentSession = GameSession.fromMap(session.id, session.data()!);
    final players = currentSession.players;
    players.remove(user);
    await sessionRef.update({'players': players});
  }





}