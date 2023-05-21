import 'package:flutter/material.dart';
import 'package:quizish/FireServices/RealTimeExample.dart';
import 'package:quizish/Screens/players_screen.dart';
import 'package:quizish/models/Session.dart';
import 'package:quizish/widgets/quiz_button.dart';
import 'package:quizish/widgets/quiz_name_box.dart';

import '../models/Quiz.dart';


class QuizDetailsScreen extends StatelessWidget {

  const QuizDetailsScreen({Key? key, required this.quiz}) : super(key: key);

  final Quiz quiz;
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
                GameSession? createdGameSession = await gameSessionService.createGameSession(quiz);
                if (createdGameSession != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayersScreen(gameSession: createdGameSession),
                    ),
                  );
                }
              },
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }


}
