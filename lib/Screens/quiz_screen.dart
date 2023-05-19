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
    return ChangeNotifierProvider(
      create: (_) => QuizNotifierModel.notifier(quiz),
      child: Consumer<QuizNotifierModel>(
        builder: (context, quizModel, child) => Scaffold(
            appBar: AppBar(
              title: const Text('Quiz'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => _leaveQuizDialog(quizModel),
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
                      quizModel.quizProgress,
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
                  _timer(
                      context,
                      quizModel,
                      quizModel.currentQuestionTimeLimit,
                      quizModel.timerController,
                          (){
                        _overlayCorrectAnswer(quizModel);
                        quizModel.onTimerFinished();

                  }),
                ],
              ),
              Flexible(
                child: Center(
                  child: Text(
                    quizModel.currentQuestion,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              _answersOptionsContainer(quizModel),
            ])),
      ),
    );
  }

  _answersOptionsContainer(QuizNotifierModel quizModel) {
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
          child: _answerOptionsChildren(quizModel, answerHeight, answerWidth),
          ),
        ),
    );
  }

  _answerOptionsChildren(
      QuizNotifierModel quizModel, double answerHeight, double answerWidth) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _answerButton(quizModel.getAnswerText(0), 0, answerHeight,
                answerWidth, quizModel),
            _answerButton(quizModel.getAnswerText(1), 1, answerHeight,
                answerWidth, quizModel),
          ],
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _answerButton(quizModel.getAnswerText(2), 2, answerHeight,
              answerWidth, quizModel),
          _answerButton(quizModel.getAnswerText(3), 3, answerHeight,
              answerWidth, quizModel),
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
      QuizNotifierModel quizModel) {
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
              onPressed: () => quizModel.answerQuestion(index),
              color: _getAnswerColor(index),
            ),
          ),
        ),
      ),
    );
  }

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

  _leaveQuizDialog(QuizNotifierModel quizModel) {
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
            onPressed: () {
              quizModel.onLeaveQuiz();
              Navigator.of(context).pop(); //Navigate to home
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  _correctAnswerOptionsChildren(
      QuizNotifierModel quizModel, double answerHeight, double answerWidth) {
    if (quizModel.timerController.isCompleted!) {
      var correctAnswers = quizModel.currentQuestionCorrectAnswers;
      List<Widget> answers = [];

      for (Answers answer in correctAnswers) {
        answers.add(_answerButton(quizModel.getAnswerText(answer.index),
            answer.index, answerHeight, answerWidth, quizModel));
      }
      return
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...answers],
        );

    }
  }

  _overlayCorrectAnswer(QuizNotifierModel quizModel) {
    //Hero animation for correct answer in pop up dialog
    //closes after two-three seconds
    Navigator.push(context, MaterialPageRoute(
        fullscreenDialog: true,
        maintainState: false,
        builder: (BuildContext context) {
          return CorrectAnswersScreen(quizModel: quizModel);
        }
    ));
  }



  _overlayScoreboard() {
    //Show scoreboard as overlay
    //closes after two-three seconds
    final overlay = Overlay.of(context);
    overlay.insert(
      OverlayEntry(
        builder: (context) => const Center(
          child: Leaderboard(),
        ),
      ),
    );
  }

  _nextQuestionCountDown(QuizNotifierModel quizModel) {
    //Fill page with overlay and count down to three
    final overlayEntry = _buildNextQuestionCountdown(() {}, quizModel);
    final overlayState = Overlay.of(context);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => overlayState.insert(overlayEntry));

    overlayEntry.remove();
  }

  OverlayEntry _buildNextQuestionCountdown(
      VoidCallback onFinished, QuizNotifierModel quizModel) {
    return OverlayEntry(
      builder: (context) => Center(
        child: Container(
            color: Theme.of(context).primaryColor,
            child: Countdown(
              controller: quizModel.nextQuestionTimerController,
              seconds: 3,
              build: (BuildContext context, double time) => Text(
                time.toString(),
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black54),
              ),
              interval: const Duration(milliseconds: 1000),
              onFinished: () => {
                //Close overlay
              },
            )),
      ),
    );
  }
}
