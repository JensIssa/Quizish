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
  int index = 0;

  Answers({required this.answer, required this.index, required this.isCorrect});

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
  int index = -1;
  String question;
  List<Answers> answers;
  String? imgUrl;
  int timer = 20;

  Question.emptyWithIndex(this.index)
      : question = '',
        answers = [
          Answers(answer: '', isCorrect: false, index: 0),
          Answers(answer: '', isCorrect: false, index: 1),
          Answers(answer: '', isCorrect: false, index: 2),
          Answers(answer: '', isCorrect: false, index: 3),
        ];

  Question.empty()
      : question = '',
        answers = [
          Answers(answer: '', isCorrect: false, index: 0),
          Answers(answer: '', isCorrect: false, index: 1),
          Answers(answer: '', isCorrect: false, index: 2),
          Answers(answer: '', isCorrect: false, index: 3),
        ];

  Question({required this.index, required this.question, required this.answers, this.imgUrl, required this.timer});

  Question.noImgOrTimer({required this.index, required this.question, required this.answers});

  Question.noImg({required this.index, required this.question, required this.answers, required this.timer});

  Question.fromMap(Map<String, dynamic> data)
      : index = data['index'],
        question = data['question'],
        answers = data['answers'],
        imgUrl = data['imgUrl'],
        timer = data['timer'];

  Question.fromMapNoImg(Map<String, dynamic> data)
      : index = data['index'],
        question = data['question'],
        answers = data['answers'],
        timer = data['timer'];

  get correctAnswers => answers.where((answer) => answer.isCorrect);

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'question': question,
      'answers': answers,
      'imgUrl': imgUrl,
      'timer': timer,
    };
  }
}
