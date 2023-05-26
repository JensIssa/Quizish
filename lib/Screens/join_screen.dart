import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizish/FireServices/AuthService.dart';
import 'package:quizish/Screens/players_screen.dart';
import 'package:quizish/widgets/quiz_button.dart';
import '../FireServices/RealTimeExample.dart';
import '../models/Session.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JoinScreenState();
}

/**
 * This class makes it possible for a user to join a session
 * Both by entering a session code or by scanning a QR code
 */

class _JoinScreenState extends State<JoinScreen> {
  final sessionController = TextEditingController();
  var getResult = 'QR Code Result';

  @override
  Widget build(BuildContext context) {
    final GameSessionService gameSessionService = GameSessionService();
    final AuthService authService = AuthService();

    return Column(
      children: [
        const SizedBox(height: 40),
        const Center(
          child: Text(
            'Join Session',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: SessionInput(sessionController),
        ),
        const SizedBox(height: 100),
        Center(
          child: Container(
            width: 200,
            height: 50,
            child: QuizButton(
              text: 'Join',
              onPressed: () async {
                if (sessionController.text.isNotEmpty) {
                  await gameSessionService.addUserToSession(
                    sessionController.text,
                    authService.getCurrentFirebaseUser(),
                  );
                  GameSession? gameSession =
                  await gameSessionService.getGameSessionByCode(
                    sessionController.text,
                  );
                  if (gameSession != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayersScreen(
                          gameSession: gameSession,
                        ),
                      ),
                    );
                  } else {
                    showSessionErrorDialog('Session not found');
                  }
                } else {
                  showSessionErrorDialog('Please enter a session code');
                }
              },
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 200,
            height: 50,
            child: QuizButton(
              text: 'Scan QR',
              onPressed: () async {
                scanQRCode();
              },
              color: Colors.green,
            ),
          ),
        )
      ],
    );
  }

  /**
   * This method shows an error dialog when the user enters an invalid session code
   */
  void showSessionErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  /**
   * This method scans a QR code and sets the session code to the result
   */
  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      setState(() {
        sessionController.text = qrCode;
      });
    } on PlatformException {
      sessionController.text = 'Failed to scan QR Code.';
    }
  }
}

/**
 * This method returns a text field for the session code
 */
TextField SessionInput(TextEditingController sessionController) {
  return TextField(
    controller: sessionController,
    style: TextStyle(fontSize: 20, color: Colors.white),
    decoration: InputDecoration(
      hintText: 'Enter Session Code',
      hintStyle: TextStyle(fontSize: 20, color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
