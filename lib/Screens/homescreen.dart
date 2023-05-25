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
  Stream<List<Quiz>>? _quizStream;

  @override
  void initState() {
    super.initState();
    _quizStream = _quizService.getQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 5.0;
    return StreamBuilder<List<Quiz>>(
      stream: _quizStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final quizzes = snapshot.data!;
          return Container(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              children: quizzes.map((quiz) {
                final index = quizzes.indexOf(quiz);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizDetailsScreen(quiz: quizzes[index]),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'quiz-$index',
                    child: QuizNameBox(
                      quizTitle: quiz.title,
                      quizAuthor: quiz.authorDisplayName,
                      questions: quiz.questions.length.toString(),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
