import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../models/Quiz.dart';

class QuizNotifierModel extends ChangeNotifier {
  Quiz quiz;
  int _questionNumber = 0;
  Map<Question, Answers> _selectedAnswers = {};
  int get questionNumber => _questionNumber;
  final CountdownController _timerController = CountdownController(autoStart: true);
  final CountdownController _nextQuestionTimerController = CountdownController(autoStart: true);
  bool _isAnswered = false;

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
    if (isAnswered()) {
      return false;
    }
    _selectedAnswers.putIfAbsent(quiz.questions[_questionNumber], () =>
    quiz.questions[_questionNumber].answers[answerIndex]);

    notifyListeners();
    return quiz.questions[_questionNumber].answers[answerIndex].isCorrect;
  }

  bool isLastQuestion() {
    return _questionNumber == quiz.questions.length - 1;
  }

  Map<Question, Answers> get selectedAnswers => _selectedAnswers;

  void reset() {
    _questionNumber = 0;
  }

  get currentQuestion => quiz.questions[_questionNumber].question;

  get currentQuestionAnswers => quiz.questions[_questionNumber].answers;

  get currentQuestionTimeLimit => quiz.questions[_questionNumber].timer;

  Iterable<Answers> get currentQuestionCorrectAnswers => quiz.questions[_questionNumber].correctAnswers;

  CountdownController get timerController => _timerController;

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

  bool? isAnswerCorrect(){
    var answer = _selectedAnswers[quiz.questions[_questionNumber]];
    if (answer != null) {
      return answer.isCorrect;
    }
    else {
      return null;
    }
  }

  bool isAnswered() {
    return _selectedAnswers.containsKey(quiz.questions[_questionNumber]);
  }


  int? get currentAnswerIndex => _selectedAnswers[quiz.questions[_questionNumber]]?.index;



  String getCorrectAnswerText() {
    bool? isCorrect = isAnswerCorrect();
    if (isCorrect == null) {
      return 'You did not answer 👎';
    } else if (isCorrect) {
      return 'Correct! 🎈';
    }
    else {
      return 'Wrong... 💀';
    }
  }

  void onLeaveQuiz() {}


}