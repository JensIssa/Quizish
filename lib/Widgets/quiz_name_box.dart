import 'package:flutter/material.dart';

class QuizNameBox extends Material {
  QuizNameBox({
    Key? key,
    required String quizName,
    required String questionAmount,
    required String joinCode
  }) : super(
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
              SizedBox(height: 5,),
              Center(
                child: Text(
                  quizName + ' Quizname',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text(
                questionAmount +  ' Question',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
              Text(
                joinCode + ' Gamepin #',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                ),
              ),
            ]
        ),
      ),
    )
  );
}