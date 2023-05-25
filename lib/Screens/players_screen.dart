import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quizish/Screens/homescreen.dart';
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
        return Scaffold(
          appBar: InGameAppBar(onLeave: () {
            if (gameSession?.hostId == FirebaseAuth.instance.currentUser?.uid) {
              SnackBar snackBar = const SnackBar(
                content: Text(
                    'You are the host of this session. You cannot leave.'),
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else {
              _gameSessionService.leaveSessionAsUser(gameSession?.id);
              Navigator.of(context).popAndPushNamed('/home');
            }
          }),
          body: StreamBuilder<List<Map<String, String>>>(
            stream: _gameSessionService.getAllUsersBySession(gameSession?.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final players = snapshot.data ?? [];
                final playerNames = players.map((
                    player) => player['displayName']).toList();
                final playerIds = players.map((player) => player['playerId'])
                    .toList();
                /*
                final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
                final isCurrentUserInSession = playerIds.contains(currentUserUid);
                final isHost = gameSession?.hostId == FirebaseAuth.instance.currentUser?.uid;


                if(!isCurrentUserInSession && !isHost) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showUserKickedDialog(context);
                  });
                }
                 */
                return _buildPlayerList(
                    playerNames, context, questionSnapshot, playerIds);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildPlayerList(List<String?> playerNames, BuildContext context,
      AsyncSnapshot<int?> snapshot, List<String?> playerIds) {
    final isHost = gameSession?.hostId ==
        FirebaseAuth.instance.currentUser?.uid;
    // Check the value of the current question
    if (snapshot.data == 0) {
      var quizProvider = Provider.of<QuizNotifierModel>(context, listen: false);
      quizProvider.setGameSession(gameSession!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuizScreen(gameSession!)));
      });
    }

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
                    _playerNameBox(playerNames[index]!,
                        playerIds[index]!),
                itemCount: playerNames.length,
              ),
            ),
            const SizedBox(height: 20),
            QrButton(gameSessionId: gameSession?.id),
            const SizedBox(height: 20),
            if(isHost)
              ElevatedButton(
                onPressed: () {
                  _gameSessionService.incrementCurrent(gameSession?.id);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: const Size(200, 50),
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
        children: [
          Text(
            gameSession?.quiz?.title ?? 'Loading...',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Questions: ${gameSession?.quiz?.questions.length ??
                'No Question'}',
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
        child: Column(children: [
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

  Widget _playerNameBox(String playerName, String playerId) {
    final isHost = gameSession?.hostId ==
        FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                playerName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            if(isHost)
              Center(
                child: IconButton(onPressed: () {
                  _gameSessionService.removeUserFromSession(
                      gameSession?.id, playerId);
                },
                    icon: const Icon(
                        Icons.close, color: Colors.black, size: 30)),
              )
          ],
        ),
      ),
    );
  }
}
  /*
  Future<void> _showUserKickedDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You are no longer part of this session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 15),
              SizedBox(
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {Navigator.of(context, rootNavigator: true).popAndPushNamed('/home'); },
                      child: const Text('Return to the home-screen'),
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
  */


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