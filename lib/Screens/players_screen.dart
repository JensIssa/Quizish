import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quizish/Screens/quiz_screen.dart';
import 'package:quizish/Widgets/in_game_appbar.dart';
import 'package:quizish/models/Session.dart';
import 'package:quizish/provider/quiz_notifier_model.dart';
import '../FireServices/RealTimeExample.dart';


class PlayersScreen extends StatelessWidget {
  final GameSessionService _gameSessionService = GameSessionService();
  final GameSession? gameSession;
  final String? gamePin;

  PlayersScreen({Key? key, this.gameSession, this.gamePin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: _gameSessionService.getCurrentQuestion(gameSession?.id),
      builder: (context, questionSnapshot) {
        if (questionSnapshot.data == 1) { //question number is 0 == Game has started
          print(questionSnapshot.data);
          var quizProvider = Provider.of<QuizNotifierModel>(context, listen: false);
          quizProvider.setGameSession(gameSession!);
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(gameSession!)));
        }
        return Scaffold(
          appBar: InGameAppBar(onLeave: () {}),
          body: StreamBuilder<List<String>>(
            stream: _gameSessionService.getAllUsersBySession(gameSession?.id ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final playerNames = snapshot.data ?? [];
                return _buildPlayerList(playerNames, context, questionSnapshot);
              }
            },
          ),
        );
      }
    );
  }

  Widget _buildPlayerList(List<String> playerNames, BuildContext context, AsyncSnapshot<int?> snapshot) {
    final isHost = gameSession?.hostId == FirebaseAuth.instance.currentUser?.uid; // Assuming you have a getCurrentUserId() function to get the current user's ID
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _quizName(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _gamePin(),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 1.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) =>
                    _playerNameBox(playerNames[index]),
                itemCount: playerNames.length,
              ),
            ),
            const SizedBox(height: 20),
            QrButton(gameSessionId: gameSession?.id),
            const SizedBox(height: 20), // Add spacing between the player list and the button
              ElevatedButton(
                onPressed: () {
                  _gameSessionService.incrementCurrent(gameSession?.id);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the button background color to green
                  minimumSize: const Size(200, 50), // Set the button size
                ),
                child: const Text(
                  'Play now',
                  style: TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
      ],
    );
  }


  Widget _quizName() {
    return Container(
      child: Column(
        children:  [
          Text(
            gameSession?.quiz?.title ?? 'Loading...',
            style: const TextStyle(
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
            gameSession?.id ?? 'Loading...',
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

class QrButton extends StatelessWidget {
  final String? gameSessionId;
  const QrButton({
    Key? key, this.gameSessionId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Scan the QR code to join the game'),
                      Container(
                        width: 200,
                        height: 200,
                        child: QrImageView(
                          data: gameSessionId ?? '',
                          version: QrVersions.auto,
                          size: 200,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                    )
                  ],
                ),
            );
          },
          icon: const Icon(Icons.camera_enhance),
      );
    }
  }