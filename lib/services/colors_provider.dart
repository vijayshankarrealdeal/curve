import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorsProvider extends ChangeNotifier {
  ColorsProvider() {
    darkModeToggle();
  }
  bool _darkMode = true;
  bool get darkMode => _darkMode;
  void darkModeToggle() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darkMode = pref.getBool("mode") ?? true;
    notifyListeners();
  }

  void setDarkMode(bool value) async {
    _darkMode = !_darkMode;
    notifyListeners();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("mode", _darkMode);
  }

  Color getScaffoldColor() {
    if (darkMode) {
      return Color(0xff101010);
    }
    return CupertinoColors.white;
  }

  Color getAppBarColor() {
    if (darkMode) {
      return CupertinoColors.black;
    }
    return CupertinoColors.secondarySystemBackground;
  }

  Color navBarIconActiveColor() {
    if (darkMode) {
      return CupertinoColors.white;
    }
    return CupertinoColors.black;
  }

  Color primaryColor() {
    if (darkMode) {
      return CupertinoColors.systemBlue;
    }
    return CupertinoColors.systemBlue;
  }

  Color seedColorColor() {
    if (darkMode) {
      return CupertinoColors.activeBlue;
    }
    return CupertinoColors.activeBlue;
  }

  Brightness getBrightness() {
    if (darkMode) {
      return Brightness.dark;
    }
    return Brightness.light;
  }

  Color diceColor() {
    if (darkMode) {
      return CupertinoColors.secondarySystemBackground;
    }
    return CupertinoColors.darkBackgroundGray;
  }

  Color cellColor() {
    if (darkMode) {
      return Colors.black54;
    }
    return Colors.blue.shade50;
  }

  Color placeHolders() {
    if (darkMode) {
      return CupertinoColors.darkBackgroundGray.withAlpha(123);
    }
    return CupertinoColors.extraLightBackgroundGray;
  }

  Color playerCell(String key) {
    /// "s" for same cell, "f" for female, "m" for male
    if (darkMode) {
      switch (key) {
        case "s":
          return Colors.blue.shade900;
        case "m":
          return Colors.pink.shade900;
        case "f":
          return Colors.purple.shade900;
      }
    } else {
      switch (key) {
        case "s":
          return Colors.blue.shade100;
        case "m":
          return Colors.pink.shade100;
        case "f":
          return Colors.purple.shade100;
      }
    }
    return Colors.transparent;
  }

  Color playerIcons(String key) {
    /// "s" for same cell, "f" for female, "m" for male
    if (darkMode) {
      switch (key) {
        case "s":
          return Colors.blue.shade100;
        case "m":
          return Colors.pink.shade100;
        case "f":
          return Colors.purple.shade100;
      }
    } else {
      switch (key) {
        case "s":
          return Colors.blue.shade900;
        case "m":
          return Colors.pink.shade900;
        case "f":
          return Colors.purple.shade900;
      }
    }
    return Colors.red.shade900;
  }

  Color scratchCard() {
    if (darkMode) {
      return CupertinoColors.inactiveGray;
    }
    return CupertinoColors.systemGrey5;
  }

  List<List<Color>> getGradients() {
    if (darkMode) {
      return [
        [
          CupertinoColors.activeBlue.withOpacity(0.1),
          CupertinoColors.darkBackgroundGray
        ],
        [
          CupertinoColors.systemPurple,
          CupertinoColors.black,
        ],
      ];
    }
    return [
      [CupertinoColors.activeBlue, CupertinoColors.secondarySystemBackground],
      [
        CupertinoColors.systemPurple,
        CupertinoColors.extraLightBackgroundGray,
      ],
    ];
  }

  Color lodingColor() {
    if (darkMode) {
      return CupertinoColors.activeBlue;
    }
    return Colors.black;
  }

  Color taskCard() {
    if (darkMode) {
      return CupertinoColors.darkBackgroundGray;
    }
    return CupertinoColors.extraLightBackgroundGray;
  }
}
