import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizish/Screens/join_screen.dart';
import 'package:quizish/Screens/scoboard_screen.dart';
import 'package:quizish/Screens/homescreen.dart';
import 'Screens/login_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizish Loging',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),debugShowCheckedModeBanner: false,
      home: homeScreen(),
    );
  }
}
