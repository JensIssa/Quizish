import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../provider/quiz_notifier_model.dart';

class LeaderboardData {
  final String name;
  final int score;

  LeaderboardData(this.name, this.score);
}

final leaderboardData = [
  LeaderboardData('Rasmus', 1000),
  LeaderboardData('Jens', 900),
  LeaderboardData('Jakob', 800),
  LeaderboardData('Andreas', 700),
  LeaderboardData('Andy', 600),
  LeaderboardData('Mathias', 500),
  LeaderboardData('Søren', 400),
  LeaderboardData('Henrik', 300),
  LeaderboardData('Jeppe', 200),
  LeaderboardData('Alex', 100),
];

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quizModel = Provider.of<QuizNotifierModel>(context, listen: true);

    return StreamBuilder<int?>(
        stream: quizModel.questionNumberStream(),
        builder: (context, questionNumberSnapshot) {
          return Scaffold(
            appBar: appBars(context, questionNumberSnapshot, quizModel),
            body: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white,
                thickness: 3.0,
                height: 5,
              ),
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final data = leaderboardData[index];
                return ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  title: Text(data.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('${data.score}',
                      style: const TextStyle(fontSize: 20.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  tileColor: index == 0
                      ? _tileColor(context, 0.9)
                      : index == 1
                          ? _tileColor(context, 0.6)
                          : index == 2
                              ? _tileColor(context, 0.3)
                              : index % 2 == 0
                                  ? _tileColor(context, 0)
                                  : _tileColor(context, 0),
                );
              },
            ),
          );
        });
  }

  _tileColor(BuildContext context, double opacity) {
    return Theme.of(context).colorScheme.secondary.withOpacity(opacity);
  }

  AppBar appBars(BuildContext context, AsyncSnapshot<int?> questionNumber,
      QuizNotifierModel quizModel) {
    var appBarActiveGame = AppBar(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text('Next question in:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white)),
          const SizedBox(width: 10.0),
          _timer(context, quizModel, 3, CountdownController(autoStart: true),
              () {
            bool isQuizFinished = quizModel.isQuizFinished(questionNumber.data);

            quizModel.onNextQuestion(questionNumber.data);
            Navigator.pop(context);
          })
        ],
      ),
    );

    var appBarEndGame = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      title: Row(
        children: [
          Text(
            'Final scores',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {
              context.read<QuizNotifierModel>().onLeaveQuiz();
              Navigator.of(context).popAndPushNamed(
                  '/home'
              );
            },
            icon: Icon(Icons.exit_to_app,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white))
      ],
    );

    return quizModel.isQuizFinished(questionNumber.data)
        ? appBarEndGame
        : appBarActiveGame;
  }

  _timer(BuildContext context, QuizNotifierModel quizModel, int seconds,
      CountdownController controller, VoidCallback onFinished) {
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
