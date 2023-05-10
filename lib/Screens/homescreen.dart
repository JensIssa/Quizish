import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizish/Screens/quiz_details_screen.dart';
import 'package:quizish/bloc/AppBloc.dart';
import 'package:quizish/widgets/bottom_navigation_bar.dart';
import 'package:quizish/widgets/quiz_name_box.dart';

import '../widgets/Appbar.dart';


class homeScreen extends StatefulWidget {

  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {

    const spacing = 5.0;
    return Scaffold(
      appBar: PurpleAppBar(title: 'Homescreen',
        backgroundColor: Color(0xFF7885b2),
      ),
      bottomNavigationBar: PurpleNavigationBar(onPressed: () {  },
      ),
      body: Container(
        color: Colors.black,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          children: List.generate(5,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => QuizDetailsScreen(),
                        ),
                    );
                },
                    child: Hero(
                      tag: 'quiz-$index',
                      child: QuizNameBox(quizName: '', questionAmount: '', joinCode: '',),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}