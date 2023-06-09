import 'package:flutter/material.dart';
import 'package:quizish/Screens/homescreen.dart';
import 'package:quizish/Screens/in_app_container.dart';
import 'package:quizish/Screens/login_screen.dart';
import 'package:quizish/Screens/quiz_creation_screen.dart';
import 'package:quizish/Screens/quiz_screen.dart';
import 'package:quizish/bloc/app_state.dart';

import '../models/Quiz.dart';

/**
 * This method is called when the app navigates to a new page
 */
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


class TempQuizData {

  static Quiz getQuiz() {
    return Quiz.noAuthor(
        title: "quiz title",
        id: "-1",
        author: "author",
        authorDisplayName: "author display name",
        description: "description",
        questions: [
          Question(
              index: 0,
              question: "question",
              timer: 20,
              answers: [
                Answers(answer: "answer 1", isCorrect: true, index: 0),
                Answers(answer: "answer", isCorrect: false, index: 1),
                Answers(answer: "answer", isCorrect: false, index: 2),
                Answers(answer: "answer", isCorrect: false, index: 3),
              ]),
          Question.noImgOrTimer(index: 1, question: "question", answers: [
            Answers(answer: "answer", isCorrect: false, index: 0),
            Answers(answer: "answer 2", isCorrect: true, index: 1),
            Answers(answer: "answer", isCorrect: false, index: 2),
            Answers(answer: "answer", isCorrect: false, index: 3),
          ]),
          Question.noImgOrTimer(index: 2, question: "question", answers: [
            Answers(answer: "answer", isCorrect: false, index: 0),
            Answers(answer: "answer", isCorrect: false, index: 1),
            Answers(answer: "answer 3", isCorrect: true, index: 2),
            Answers(answer: "answer", isCorrect: false, index: 3),
          ]),
        ]);
  }
}