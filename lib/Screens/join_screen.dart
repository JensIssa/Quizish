import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/Widgets/quiz_button.dart';
import 'package:quizish/widgets/Appbar.dart';

import '../FireServices/RealTimeExample.dart';



class JoinScreen extends StatefulWidget  {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();


}

class _JoinScreenState extends State<JoinScreen> {

  final sessionController = TextEditingController();
  final  GameSessionService gameSessionService = GameSessionService();
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Join Session',
              style: TextStyle(fontSize: 40, color: Colors.white)
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: SessionInput(),
          ),
          const SizedBox(height: 400),
          Center(
            child: Container(
              width: 200,
              height: 50,
              child: QuizButton(
                text: 'Join',
                onPressed: () {
                  gameSessionService.addUserToSession(sessionController.text, authService.getCurrentFirebaseUser());
                  print(authService.getCurrentFirebaseUser());
                },
                color: Colors.green,
              ),
            )
            ),
        ],
    );
  }

  TextField SessionInput() {
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
