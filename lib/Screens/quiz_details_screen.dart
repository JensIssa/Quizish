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

  @override
  Widget build(BuildContext context) {
    final GameSessionService gameSessionService = GameSessionService();
    final gameSessionProvider = Provider.of<GameSessionProvider>(context);

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
                quizId: quiz.id,
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
                gameSessionProvider.setGameSession(createdGameSession);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayersScreen(gameSession: createdGameSession),
                  ),
                );
              },
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
