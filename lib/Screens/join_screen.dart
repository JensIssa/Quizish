import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/Screens/players_screen.dart';
import 'package:quizish/widgets/quiz_button.dart';
import '../FireServices/RealTimeExample.dart';
import '../models/Session.dart';
import 'GameSessionProvider.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionController = TextEditingController();
    final GameSessionService gameSessionService = GameSessionService();
    final AuthService authService = AuthService();

    return Column(
      children: [
        const SizedBox(height: 40),
        const Center(
          child: Text(
            'Join Session',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: SessionInput(sessionController),
        ),
        const SizedBox(height: 400),
        Center(
          child: Container(
            width: 200,
            height: 50,
            child: QuizButton(
              text: 'Join',
              onPressed: () async {
                await gameSessionService.addUserToSession(
                  sessionController.text,
                  authService.getCurrentFirebaseUser(),
                );
                GameSession? gameSession =
                    await gameSessionService.getGameSessionByCode(
                  sessionController.text,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlayersScreen(
                      gameSession: gameSession,
                    ),
                  ),
                );
              },
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  TextField SessionInput(TextEditingController sessionController) {
    return TextField(
      controller: sessionController,
      style: TextStyle(fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Enter Session Code',
        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
