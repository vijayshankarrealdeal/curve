import 'dart:math';

import 'package:curve/logs/grid_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  int player1Position = 1; // We'll treat these as 1-based board positions.
  int player2Position = 1;
  int currentPlayer = 1; // 1 or 2
  static List<String> starterTasks = [
    "Look deeply into each other's eyes and silently communicate your feelings.",
    "Synchronize your breathing, inhaling and exhaling together for a few moments.",
    "Give your partner a gentle, affirming touch that communicates appreciation.",
    "Whisper a simple desire or something you find attractive about your partner into their ear.",
    "Tell your partner what you admire about them the most, and hold their hand.",
    "Gently caress your partner’s arm, back or neck with soft, slow movements.",
    "Give a tender kiss to any body part that you find appealing.",
    "Share a cherished memory with your partner, focusing on the emotional connection.",
    "Tell your partner what is your favorite feature on their body",
    "Share 3 things you love about the other person",
  ];
  String task = "Before Rolling Dice: ${starterTasks[0]}";
  void reset() {
    player1Position = 1; // We'll treat these as 1-based board positions.
    player2Position = 1;
    currentPlayer = 1; // 1 or 2
    task =
        "Before Rolling Dice: ${starterTasks[Random().nextInt(starterTasks.length)]}";
    notifyListeners();
  }

  // Asynchronously move the current player step-by-step
  Future<void> advancePlayer(int steps) async {
    if ((player1Position == 30) || (player2Position == 30)) {
      return;
    }

    for (int i = 0; i < steps; i++) {
      if (currentPlayer == 1) {
        player1Position++;
        if (player1Position > 30) player1Position = 30;
      } else {
        player2Position++;
        if (player2Position > 30) player2Position = 30;
      }

      notifyListeners();
      // Wait a bit to simulate sliding (step-by-step movement)
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // After finishing movement, check for collision
    if (player1Position == player2Position && player1Position != 1) {
      // Both players on same cell, knock out the occupant
      // The occupant is considered the player who was there first.
      // For simplicity: The newly arrived player knocks out the other.
      // Which player arrived last? The current player just moved, so they are the "arriver".
      // The other player gets knocked back to start:
      // Kiss each other looking into the eyes.
      task =
          "Let your eyes meet and then let your tongue slide over their lips.";
      notifyListeners();
    } else {
      String text = gridCells[player1Position]![Random().nextInt(4)];
      if (player1Position > player2Position) {
        task = generateTaskMessages("Male", text)[player1Position] ?? "";
        notifyListeners();
      } else {
        task = generateTaskMessages("Female", text)[player2Position] ?? "";
        notifyListeners();
      }
    }
    // Switch player turn
    currentPlayer = (currentPlayer == 1) ? 2 : 1;
    notifyListeners();
  }
}
