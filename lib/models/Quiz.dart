import 'package:firebase_auth/firebase_auth.dart';

class Quiz {
  String title;
  String id;
  String description;
  User? author;
  List<Question> questions;

  Quiz(
      {required this.title,
      required this.id,
      required this.description,
      required this.author,
      required this.questions});

  Quiz.noAuthor(
      {required this.title,
      required this.id,
      required this.description,
      required this.questions});

  Quiz.empty()
      : title = '',
        id = '',
        description = '',
        author = null,
        questions = [];

  Quiz.fromMap(this.id, Map<String, dynamic> data)
      : title = data['title'],
        description = data['description'],
        author = data['author'],
        questions = data['questions'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'author': author,
      'questions': questions,

    };
  }
}

class Answers {
  String answer;
  bool isCorrect;

  Answers({required this.answer, required this.isCorrect});

  Answers.fromMap(Map<String, dynamic> data)
      : answer = data['answer'],
        isCorrect = data['isCorrect'];

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'isCorrect': isCorrect,
    };
  }
}

class Question {
  String question;
  List<Answers> answers;
  String? imgUrl;


  Question.empty()
      : question = '',
        answers = [];

  Question({required this.question, required this.answers, this.imgUrl});

  Question.fromMap(Map<String, dynamic> data)
      : question = data['question'],
        answers = data['answers'];

  get correctAnswer => answers.firstWhere((element) => element.isCorrect);

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
    };
  }
}
