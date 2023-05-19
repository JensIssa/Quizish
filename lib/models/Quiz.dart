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


  Quiz.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        description = data['description'],
        author = data['author'],
        questions = [..._getQuestions(data['questions'])];

  Quiz.fromMapWithID(this.id, Map<String, dynamic> data)
      : title = data['title'],
        description = data['description'],
        author = data['author'],
        questions = _getQuestions(data['questions']);

  static List<Question> _getQuestions(Map<String, dynamic> data) {
    List<Question> questions = [];
    data.forEach((key, value) {
      // Pass the key (question index) along with the value
      questions.add(Question.fromMap(value, int.parse(key)));
    });
    return questions;
  }





  Map<String, dynamic> toMap() {
    var questionsMap = <String, dynamic>{};
    questions.forEach((element) {
      questionsMap[element.index.toString()] = element.toMap();
    });

    return {
      'title': title,
      'id': id,
      'description': description,
      'author': author,
      'questions': questionsMap,
    };
  }

  @override
  String toString() {
    var baseInfo = 'Quiz{title: $title, id: $id, description: $description, author: $author}';
    var questionsString = questions.fold('', (prev, element) => prev + element.toString());
    return "$baseInfo | $questionsString";
  }
}

class Answers {
  String answer;
  bool isCorrect;
  int index = 0;

  Answers({required this.answer, required this.index, required this.isCorrect});

  Answers.fromMap(Map<String, dynamic> data)
      : answer = data['answer'],
        isCorrect = data['isCorrect'],
        index = data['index'];

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'isCorrect': isCorrect,
      'index': index,
    };
  }

  @override
  String toString() {
    return 'Answers{answer: $answer, isCorrect: $isCorrect, index: $index}';
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

  Question.fromMap(Map<String, dynamic> data, int parse) :
        index = data['index'],
        question = data['question'],
        answers = _getAnswers(data['answers']),
        imgUrl = data['imgUrl'],
        timer = data['timer'];

  static _getAnswers(Map<String, dynamic> data) {
    List<Answers> answersList = [];
    data.forEach((key, value) {
      answersList.add(Answers.fromMap(value));
    });
    return answersList;
  }


  Question.fromMapNoImg(Map<String, dynamic> data)
      : index = data['index'],
        question = data['question'],
        answers = _getAnswers(data['answers']),
        timer = data['timer'];

  get correctAnswers => answers.where((answer) => answer.isCorrect);

  Map<String, dynamic> toMap() {
    var answersMap = <String, dynamic>{};
    answers.forEach((element) {
      answersMap[element.index.toString()] = element.toMap();
    });
    return {
      'index': index,
      'question': question,
      'answers': answersMap,
      'imgUrl': imgUrl,
      'timer': timer,
    };
  }


  @override
  String toString() {
    var baseInfo = 'Question{index: $index, question: $question, imgUrl: $imgUrl, timer: $timer}';
    var answersString = answers.fold('', (prev, element) => prev + element.toString());
    return baseInfo + answersString;
  }
}
