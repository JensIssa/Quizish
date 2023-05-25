import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizish/FireServices/quiz_service.dart';

import '../models/Quiz.dart';

import 'package:image_picker/image_picker.dart';


class QuizCreationScreen extends StatefulWidget {
  const QuizCreationScreen({Key? key}) : super(key: key);

  @override
  State<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

//TODO: Post quiz to firebase

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  Quiz quiz = Quiz.empty();
  QuizService quizService = QuizService();

  Color deleteBgColor = Colors.red;

  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();
  final _formKey = GlobalKey<FormState>();
  final _quizTitle = TextEditingController();
  final _quizDescription = TextEditingController();

  Color backgroundColor = Colors.grey[800]!;

  //Use the index of the question for name field, with "a, b, c, d" to get the answer fields, and index + "_t" for time field

  _saveQuiz(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      quiz.title = _quizTitle.text;
      quiz.description = _quizDescription.text;

      for (var question in quiz.questions) {
        var correctAnswers =
            question.answers.where((element) => element.isCorrect);
        if (correctAnswers.isEmpty) {
          SnackBar snackBar = SnackBar(
            content: Text(
                "Question ${question.index + 1} does not have a correct answer"),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      }
      quizService.createQuiz(quiz);
      _showOnSavedDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = _backgroundColor(context);
    deleteBgColor = _backgroundColor(context);

    var ui = Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        //TODO: Limit size of ui on bigger screens,
        //TODO: replace questionInputs with a "no Questions here" message when empty
        child: Form(
          key: _formKey,
          child: Column(children: [
            _quizInfoInput(),
            const SizedBox(height: 40),
            Expanded(
                child: AnimatedList(
              key: _animatedListKey,
              initialItemCount: quiz.questions.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index,
                  Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: _questionWidget(quiz.questions[index], index),
                );
              },
            )),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        int index = quiz.questions.length;
                        quiz.questions.add(Question.emptyWithIndex(index));
                        _animatedListKey.currentState?.insertItem(index);
                        //_animatedListKey.currentState?.insertItem(index);
                      });
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );

    var windowWidth = MediaQuery.of(context).size.width;

    if (windowWidth > 600) {
      return Center(
        child: SizedBox(
          width: windowWidth / 2,
          child: ui,
        ),
      );
    } else {
      return ui;
    }
  }

  _questionWidget(Question question, int index) {
    return Column(
      children: [
        Row(
          children: [
            _questionNumber(question),
            _imageInput(question),
            _questionInput(question),
            _timeInput(question),
            _deleteBtn(question, index)
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: _answerInput(question),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  Widget _imageInput(Question question) {
    final ImagePicker _imagePicker = ImagePicker();

    Future<void> _selectImage() async {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          // Update the question object with the selected image or the image path
          question.imageUrl = image.path;
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: 40,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          child: IconButton(
            icon: Icon(Icons.image),
            onPressed: _selectImage,
          ),
        ),
      ),
    );
  }

  _questionNumber(Question question) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor),
            child: Center(
              child: Text(
                '${question.index + 1}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ),
    );
  }

  _questionInput(Question question) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: backgroundColor),
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
            onChanged: (value) {
              setState(() {
                question.question = value;
              });
            },
          ),
        ),
      ),
    );
  }

  _timeInput(Question question) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
          width: 100,
          height: 50,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField(
                alignment: Alignment.center,
                dropdownColor: backgroundColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                value: question.timer == 0 ? 20 : question.timer,
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
                onChanged: (int? value) {
                  setState(() {
                    question.timer = value!;
                  });
                },
              ),
            ),
          )),
    );
  }

  _deleteBtn(Question question, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: 60,
        height: 50,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: Colors.red,
            child: const Icon(Icons.delete),
            onTap: () {
              setState(() {
                int removedIndex = index;
                quiz.questions.removeAt(index);
                for (int i = 0; i < quiz.questions.length; i++) {
                  //Redo the indexes
                  quiz.questions[i].index = i;
                }

                _animatedListKey.currentState?.removeItem(
                    removedIndex,
                    (context, animation) => SizeTransition(
                          sizeFactor: animation,
                          child: _questionWidget(question, removedIndex),
                        ));
              });
            },
          ),
        ),
      ),
    );
  }

  _answerInput(Question question) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Flex(
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.down,
          clipBehavior: Clip.none,
          children: [
            _answerField(0, question),
            _answerField(1, question),
            _answerField(2, question),
            _answerField(3, question),
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
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextFormField(
                controller: _quizTitle,
                decoration: InputDecoration(
                  labelText: 'Quiz title',
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColorLight),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  } else if (value.length > 50) {
                    return 'Title must be less than 50 characters';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Quiz description',
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColorLight),
                ),
              ),
              controller: _quizDescription,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                } else if (value.length > 100) {
                  return 'Description must be less than 100 characters';
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
                  onPressed: () => _saveQuiz(context),
                  child: Row(children: const [
                    Icon(Icons.save, size: 20, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Save',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ])),
            ),
          ),
        ]),
      ),
    );
  }

  _answerField(int answerIndex, Question question) {
    Color color;
    switch (answerIndex) {
      case 0:
        color = Colors.green;
        break;
      case 1:
        color = Colors.orange;
        break;
      case 2:
        color = Colors.blue;
        break;
      case 3:
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    var hslBorderColor = HSLColor.fromColor(color);
    Color borderColor = hslBorderColor.withLightness(0.4).toColor();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            border: Border.all(color: borderColor, width: 2.0),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Checkbox(
                  activeColor: borderColor,
                  value: question.answers[answerIndex].isCorrect,
                  onChanged: (bool? value) {
                    setState(() {
                      question.answers[answerIndex].isCorrect = value!;
                    });
                  },
                ),
              ),
              Center(
                child: TextFormField(
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[300]),
                    labelText: 'Answer option',
                    contentPadding: const EdgeInsets.all(5),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an answer';
                    } else if (value.length > 50) {
                      return 'Answer must be less than 50 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      question.answers[answerIndex].answer = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _backgroundColor(BuildContext context) {
    var themeColor = Theme.of(context).scaffoldBackgroundColor;
    var hslColorBG = HSLColor.fromColor(themeColor);
    var modifiedColor = hslColorBG.withLightness(0.3).toColor();

    return Theme.of(context).brightness == Brightness.dark
        ? modifiedColor
        : Colors.grey[300];
  }

  _showOnSavedDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Quiz saved! 🎉',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const Text(
                  "Create another quiz or continue working on this one?"),
              const SizedBox(height: 15),
              SizedBox(
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text('Keep working 💪'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => _createNewQuiz(context),
                      child: const Text('Create another! 🔨'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createNewQuiz(BuildContext context) {
    setState(() {
      _quizTitle.clear();
      _quizDescription.clear();
      quiz = Quiz.empty();
      quiz.questions.add(Question.emptyWithIndex(0));

    });
    Navigator.of(context, rootNavigator: true).pop();
  }
}
