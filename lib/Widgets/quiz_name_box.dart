import 'package:flutter/material.dart';

class QuizNameBox extends Material {
  QuizNameBox({
    Key? key,
    required String quizName,
    required String questionAmount, // Updated type to String?
    required String joinCode,
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
                quizName != "" ? quizName : "Quiz Name",
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
              questionAmount != null ? questionAmount : 'No Questions',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              joinCode != "" ? joinCode : "",
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
