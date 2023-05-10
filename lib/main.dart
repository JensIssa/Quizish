import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Screens/login_screen.dart';
import 'bloc_observer.dart';


Future<void> main() {
  return BlocOverrides.runZoned(
      () async {
        runApp(const MyApp());
      },
    blocObserver: AppBlocObserver(),
  );
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
      home: loginScreen(),
    );
  }
}
