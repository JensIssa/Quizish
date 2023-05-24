import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizish/models/Session.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../FireServices/RealTimeExample.dart';
import '../models/Quiz.dart';

class QuizNotifierModel extends ChangeNotifier {
  Quiz? quiz;

  Map<Question, Answers> _selectedAnswers = {};
  final CountdownController _timerController =
      CountdownController(autoStart: true);
  final GameSessionService _gameSessionService = GameSessionService();
  GameSession? gameSession;

  QuizNotifierModel.notifier(this.quiz);

  QuizNotifierModel() {
    quiz = null;

  }

  Future<Quiz?> getQuiz() async {
    return quiz;
  }

  void setGameSession(GameSession gameSession) {
    this.gameSession = gameSession;
    quiz = gameSession.quiz;

    notifyListeners();
  }

  void incrementQuestionNumber(int? questionNumber) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    if (isLastQuestion(questionNumber)) {
      endQuiz();
    } else if (gameSession?.hostId == currentUserID) {
      _gameSessionService.incrementCurrent(gameSession?.id);
    }

    notifyListeners();
  }

  void answerQuestion(int answerIndex, int? questionNumber) {
    if (isAnswered(questionNumber)) {
      return;
    }
    Answers userAnswer = _selectedAnswers.putIfAbsent(
      quiz!.questions[questionNumber!],
      () => quiz!.questions[questionNumber].answers[answerIndex],
    );

    if (userAnswer.isCorrect) {
      _gameSessionService.incrementScore(gameSession?.id, FirebaseAuth.instance.currentUser!.uid);
    }

    notifyListeners();
  }

  bool isLastQuestion(int? questionNumber) {
    return questionNumber! == quiz!.questions.length - 1;
  }

  String currentQuestion(int? questionNumber) {
    return quiz!.questions[questionNumber!].question;
  }

  int currentQuestionTimeLimit(int? questionNumber) {
    return quiz!.questions[questionNumber!].timer;
  }

  Iterable<Answers> currentQuestionCorrectAnswers(int? questionNumber) {
    return quiz!.questions[questionNumber!].correctAnswers;
  }

  CountdownController get timerController => _timerController;

  String get quizTitle => quiz!.title;

  int get _quizLength => quiz!.questions.length;

  String quizProgress(int? questionNumber) {
    return '${questionNumber! + 1} / $_quizLength';
  }

  String getAnswerText(int answerIndex, int? questionNumber) {
    return quiz!.questions[questionNumber!].answers[answerIndex].answer;
  }

  String lastAnswerText(int? questionNumber) {
    Answers? answer = _selectedAnswers[quiz!.questions[questionNumber!]];

    if (answer == null) {
      return 'Nothing...';
    } else {
      return answer.answer;
    }
  }

  Stream<int?> questionNumberStream() {
    return _gameSessionService.getCurrentQuestion(gameSession?.id);
  }

  void onNextQuestion(int? questionNumber) {
    _timerController.restart();
    incrementQuestionNumber(questionNumber);
    notifyListeners();
  }

  bool isQuizFinished(int? questionNumber) {
    int currentQuestion = questionNumber! + 1;

    if (currentQuestion == _quizLength) {
      return true;
    } else {
      return false;
    }
  }

  void endQuiz() {
    _timerController.pause();
    notifyListeners();
  }

  bool? isAnswerCorrect(int? questionNumber) {
    if (_selectedAnswers.containsKey(quiz!.questions[questionNumber!])) {
      return _selectedAnswers[quiz!.questions[questionNumber]]?.isCorrect;
    } else {
      return null;
    }
  }

  bool isAnswered(int? questionNumber) {
    return _selectedAnswers.containsKey(quiz!.questions[questionNumber!]);
  }

  int? currentAnswerIndex(int? questionNumber) {
    return _selectedAnswers[quiz!.questions[questionNumber!]]?.index;
  }

  String getCorrectAnswerText(int? questionNumber) {
    bool? isCorrect = isAnswerCorrect(questionNumber);
    if (isCorrect == null) {
      return 'You did not answer 👎';
    } else if (isCorrect) {
      return 'Correct! 🎈';
    } else {
      return 'Wrong... 💀';
    }
  }

  void onLeaveQuiz() {
    _gameSessionService.leaveSessionAsUser(gameSession?.id);
    resetQuiz();
  }

  Future<bool> resetQuiz() async {
    _selectedAnswers = {};
    _timerController.restart();
    quiz = null;
    notifyListeners();
    return true;
  }
}
