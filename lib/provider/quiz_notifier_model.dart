import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../models/Quiz.dart';

class QuizNotifierModel extends ChangeNotifier {
  Quiz quiz;
  int _questionNumber = 0;
  List<Answers> _selectedAnswers = [];
  int get questionNumber => _questionNumber;
  final CountdownController _timerController = CountdownController(autoStart: true);
  final CountdownController _nextQuestionTimerController = CountdownController(autoStart: true);

  QuizNotifierModel.notifier(this.quiz);


  get nextQuestionTimerController => _nextQuestionTimerController;

  void incrementQuestionNumber() {
    if(isLastQuestion()) {
      endQuiz();
    } else {
      _questionNumber++;
    }
    notifyListeners();
  }

  bool answerQuestion(int answerIndex) {
    _selectedAnswers.add(quiz.questions[_questionNumber].answers[answerIndex]);
    incrementQuestionNumber();
    notifyListeners();
    return quiz.questions[_questionNumber].answers[answerIndex].isCorrect;
  }

  bool isLastQuestion() {
    return _questionNumber == quiz.questions.length - 1;
  }

  List<Answers> get selectedAnswers => _selectedAnswers;

  void reset() {
    _questionNumber = 0;
  }

  get currentQuestion => quiz.questions[_questionNumber].question;

  get currentQuestionAnswers => quiz.questions[_questionNumber].answers;

  get currentQuestionTimeLimit => quiz.questions[_questionNumber].timer;

  get timerController => _timerController;

  get quizTitle => quiz.title;

  get _quizLength => quiz.questions.length;

  get quizProgress => '${_questionNumber+1} / $_quizLength';

  String getAnswerText(int i) {
    return quiz.questions[_questionNumber].answers[i].answer;
  }

  onTimerFinished() {
    _timerController.restart();
    incrementQuestionNumber();
    notifyListeners();
  }

  endQuiz() {
    _timerController.pause();
    notifyListeners();
  }

  void onLeaveQuiz() {}


}