import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizish/Screens/scoboard_screen.dart';
import 'package:quizish/provider/quiz_notifier_model.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../Widgets/quiz_button.dart';
import '../models/Quiz.dart';

class CorrectAnswersScreen extends StatelessWidget {

  const CorrectAnswersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quizModel = Provider.of<QuizNotifierModel>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var answerHeight = height / 5;
    var answerWidth = width / 4;

    if (width > 1200) {
      width = width / 2;
    }

    /**
     * This method is builds a StreamBuilder that listens to the questionNumberStream
     * and builds the screen accordingly
     */
    return StreamBuilder<int?>(
      stream: quizModel.questionNumberStream(),
      builder: (context, questionNumberSnapshot) {
        return Scaffold(
          body: Column(children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quizModel.quizProgress(questionNumberSnapshot.data!),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quizModel.quizTitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w200),
                  ),
                ),
                const Spacer(),
                _timer(context, quizModel, 3, CountdownController(autoStart: true), () {

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      maintainState: false,
                      builder: (context) => Leaderboard(),
                    ),
                  );
                }),
              ],
            ),
            Flexible(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      quizModel.currentQuestion(questionNumberSnapshot.data!),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      quizModel.currentQuestionCorrectAnswers(questionNumberSnapshot.data).length > 1
                          ? 'Correct Answers'
                          : 'Correct Answer',
                    ),
                    const Divider(),
                    _correctAnswerOptionsChildren(quizModel, answerHeight, answerWidth, questionNumberSnapshot),
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        color: _correctAnswerTextColor(quizModel.isAnswerCorrect(questionNumberSnapshot.data!)),
                        child: Center(
                          child: Text(
                              quizModel.getCorrectAnswerText(questionNumberSnapshot.data!),
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'You answered ${quizModel.lastAnswerText(questionNumberSnapshot.data!)}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            /*
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: SizedBox(
                  width: width,
                  height: height / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      Text(
                        quizModel.getCorrectAnswerText(),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: _correctAnswerTextColor(quizModel.isAnswerCorrect())
                        ),
                      ),
                    ],
                  ),
                ),


            ),*/
          ]),
        );
      }
    );
  }

  /**
   * This method checks if the answer is correct and returns the appropriate color
   */
  _correctAnswerTextColor(bool? answerStatus) {
    if (answerStatus == null) {
      return Colors.red;
    } else if (answerStatus) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  /**
   * This method returns the correct answer options, when the timer is completed
   */
  _correctAnswerOptionsChildren(
      QuizNotifierModel quizModel, double answerHeight, double answerWidth, AsyncSnapshot<int?> questionNumberSnapshot) {
    if (quizModel.timerController.isCompleted!) {
      var correctAnswers = quizModel.currentQuestionCorrectAnswers(questionNumberSnapshot.data!);
      List<Widget> answers = [];

      for (Answers answer in correctAnswers) {
        answers.add(_answerButton(quizModel.getAnswerText(answer.index, questionNumberSnapshot.data!),
            answer.index, answerHeight, answerWidth, quizModel, questionNumberSnapshot));
      }
      return
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...answers],
        );
    }
  }

  /**
   * Widget that returns the answer button
   */
  Widget _answerButton(String text, int index, double height, double width,
      QuizNotifierModel quizModel, AsyncSnapshot<int?> questionNumberSnapshot) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Hero(
            tag: index,
            child: QuizButton(
              text: text,
              onPressed: () { },
              color: _getAnswerColor(index),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * This method returns the color of the answer answer container
   */
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

  /**
   * This method returns the timer widget
   */
  _timer(BuildContext context, QuizNotifierModel quizModel, int seconds, CountdownController controller, VoidCallback onFinished) {
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


}
