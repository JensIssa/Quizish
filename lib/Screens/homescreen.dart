import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quizish/Widgets/bottom_navigation_bar.dart';


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
        crossAxisCount: 1,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        children: List.generate(3,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Placeholder(),
                      ),
                  );
              },
                  child: Hero(
                    tag: 'quiz-$index',
                    child: _quizNameBox('Quiz 1', '10', '#37837483'),
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
        child: Center(
          child: ListView(
            children: [
              Text(
                quizName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              Text(
                questionAmount,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white
                ),
              ),
              Text(
                joinCode,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

}