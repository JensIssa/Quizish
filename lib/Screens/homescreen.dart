import 'package:flutter/material.dart';
import 'package:quizish/Screens/quiz_details_screen.dart';
import 'package:quizish/widgets/quiz_name_box.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    const spacing = 5.0;
    return Container(
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
    );
  }
}