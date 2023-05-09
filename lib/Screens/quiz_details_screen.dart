import 'package:flutter/material.dart';
import 'package:quizish/widgets/quiz_button.dart';
import 'package:quizish/widgets/quiz_name_box.dart';


class QuizDetailsScreen extends StatelessWidget {
  final int index;

  const QuizDetailsScreen(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
          children: [
            Container(
                height: 250,
                child: QuizNameBox(
                  quizName: '',
                  questionAmount: '',
                  joinCode: '',
                ),
            ),
            Text('Description', style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Container(child: Text('Lorem ipsum dolor sit amet. Aut deserunt consequatur et facere nulla et velit modi et dolor asperiores ea minima vero. Qui praesentium temporibus qui beatae libero est saepe quisquam ut laboriosam eius ea dolores quia aut quia dignissimos. Sed illum quas id nostrum accusamus ut quidem amet qui modi exercitationem ut obcaecati quia quo totam distinctio in inventore saepe. Sed numquam sapiente et consectetur Quis aut consequatur deserunt vel porro voluptatem cum voluptas natus!',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            ),
            Container(
              child: QuizButton(text:'Start', onPressed: () {}, color: Colors.green),
            height: 130,
            width: 150,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 70),
            )
          ],
        ),
    );
  }

}
