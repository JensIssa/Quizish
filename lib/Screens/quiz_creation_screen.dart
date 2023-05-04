import 'package:flutter/material.dart';

import '../models/Quiz.dart';
import '../widgets/quiz_button.dart';

class QuizCreationScreen extends StatefulWidget {
  const QuizCreationScreen({Key? key}) : super(key: key);

  @override
  State<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  Quiz quiz = Quiz.empty();

  final _formKey = GlobalKey<FormState>();
  final _quizTitle = TextEditingController();
  final _quizDescription = TextEditingController();
  Map<String, TextEditingController> questionControllers = Map();

  //Use the index of the question for name field, with "a, b, c, d" to get the answer fields, and index + "_t" for time field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a quiz'),
      ),
      body: ListView(
        children: [
          _quizInfoInput2(),
          _questionWidget(),
        ],
      ),
    );
  }

  _questionWidget() {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          quiz.questions.removeAt(quiz.questions.length - 1);
        });
      },
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: 430,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        child: Center(
                          child: Text(
                            '${quiz.questions.length}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orange,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Question',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        child: Center(
                          child: DropdownButtonFormField(
                            isDense: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            value: 10,
                            items: const [
                              DropdownMenuItem(
                                value: 10,
                                child: Text('10'),
                              ),
                              DropdownMenuItem(
                                value: 15,
                                child: Text('15'),
                              ),
                              DropdownMenuItem(
                                value: 20,
                                child: Text('20'),
                              ),
                              DropdownMenuItem(
                                value: 25,
                                child: Text('25'),
                              ),
                              DropdownMenuItem(
                                value: 30,
                                child: Text('30'),
                              ),
                            ],
                            icon: const Icon(Icons.timelapse_rounded),
                            onChanged: (int? value) {},
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
          _answerInput(),
        ],
      ),
    );
  }

  _answerInput() {
    return SizedBox(
        height: 100,
        width: 430,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange,
          ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  _answerField(1),
                  _answerField(2),
                  _answerField(3),
                  _answerField(4),
                ],
          ),
            ),
        ),
    );
  }

  _answerWidget(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      color: Colors.black,
      child: Row(children: [
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
      ]),
    );
  }

  _quizInfoInput2() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: TextFormField(
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
          ),
          const Padding(padding: EdgeInsets.all(5)),
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
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: Row(children: [
                    Icon(Icons.add),
                    Text('Add Question'),
                  ])),
              const Padding(padding: EdgeInsets.all(5)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: Row(children: [
                    Icon(Icons.save),
                    Text('Save'),
                  ])),
            ],
          ),
        ]),
      ),
    );
  }

  _answerField(int colorOption) {
    Color color;
    switch (colorOption) {
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.yellow;
        break;
      case 3:
        color = Colors.blue;
        break;
      case 4:
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Center(
            child: TextFormField(
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),
            ),
          ),
        ),
      )
    );
  }

  _quizInfoInput() {
    return Container(
      width: 400,
      height: 200,
      child: Column(
        children: [
          Row(children: [
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
            IconButton(onPressed: () {}, icon: Icon(Icons.save)),
          ]),
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
