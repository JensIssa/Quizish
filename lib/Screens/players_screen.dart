import 'package:flutter/material.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quizish')),
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _quizName(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _gamePin(),
            ),
            const Text(
              'Players',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            _buildPlayerList(),
          ])
        ],
      ),
    );
  }

  _buildPlayerList() {
    return Flexible(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Player ${index + 1}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _quizName() {
    return Container(
      child: Column(
        children: const [
          Text(
            'Quiz name',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '10 questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  _gamePin() {
    return Container(
      child: Center(
        child: Column(children: [
          Text(
            'Game code',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
          Text(
            '123456',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}
