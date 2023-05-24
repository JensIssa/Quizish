import 'package:flutter/material.dart';


class QuizNameBox extends Material {

  final String quizTitle;
  final String quizAuthor;
  final String questions;

  QuizNameBox({
    Key? key,
    required this.quizTitle,
    required this.quizAuthor,
    required this.questions,
  }) : super(
    color: Colors.transparent,
    key: key,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                'Title: ${quizTitle != "" ? quizTitle : "Quiz Name"}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Host: ${quizAuthor != null ? quizAuthor : 'No Questions'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Questions: ${questions != "" ? questions : ""}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
