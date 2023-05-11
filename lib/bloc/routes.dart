import 'package:flutter/material.dart';
import 'package:quizish/Screens/homescreen.dart';
import 'package:quizish/Screens/in_app_container.dart';
import 'package:quizish/Screens/login_screen.dart';
import 'package:quizish/bloc/app_state.dart';

List<Page> onGenerateAppViewPages(AppState state, List<Page<dynamic>> pages) {

  switch (state.status) {
    case AppStatus.authenticated:
      return [
        MaterialPage(
          child: InAppContainer(),
        ),
      ];
    case AppStatus.unauthenticated:
    default:
      return [
        MaterialPage(
          child: loginScreen(),
        ),
      ];
  }
}