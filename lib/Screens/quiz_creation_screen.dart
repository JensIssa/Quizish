import 'package:flutter/material.dart';

import '../models/Quiz.dart';
import '../widgets/quiz_button.dart';

class QuizCreationScreen extends StatefulWidget {
  const QuizCreationScreen({Key? key}) : super(key: key);

  @override
  State<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {

  final _formKey = GlobalKey<FormState>();
  final _quizTitle = TextEditingController();
  final _quizDescription = TextEditingController();
  final _question = TextEditingController();
  final _answer1 = TextEditingController();
  final _answer2 = TextEditingController();
  final _answer3 = TextEditingController();
  final _answer4 = TextEditingController();
  final _quizDuration = TextEditingController();

  List<Question> questions = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a quiz'),
      ),
      body: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _quizInfoInput(),
                      Padding(padding: EdgeInsets.all(10)),
                      _questionWidget(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                   // _addQuestionBtn(context),
                    // _createQuizBtn(context),
                  ],
                )
              ],
            ),
    );
  }

  _questionWidget() {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          questions.removeAt(questions.length - 1);
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: Colors.orange,
                width: 30,
                height: 30,
                child: Text(
                  'Question ${questions.length + 1}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
              )
              ),
              Container(
                width: 300,
                color: Colors.orange,
                child: _questionInput(),
              ),
              Container(
                width: 30,
                height: 30, 
                color: Colors.orange,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.timelapse_rounded),
                )
              )
            ],
          ),
          _answerWidget(context)
        ],
      ),
    );
  }

  
  _answerWidget(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      color: Colors.black,
      child: Row(
        children: [
        QuizButton(
          onPressed: () {},
          text: 'Answer 1',
          color: Colors.green,
        ),
        QuizButton(
          onPressed: () {},
          text: 'Answer 2',
          color: Colors.yellow,
        ),
        QuizButton(
          onPressed: () {},
          text: 'Answer 3',
          color: Colors.blue,
        ),
        QuizButton(
          onPressed: () {},
          text: 'Answer 4',
          color: Colors.red,
        ),
      ]
      ),
    );
  }

  _questionInput() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Question',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a question';
        }
        return null;
      },
    );
  }

  _quizInfoInput() {
    return Container(
      color: Colors.orange,
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              TextFormField(
              controller: _quizTitle,
              decoration: const InputDecoration(
                labelText: 'Quiz title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.save)
              ),
          ]
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Quiz description',
            ),
            controller: _quizDescription,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }


}
