import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizish/Screens/correct_answers_quiz_screen.dart';
import 'package:quizish/Screens/scoboard_screen.dart';
import 'package:quizish/models/Quiz.dart';
import 'package:quizish/provider/quiz_notifier_model.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../widgets/quiz_button.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen(this.quiz, {Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState(quiz);
}

class _QuizScreenState extends State<QuizScreen> {
  Quiz quiz;

  _QuizScreenState(this.quiz);

  @override
  void initState() {
    super.initState();

    quiz = Quiz.noAuthor(
        title: "quiz title",
        id: "-1",
        description: "description",
        questions: [
          Question.noImg(index: 0, question: "question", timer: 20, answers: [
            Answers(answer: "answer q0 1", isCorrect: true, index: 0),
            Answers(answer: "answer q0 2", isCorrect: false, index: 1),
            Answers(answer: "answer q0 3", isCorrect: false, index: 2),
            Answers(answer: "answer q0 4", isCorrect: false, index: 3),
          ]),
          Question.noImg(
              index: 1,
              question: "question 1",
              answers: [
                Answers(answer: "answer q1 1", isCorrect: false, index: 0),
                Answers(answer: "answer q1 2", isCorrect: true, index: 1),
                Answers(answer: "answer q1 3", isCorrect: false, index: 2),
                Answers(answer: "answer q1 4", isCorrect: false, index: 3),
              ],
              timer: 10),
          Question.noImg(
              index: 2,
              question: "question 2",
              answers: [
                Answers(answer: "answer q2 1", isCorrect: false, index: 0),
                Answers(answer: "answer q2 2", isCorrect: false, index: 1),
                Answers(answer: "answer q2 3", isCorrect: true, index: 2),
                Answers(answer: "answer q2 4", isCorrect: false, index: 3),
              ],
              timer: 10),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    QuizNotifierModel quizProvider = Provider.of<QuizNotifierModel>(context, listen: true);
    quizProvider.setQuiz(quiz);

    return StreamBuilder<Quiz>(
      stream: quizProvider.quizStream,
      builder: (context, quizSnapshot) {
        return Scaffold(
                appBar: AppBar(
                  title: const Text('Quiz'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () => _leaveQuizDialog(
                          () {
                            quizProvider.onLeaveQuiz();
                            Navigator.of(context).pop();
                          }
                      ),
                    )
                  ],
                ),
                body: Column(children: [
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          quizProvider.quizProgress, //current question / total questions
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w200),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          quizSnapshot.data!.title,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w200),
                        ),
                      ),
                      const Spacer(),
                      _timer(
                          context,
                          quizProvider.currentQuestionTimeLimit,
                          quizProvider.timerController,
                              (){ _overlayCorrectAnswer(); }
                      ),
                    ],
                  ),
                  Flexible(
                    child: Center(
                      child: Text(
                        quizProvider.currentQuestion,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  _answersOptionsContainer(quizProvider),
                ],
          ),
        );
      }
    );
  }

  _answersOptionsContainer(QuizNotifierModel quizProvider) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var answerHeight = height / 5;
    var answerWidth = width / 4;

    if (width > 1200) {
      width = width / 2;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
      child: Positioned(
        bottom: 10,
        height: height / 1.5,
        child: SizedBox(
          width: width,
          height: height / 1.5,
          child: _answerOptionsChildren(quizProvider, answerHeight, answerWidth),
          ),
        ),
    );
  }

  _answerOptionsChildren(
      QuizNotifierModel quizProvider, double answerHeight, double answerWidth) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _answerButton(quizProvider.getAnswerText(0), 0, answerHeight,
                answerWidth, quizProvider),
            _answerButton(quizProvider.getAnswerText(1), 1, answerHeight,
                answerWidth, quizProvider),
          ],
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _answerButton(quizProvider.getAnswerText(2), 2, answerHeight,
              answerWidth, quizProvider),
          _answerButton(quizProvider.getAnswerText(3), 3, answerHeight,
              answerWidth, quizProvider),
        ],
      ),
    ]);
  }

  _getAnswerColor(int index) {
      switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _answerButton(String text, int index, double height, double width,
      QuizNotifierModel quizProvider) {
    return Expanded(
      flex: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _answerBorderColor(index, quizProvider),
            style: BorderStyle.solid,
            width: 5,
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Hero(
                tag: index,
                child: QuizButton(
                  text: text,
                  onPressed: () => quizProvider.answerQuestion(index),
                  color: _getAnswerColor(index),
                ),
              ),
            ),
          ),
      ),

    );
  }


  _answerBorderColor(int index, QuizNotifierModel quizProvider) {
    var answerIndex = quizProvider.currentAnswerIndex;

    if (answerIndex == null) {
      return Colors.transparent;
    }
    else if (answerIndex == index) {
      return Colors.white;
    }
    else {
      return Colors.transparent;
    }
  }

  _timer(BuildContext context, int seconds, CountdownController controller, VoidCallback onFinished) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              width: 2,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            color: Colors.transparent,
          ),
          child: Center(
            child: Countdown(
              seconds: seconds,
              build: (BuildContext context, double time) => Text(
                time.toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black54),
              ),
              interval: const Duration(milliseconds: 1000),
              controller: controller,
              onFinished: onFinished,
            ),
          ),
        ),
      ),
    );
  }

  _leaveQuizDialog(VoidCallback onLeaveQuiz) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Quiz'),
        content: const Text('Are you sure you want to leave the quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: onLeaveQuiz,
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }


  _overlayCorrectAnswer() {
    //Hero animation for correct answer in pop up dialog
    //closes after two-three seconds
    Navigator.push(context, MaterialPageRoute(
        fullscreenDialog: true,
        maintainState: false,
        builder: (BuildContext context) {
          return const CorrectAnswersScreen();
        }
    ));
  }





}
