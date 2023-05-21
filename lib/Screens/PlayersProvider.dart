import 'package:flutter/foundation.dart';

class PlayersProvider extends ChangeNotifier {
  List<String> playerNames = [];

  void updatePlayerNames(List<String> names) {
    playerNames = names;
    notifyListeners();
  }
}