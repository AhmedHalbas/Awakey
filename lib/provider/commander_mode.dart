import 'package:flutter/cupertino.dart';

class CommanderMode extends ChangeNotifier {
  bool isCommander = false;

  changeIsCommander(bool value) {
    isCommander = value;
    notifyListeners();
  }
}
