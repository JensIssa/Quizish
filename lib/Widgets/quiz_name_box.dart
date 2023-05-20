import 'package:flutter/material.dart';

class QuizNameBox extends Material {
  QuizNameBox({
    Key? key,
    required String quizTitle,
    required String quizAuthor, // Updated type to String?
    required String quizId,
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
              height: 5,
            ),
            Center(
              child: Text(
                quizTitle != "" ? quizTitle : "Quiz Name",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              quizAuthor != null ? quizAuthor : 'No Questions',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              quizId != "" ? quizId : "",
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
