import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';

class QuizDetailsScreen extends StatelessWidget {
  final int index;

  const QuizDetailsScreen(this.index, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      bottomNavigationBar: PurpleNavigationBar(onPressed: () {  },
    ),

    );
  }
}