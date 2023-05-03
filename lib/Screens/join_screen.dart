import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizish/Widgets/quiz_button.dart';
import 'package:quizish/widgets/Appbar.dart';

class joinScreen extends StatefulWidget {
  const joinScreen({Key? key}) : super(key: key);

  @override
  State<joinScreen> createState() => _joinScreenState();
}

class _joinScreenState extends State<joinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PurpleAppBar(title: 'Join Session',
        backgroundColor: Color(0xFF7885b2),
      ),
      backgroundColor: Colors.black12,
      body: Column(
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
            child: TextField(
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
            ),
          ),
          const SizedBox(height: 400),
          Center(
            child: Container(
              width: 200,
              height: 50,
              child: QuizButton(
                text: 'Join',
                onPressed: () {},
                color: Colors.green,
              ),
            )
            ),
        ],
      )
    );
  }
}
