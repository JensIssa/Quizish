import 'package:flutter/material.dart';
import 'package:quizish/FireServices/quiz_service.dart';
import 'package:quizish/Screens/quiz_details_screen.dart';
import 'package:quizish/widgets/quiz_name_box.dart';

import '../models/Quiz.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  final QuizService _quizService = QuizService();
  List<Quiz> _quizzes  = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    final quizzes = await _quizService.getQuizzes();
    setState(() {
      _quizzes = quizzes;
    });
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 5.0;
    return Container(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          children: _quizzes.map((quiz) {
            final index = _quizzes.indexOf(quiz);
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizDetailsScreen(quiz: _quizzes[index]),
                  ),
                );
              },
              child: Hero(
                tag: 'quiz-$index',
                child: QuizNameBox(
                  quizTitle: quiz.title,
                  quizAuthor:  quiz.authorDisplayName,
                  questions: quiz.questions.length.toString(),
                ),
              ),
            );
          }).toList(),
        ),
    );
  }
}