import 'package:flutter/cupertino.dart';
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
  State<StatefulWidget> createState() => _JoinScreen();
}

  class _JoinScreen extends State<JoinScreen> {
    TextEditingController qrCodeController = TextEditingController();

    var getResult = 'QR Code Result';

    @override
    Widget build(BuildContext context) {
      final sessionController = TextEditingController();
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
            child: SessionInput(sessionController, qrCodeController),
          ),
          const SizedBox(height: 100),
          Center(
            child: Container(
              width: 200,
              height: 50,
              child: QuizButton(
                text: 'Join',
                onPressed: () async {
                  await gameSessionService.addUserToSession(
                    sessionController.text,
                    authService.getCurrentFirebaseUser(),
                  );
                  GameSession? gameSession =
                  await gameSessionService.getGameSessionByCode(
                    sessionController.text,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayersScreen(
                        gameSession: gameSession,
                      ),
                    ),
                  );
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
                }, color: Colors.green,
              ),
            ),
          )
        ],
      );
    }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

      if(!mounted) return;
      setState(() {
        qrCodeController.text = qrCode;
      });
    } on PlatformException {
      qrCodeController.text = 'Failed to scan QR Code.';
    }
  }
}


  TextField SessionInput(TextEditingController sessionController,
      TextEditingController qrCodeController) {
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

