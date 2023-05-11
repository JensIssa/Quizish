import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    var ui = Scaffold(
      appBar: AppBar(
        title: const Text('Create a quiz'),
      ),
      body:
      SizedBox(
        width: MediaQuery.of(context).size.width,
        //TODO: Limit size of ui on bigger screens,
        //TODO: replace questionInputs with a "no Questions here" message when empty
        child: Column(
          children: [
            _quizInfoInput(),
            Expanded(
              child: ListView.builder(
                itemCount: quiz.questions.length,
                  itemBuilder: (context, index) {
                    return _questionWidget(index);
                  },
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      quiz.questions.add(Question.empty());
                    });
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ]
        ),
      ),
    );

    num windowWidth = MediaQuery.of(context).size.width;
    if (windowWidth > 600) {
      return SizedBox(
        width: windowWidth/2,
        child: ui,
      );
    } else {
      return ui;
    }

  }

  _questionWidget(int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (direction) {
        setState(() {
          quiz.questions.removeAt(quiz.questions.length - 1);
        });
      },
      child: Column(
        children: [
          Row(
            children: [_questionNumber(index), _questionInput(), _timeInput()],
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: _answerInput(),
          ),
          const Divider()
        ],
      ),
    );
  }

  _questionNumber(int index) {
    return Padding(
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
                '${index+1}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ),
    );
  }

  _questionInput() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange,
          ),
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
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
    );
  }

  _timeInput() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
          width: 100,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField(
                alignment: Alignment.center,
                dropdownColor: Colors.orange,
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
            ),
          )),
    );
  }

  _answerInput() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Flex(
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.down,
          clipBehavior: Clip.none,
          children: [
            _answerField(1),
            _answerField(2),
            _answerField(3),
            _answerField(4),
          ],
        ),
      ),
    );
  }

  _quizInfoInput() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: Row(children: [
                    Icon(Icons.save),
                    Text('Save'),
                  ])),
            ),
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: Center(
            child: TextFormField(
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Answer option',
                contentPadding: EdgeInsets.all(5),
              ),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
