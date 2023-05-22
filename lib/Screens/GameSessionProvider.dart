import 'package:flutter/cupertino.dart';
import '../models/Session.dart';

class GameSessionProvider extends ChangeNotifier {
  GameSession? gameSession;

  void setGameSession(GameSession? session) {
    gameSession = session;
    notifyListeners();
  }
}