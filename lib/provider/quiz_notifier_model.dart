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

  /**
   * This method gets the current quiz
   */
  Future<Quiz?> getQuiz() async {
    return quiz;
  }

  /**
   * This method sets the gamesession
   */
  void setGameSession(GameSession gameSession) {
    this.gameSession = gameSession;
    quiz = gameSession.quiz;

    notifyListeners();
  }

  /**
   * This method increments the question number, and ends the quiz if it is the last question
   */
  void incrementQuestionNumber(int? questionNumber) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    if (isLastQuestion(questionNumber)) {
      endQuiz();
    } else if (gameSession?.hostId == currentUserID) {
      _gameSessionService.incrementCurrent(gameSession?.id);
    }
    notifyListeners();
  }

  /**
   * This method checks if the question has been answered, and increments the score if it is correct
   */
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

  /**
   * This method checks whether it is the last question
   */
  bool isLastQuestion(int? questionNumber) {
    return questionNumber! == quiz!.questions.length - 1;
  }

  /**
   * This method returns the current question number
   */
  String currentQuestion(int? questionNumber) {
    return quiz!.questions[questionNumber!].question;
  }

  /**
   * This method returns the current question image
   */
  String? currentQuestionImage(int? questionNumber) {
    return quiz!.questions[questionNumber!].imageUrl.toString();
  }

  /**
   * This method checks the currentQuestion for a timer value
   */
  int currentQuestionTimeLimit(int? questionNumber) {
    return quiz!.questions[questionNumber!].timer;
  }

  /**
   * This method checks whether the question current answer
   */
  Iterable<Answers> currentQuestionCorrectAnswers(int? questionNumber) {
    return quiz!.questions[questionNumber!].correctAnswers;
  }

  CountdownController get timerController => _timerController;

  String get quizTitle => quiz!.title;

  int get _quizLength => quiz!.questions.length;

  String? get imageUrl => quiz!.questions[0].imageUrl;

  /**
   * This method returns the current quiz progress
   */
  String quizProgress(int? questionNumber) {
    return '${questionNumber! + 1} / $_quizLength';
  }

  /**
   * This method returns the current answer text
   */
  String getAnswerText(int answerIndex, int? questionNumber) {
    return quiz!.questions[questionNumber!].answers[answerIndex].answer;
  }

  /**
   * This method returns the last answer text
   */
  String lastAnswerText(int? questionNumber) {
    Answers? answer = _selectedAnswers[quiz!.questions[questionNumber!]];

    if (answer == null) {
      return 'Nothing...';
    } else {
      return answer.answer;
    }
  }

  /**
   * This method is a stream, that returns the current question number
   */
  Stream<int?> questionNumberStream() {
    return _gameSessionService.getCurrentQuestion(gameSession?.id);
  }

  /**
   * This method push it to the next question
   */
  void onNextQuestion(int? questionNumber) {
    _timerController.restart();
    incrementQuestionNumber(questionNumber);
    notifyListeners();
  }

  /**
   * This method checks if the quiz is finished
   */
  bool isQuizFinished(int? questionNumber) {
    int currentQuestion = questionNumber! + 1;

    if (currentQuestion == _quizLength) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * This method ends the quiz
   */
  void endQuiz() {
    _timerController.pause();
    notifyListeners();
  }

  /**
   * This method checks if the answer is correct
   */
  bool? isAnswerCorrect(int? questionNumber) {
    if (_selectedAnswers.containsKey(quiz!.questions[questionNumber!])) {
      return _selectedAnswers[quiz!.questions[questionNumber]]?.isCorrect;
    } else {
      return null;
    }
  }

  /**
   * This method checks if the question has been answered
   */
  bool isAnswered(int? questionNumber) {
    return _selectedAnswers.containsKey(quiz!.questions[questionNumber!]);
  }

  /**
   * This method returns the current answer index
   */
  int? currentAnswerIndex(int? questionNumber) {
    return _selectedAnswers[quiz!.questions[questionNumber!]]?.index;
  }

  /**
   * This method returns the current answer text
   */
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

  /**
   * This method sets the onLeaveQuiz, and if it is the host, it deletes the session.
   * If it is a user, it leaves the session.
   */
  void onLeaveQuiz() {
    if(gameSession?.hostId == FirebaseAuth.instance.currentUser!.uid) {
      _gameSessionService.deleteSession(gameSession?.id);
    } else {
      _gameSessionService.leaveSessionAsUser(gameSession?.id);
    }
    resetQuiz();
  }

  /**
   * This method resets the quiz
   */
  Future<bool> resetQuiz() async {
    _selectedAnswers = {};
    _timerController.restart();
    quiz = null;
    notifyListeners();
    return true;
  }
}
