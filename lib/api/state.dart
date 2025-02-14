import 'package:flutter/material.dart';

class NavBar extends ChangeNotifier {
  int idx = 0;
  void change(int i) {
    idx = i;
    notifyListeners();
  }
}
