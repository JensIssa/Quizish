import 'package:flutter/material.dart';
import 'package:quizish/Widgets/in_game_appbar.dart';
import '../FireServices/RealTimeExample.dart'; // Import the GameSessionService

class PlayersScreen extends StatelessWidget {
  final GameSessionService _gameSessionService = GameSessionService();
  final String sessionId;

  PlayersScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InGameAppBar(onLeave: () {}),
      body: FutureBuilder<List<String>>(
        future: _gameSessionService.getAllUsersBySession(sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final playerNames = snapshot.data ?? [];
            return _buildPlayerList(playerNames);
          }
        },
      ),
    );
  }

  Widget _buildPlayerList(List<String> playerNames) {
    return Stack(
      children: [
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
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 1.5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => _playerNameBox(playerNames[index]),
              itemCount: playerNames.length,
            ),
          ),
        ]),
      ],
    );
  }
  Widget _quizName() {
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

  Widget _gamePin() {
    return Container(
      child: Center(
        child: Column(children:  [
          const Text(
            'Game code: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
          Text(
            sessionId,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }

  Widget _playerNameBox(String playerName) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
    child: Text(     playerName,
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


