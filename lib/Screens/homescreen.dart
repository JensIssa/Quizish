import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quizish/Screens/quiz_details_screen.dart';
import 'package:quizish/widgets/bottom_navigation_bar.dart';


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
      appBar: AppBar(
        title: const Text ('Homescreen'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      bottomNavigationBar: PurpleNavigationBar(onPressed: () {  },
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        children: List.generate(5,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => QuizDetailsScreen(index),
                      ),
                  );
              },
                  child: Hero(
                    tag: 'quiz-$index',
                    child: _quizNameBox('Quizname', '', ''),
                  ),
          ),
        ),
      ),
    );
  }

  _quizNameBox(String quizName, String questionAmount, String joinCode) {
    return Padding(
      padding: const EdgeInsets.all(10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
            child: Column(
              children: [
                SizedBox(height: 5,),
                Center(
                  child: Text(
                    quizName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  questionAmount +  ' Question',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
                Text(
                  joinCode + ' Gamepin #',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
              ]
            ),
          ),
    );
  }

}