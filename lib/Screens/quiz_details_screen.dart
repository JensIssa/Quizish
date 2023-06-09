import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizish/models/Quiz.dart';
import 'package:quizish/Screens/players_screen.dart';
import 'package:quizish/widgets/quiz_button.dart';
import 'package:quizish/widgets/quiz_name_box.dart';

import '../FireServices/RealTimeExample.dart';
import '../models/Session.dart';
import 'GameSessionProvider.dart';

class QuizDetailsScreen extends StatelessWidget {
  final Quiz quiz;

  const QuizDetailsScreen({Key? key, required this.quiz}) : super(key: key);

  /**
   * This is the screen that shows the details of a quiz.
   */
  @override
  Widget build(BuildContext context) {
    final GameSessionService gameSessionService = GameSessionService();
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 250,
              child: QuizNameBox(
                quizTitle: quiz.title,
                quizAuthor: quiz.authorDisplayName,
                questions: quiz.questions.length.toString(),
              ),
            ),
          ),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            child: Text(
              quiz.description, // Use the description from the Quiz object
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Container(
            height: 130,
            width: 150,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 70),
            child: QuizButton(
              text: 'Start',
              onPressed: () async {
                GameSession? createdGameSession =
                await gameSessionService.createGameSession(quiz);
                if (createdGameSession != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayersScreen(gameSession: createdGameSession),
                    ),
                  );
                } else {
                  // Handle the case when the game session is null
                  print('Error: Game session is null');
                }
              },
              color: Colors.green,
            ),
          ),
          Container(
            height: 130,
            width: 150,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 70),
            child: QuizButton(
              text: 'Back',
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
