import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../models/Quiz.dart';

class QuizNotifierModel extends ChangeNotifier {
  Quiz? quiz;
  int _questionNumber = 0;
  Map<Question, Answers> _selectedAnswers = {};
  final CountdownController _timerController = CountdownController(autoStart: true);
  final StreamController<int> _questionNumberController = StreamController<int>.broadcast();
  final StreamController<Quiz> _quizController = StreamController<Quiz>.broadcast();

  QuizNotifierModel.notifier(this.quiz);

  QuizNotifierModel() {
    quiz = null;
  }

  Future<int> questionNumber() async {
    return _questionNumber;
  }

  Future<Quiz?> getQuiz() async {
    return quiz;
  }

  void setQuiz(Quiz? quiz) {
    if (quiz == null) {
      return;
    }
    this.quiz = quiz;
    _quizController.add(quiz);
  }

  void incrementQuestionNumber() {
    if (isLastQuestion()) {
      endQuiz();
    } else {
      _questionNumber++;
    }
    _questionNumberController.add(_questionNumber);
    notifyListeners();
  }

  void answerQuestion(int answerIndex) {
    if (isAnswered()) {
      return;
    }

    _selectedAnswers.putIfAbsent(
      quiz!.questions[_questionNumber],
          () => quiz!.questions[_questionNumber].answers[answerIndex],
    );

    notifyListeners();
  }

  bool isLastQuestion() {
    return _questionNumber == quiz!.questions.length - 1;
  }


  get currentQuestion => quiz!.questions[_questionNumber].question;


  get currentQuestionTimeLimit => quiz!.questions[_questionNumber].timer;

  Iterable<Answers> get currentQuestionCorrectAnswers => quiz!.questions[_questionNumber].correctAnswers;

  CountdownController get timerController => _timerController;

  String get quizTitle => quiz!.title;

  int get _quizLength => quiz!.questions.length;

  String get quizProgress => '${_questionNumber+1} / $_quizLength';

  String getAnswerText(int i) {
    return quiz!.questions[_questionNumber].answers[i].answer;
  }

  String lastAnswerText() {
    Answers? answer = _selectedAnswers[quiz!.questions[_questionNumber]];

    if (answer == null) {
      return 'Nothing...';
    } else {
      return answer.answer;
    }
  }

  Stream<int> get questionNumberStream => _questionNumberController.stream;

  Stream<Quiz> get quizStream => _quizController.stream;

  void onNextQuestion() {
    _timerController.restart();
    incrementQuestionNumber();
    notifyListeners();
  }

  bool get isQuizFinished => _questionNumber == _quizLength;

  void endQuiz() {
    _timerController.pause();
    notifyListeners();
  }

  bool? isAnswerCorrect() {
    if (_selectedAnswers.containsKey(quiz!.questions[_questionNumber])) {
      return _selectedAnswers[quiz!.questions[_questionNumber]]?.isCorrect;
    } else {
      return null;
    }
  }

  bool isAnswered() {
    return _selectedAnswers.containsKey(quiz!.questions[_questionNumber]);
  }

  int? get currentAnswerIndex => _selectedAnswers[quiz!.questions[_questionNumber]]?.index;

  String getCorrectAnswerText() {
    bool? isCorrect = isAnswerCorrect();
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
    _questionNumber = 0;
    _selectedAnswers = {};
    _timerController.restart();
    quiz = null;
    notifyListeners();
    return true;
  }

}


