import 'package:flutter/material.dart';
import 'package:quizish/Widgets/in_game_appbar.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InGameAppBar(onLeave: () {  },),
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
            Flexible(
              child: _buildPlayerList(),
            )
          ])
        ],
      ),
    );
  }

  _buildPlayerList() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (context, index) =>
            _playerNameBox('Player $index'),
        itemCount: 10);
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

  _playerNameBox(String playerName) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            playerName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
