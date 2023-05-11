import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:quizish/models/Quiz.dart';

import '../widgets/quiz_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final int _duration = 10;
  final CountDownController _countDownController = CountDownController();
  int currentQuestion = 0;
  late Quiz quiz;

  @override
  void initState() {
    super.initState();

    quiz = Quiz.noAuthor(
        title: "quiz title",
        id: "-1",
        description: "description",
        questions: [
          Question(question: "question", imgUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Paris_-_Eiffelturm_und_Marsfeld2.jpg/1200px-Paris_-_Eiffelturm_und_Marsfeld2.jpg',
              answers: [
            Answers(answer: "answer 1", isCorrect: true),
            Answers(answer: "answer", isCorrect: false),
            Answers(answer: "answer", isCorrect: false),
            Answers(answer: "answer", isCorrect: false),
          ]),
          Question(question: "question", answers: [
            Answers(answer: "answer", isCorrect: false),
            Answers(answer: "answer 2", isCorrect: true),
            Answers(answer: "answer", isCorrect: false),
            Answers(answer: "answer", isCorrect: false),
          ]),
          Question(question: "question", answers: [
            Answers(answer: "answer", isCorrect: false),
            Answers(answer: "answer", isCorrect: false),
            Answers(answer: "answer 3", isCorrect: true),
            Answers(answer: "answer", isCorrect: false),
          ]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {},
            )
          ],
        ),
        body: Column(children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Text(
                '${currentQuestion + 1}/${quiz.questions.length}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
              ),
              const Spacer(),
              _timer(),
            ],
          ),
          Text(
            quiz.questions[currentQuestion].question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          _imageContainer(),
          Positioned(
            bottom: 0,
            child: _buttonGrid(),
          ),
        ]));
  }

  Widget _imageContainer() {
    if (quiz.questions[currentQuestion].imgUrl == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6,
      );
    }
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        child: Image(
          image: NetworkImage(
              quiz.questions[currentQuestion].imgUrl.toString()),
        ));
  }

  _buttonGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          Expanded(
              child: Padding(
              padding: const EdgeInsets.all(5),
              child: QuizButton(
              text: quiz.questions[currentQuestion].answers[0].answer,
              onPressed: () {
                _countDownController.pause();
              },
              color: Colors.green,
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: QuizButton(
              text: quiz.questions[currentQuestion].answers[1].answer,
              onPressed: () {
                _countDownController.pause();
              },
              color: Colors.red,
            ),
          )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: QuizButton(
                text: quiz.questions[currentQuestion].answers[2].answer,
                onPressed: () {
                  _countDownController.start();
                },
                color: Colors.orange,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: QuizButton(
              text: quiz.questions[currentQuestion].answers[3].answer,
              onPressed: () {
                _countDownController.pause();
              },
              color: Colors.blueAccent,
            ),
          )),
        ],
      ),
    );
  }

  _timer() {
    return CircularCountDownTimer(
      // Countdown duration in Seconds.
      duration: _duration,

      // Countdown initial elapsed Duration in Seconds.
      initialDuration: 10,

      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
      controller: _countDownController,

      // Width of the Countdown Widget.
      width: 30,

      // Height of the Countdown Widget.
      height: 30,

      // Ring Color for Countdown Widget.
      ringColor: Colors.grey[300]!,

      // Ring Gradient for Countdown Widget.
      ringGradient: null,

      // Filling Color for Countdown Widget.
      fillColor: Colors.transparent,

      // Filling Gradient for Countdown Widget.
      fillGradient: null,

      // Background Color for Countdown Widget.
      backgroundColor: Colors.transparent,

      // Background Gradient for Countdown Widget.
      backgroundGradient: null,

      // Border Thickness of the Countdown Ring.
      strokeWidth: 2.0,

      // Begin and end contours with a flat edge and no extension.
      strokeCap: StrokeCap.round,

      // Text Style for Countdown Text.
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      // Format for the Countdown Text.
      textFormat: CountdownTextFormat.S,

      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
      isReverse: false,

      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
      isReverseAnimation: false,

      // Handles visibility of the Countdown Text.
      isTimerTextShown: true,

      // Handles the timer start.
      autoStart: false,

      // This Callback will execute when the Countdown Starts.
      onStart: () {
        // Here, do whatever you want
        debugPrint('Countdown Started');
      },

      // This Callback will execute when the Countdown Ends.
      onComplete: () {
        // Here, do whatever you want
        debugPrint('Countdown Ended');
      },

      // This Callback will execute when the Countdown Changes.
      onChange: (String timeStamp) {
        // Here, do whatever you want
        debugPrint('Countdown Changed $timeStamp');
      },

      /*
            * Function to format the text.
            * Allows you to format the current duration to any String.
            * It also provides the default function in case you want to format specific moments
              as in reverse when reaching '0' show 'GO', and for the rest of the instances follow
              the default behavior.
          */
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (duration.inSeconds == 0) {
          // only format for '0'
          return "Start";
        } else {
          // other durations by it's default format
          return Function.apply(defaultFormatterFunction, [duration]);
        }
      },
    );
  }
}
