import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../models/Quiz.dart';

class QuizNotifierModel extends ChangeNotifier {
  Quiz? quiz;

  Map<Question, Answers> _selectedAnswers = {};
  final CountdownController _timerController =
      CountdownController(autoStart: true);
  final StreamController<int> _questionNumberController =
      StreamController<int>.broadcast();


  QuizNotifierModel.notifier(this.quiz);

  QuizNotifierModel() {
    quiz = null;
    _questionNumberController.add(0);
  }

  Future<Quiz?> getQuiz() async {
    return quiz;
  }

  void setQuiz(Quiz? quiz) {
    if (quiz == null) {
      return;
    }
    this.quiz = quiz;
    notifyListeners();
  }

  //TODO: implement this
  void incrementQuestionNumber(int? questionNumber) {
    if (isLastQuestion(questionNumber)) {
      endQuiz();
    } else {
      //_questionNumber++;
      _questionNumberController.sink.add(questionNumber! + 1);
    }

    notifyListeners();
  }

  void answerQuestion(int answerIndex, int? questionNumber) {
    if (isAnswered(questionNumber)) {
      return;
    }

    _selectedAnswers.putIfAbsent(
      quiz!.questions[questionNumber!],
      () => quiz!.questions[questionNumber!].answers[answerIndex],
    );

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

  Stream<int> get questionNumberStream => _questionNumberController.stream;

  void onNextQuestion(int? questionNumber) {
    _timerController.restart();
    incrementQuestionNumber(questionNumber);
    notifyListeners();
  }

  bool isQuizFinished(int? questionNumber) {
    return questionNumber == _quizLength;
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

  void onLeaveQuiz() {}

  Future<bool> resetQuiz() async {
    _selectedAnswers = {};
    _timerController.restart();
    quiz = null;
    notifyListeners();
    return true;
  }
}
