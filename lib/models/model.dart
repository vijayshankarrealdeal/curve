import 'package:flutter/cupertino.dart';

class AppCardsHome {
  final Color cardColor;
  final String title;
  final Color textColor;
  IconData iconAdd;
  String extraIcon;
  Color iconColor;

  AppCardsHome({
    required this.cardColor,
    required this.title,
    required this.textColor,
    this.iconAdd = CupertinoIcons.add_circled,
    this.iconColor = CupertinoColors.white,
    this.extraIcon = "",
  });
}
