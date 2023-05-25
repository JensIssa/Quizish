import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizish/Screens/correct_answers_quiz_screen.dart';
import 'package:quizish/Screens/scoboard_screen.dart';
import 'package:quizish/models/Quiz.dart';
import 'package:quizish/models/Session.dart';
import 'package:quizish/provider/quiz_notifier_model.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../widgets/quiz_button.dart';
import 'in_app_container.dart';

class QuizScreen extends StatefulWidget {
  final GameSession session;

  const QuizScreen(this.session, {Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState(session);
}

class _QuizScreenState extends State<QuizScreen> {
  GameSession session;

  _QuizScreenState(this.session);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QuizNotifierModel quizProvider =
    Provider.of<QuizNotifierModel>(context, listen: true);

    return StreamBuilder<int?>(
        stream: quizProvider.questionNumberStream(),
        builder: (context, questionNumber) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quiz'),
              automaticallyImplyLeading: false, //Remove backbutton
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => _leaveQuizDialog(() {
                    quizProvider.onLeaveQuiz();
                    Navigator.of(context).popAndPushNamed(
                        '/home'
                    );

                  }),
                )
              ],
            ),
            body: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quizProvider.quizProgress(questionNumber.data),
                        //current question / total questions
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quizProvider.quizTitle,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w200),
                      ),
                    ),
                    const Spacer(),
                    _timer(
                        context,
                        quizProvider
                            .currentQuestionTimeLimit(questionNumber.data),
                        //current question time limit needs questionNumber
                        quizProvider.timerController, () {
                      _overlayCorrectAnswer();
                    }),
                  ],
                ),
                Flexible(
                  child: Center(
                    child: Text(
                      quizProvider.currentQuestion(questionNumber.data),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                image_input(quizProvider, questionNumber),
                _answersOptionsContainer(quizProvider, questionNumber),
              ],
            ),
          );
        });
  }

    image_input(QuizNotifierModel quizProvider, AsyncSnapshot<int?> questionNumber) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var pictureHeight = height / 3;
    var pictureWidth = width / 2;

    if (height > 1200) {
      height = height / 2;
    }
    return Flexible(
      child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Image.network(
                   quizProvider.currentQuestionImage(questionNumber.data) ?? '',
                   width: pictureWidth,
                   height: pictureHeight,
                 ),
               ),
    );
   }

  _answersOptionsContainer(
      QuizNotifierModel quizProvider, AsyncSnapshot<int?> questionNumber) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var answerHeight = height / 5;
    var answerWidth = width / 4;

    if (width > 1200) {
      width = width / 2;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
      child: SizedBox(
        width: width,
        height: height / 1.5,
        child: _answerOptionsChildren(
            quizProvider, answerHeight, answerWidth, questionNumber),
      ),
    );
  }

  _answerOptionsChildren(QuizNotifierModel quizProvider, double answerHeight,
      double answerWidth, AsyncSnapshot<int?> questionNumber) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _answerButton(quizProvider.getAnswerText(0, questionNumber.data),
                  0, answerHeight, answerWidth, quizProvider, questionNumber),
              _answerButton(quizProvider.getAnswerText(1, questionNumber.data),
                  1, answerHeight, answerWidth, quizProvider, questionNumber),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _answerButton(quizProvider.getAnswerText(2, questionNumber.data),
                  2, answerHeight, answerWidth, quizProvider, questionNumber),
              _answerButton(quizProvider.getAnswerText(3, questionNumber.data),
                  3, answerHeight, answerWidth, quizProvider, questionNumber),
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
      QuizNotifierModel quizProvider, AsyncSnapshot<int?> questionNumber) {
    return Expanded(
      flex: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _answerBorderColor(index, quizProvider, questionNumber),
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
                onPressed: () =>
                    quizProvider.answerQuestion(index, questionNumber.data),
                color: _getAnswerColor(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _answerBorderColor(int index, QuizNotifierModel quizProvider,
      AsyncSnapshot<int?> questionNumber) {
    var answerIndex = quizProvider.currentAnswerIndex(questionNumber.data);

    if (answerIndex == null) {
      return Colors.transparent;
    } else if (answerIndex == index) {
      return Colors.white;
    } else {
      return Colors.transparent;
    }
  }

  _timer(BuildContext context, int seconds, CountdownController controller,
      VoidCallback onFinished) {
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
            child: const Text('Yes'
            ),
          ),
        ],
      ),
    );
  }

  _overlayCorrectAnswer() {
    //Hero animation for correct answer in pop up dialog
    //closes after two-three seconds
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            maintainState: false,
            builder: (BuildContext context) {
              return const CorrectAnswersScreen();
            }));
  }
}
