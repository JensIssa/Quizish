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
    return Scaffold(
      appBar: AppBar(
        title: const Text ('Homescreen'),
        centerTitle: true,
      ),
      body: PurpleNavigationBar(onPressed: () {  },),
    );
  }
}