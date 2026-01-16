import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curve/logs/grid_tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<DocumentSnapshot>? _gameStream;

  // Game State
  String? roomId;
  bool isMultiplayer = false;
  bool isHost = false; // Player 1
  String status = 'idle'; // idle, waiting, playing

  int player1Position = 1;
  int player2Position = 1;
  int currentPlayer = 1; // 1 or 2
  String task = "Welcome! Create or Join a game to start.";

  // Local helper to know if it's "my" turn
  bool get isMyTurn {
    if (!isMultiplayer) return true; // Offline mode (if you want to keep it)
    if (status != 'playing') return false;
    if (isHost && currentPlayer == 1) return true;
    if (!isHost && currentPlayer == 2) return true;
    return false;
  }

  // --- 1. LOBBY LOGIC ---

  // Host creates a game
  Future<String> createGame() async {
    isMultiplayer = true;
    isHost = true;
    player1Position = 1;
    player2Position = 1;
    currentPlayer = 1;

    // Generate a simple 6-digit code
    roomId = (Random().nextInt(900000) + 100000).toString();

    try {
      await _firestore.collection('games').doc(roomId).set({
        'roomId': roomId,
        'player1Id': _auth.currentUser?.uid,
        'player2Id': null,
        'player1Position': 1,
        'player2Position': 1,
        'currentPlayer': 1,
        'task': "Waiting for player to join...",
        'status': 'waiting', // waiting for p2
        'lastDiceValue': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _listenToGame();
      return roomId!;
    } catch (e) {
      isMultiplayer = false;
      throw Exception("Failed to create game: $e");
    }
  }

  // Guest joins a game
  Future<void> joinGame(String inputCode) async {
    final docRef = _firestore.collection('games').doc(inputCode);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw Exception("Room not found");
    }

    final data = doc.data() as Map<String, dynamic>;
    if (data['status'] == 'playing') {
      // Simple check if full
      // You could check if player2Id is already set
      if (data['player2Id'] != null &&
          data['player2Id'] != _auth.currentUser?.uid) {
        throw Exception("Room is full");
      }
    }

    // Join
    roomId = inputCode;
    isMultiplayer = true;
    isHost = false; // Player 2

    await docRef.update({
      'player2Id': _auth.currentUser?.uid,
      'status': 'playing',
      'task': "Player 2 Joined! Player 1, roll the dice.",
    });

    _listenToGame();
  }

  // Listen to Firestore changes
  void _listenToGame() {
    if (roomId == null) return;

    _gameStream?.cancel();
    _gameStream = _firestore
        .collection('games')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        player1Position = data['player1Position'];
        player2Position = data['player2Position'];
        currentPlayer = data['currentPlayer'];
        task = data['task'];
        status = data['status'];

        notifyListeners();
      }
    });
  }

  // Leave/Reset
  void reset() {
    // If multiplayer, maybe delete room or remove player?
    // For now, just reset local state and stop listening
    _gameStream?.cancel();
    roomId = null;
    isMultiplayer = false;
    status = 'idle';
    player1Position = 1;
    player2Position = 1;
    currentPlayer = 1;
    task = "Game Reset.";
    notifyListeners();
  }

  // --- 2. GAMEPLAY LOGIC ---

  Future<void> advancePlayer(int steps) async {
    if (!isMultiplayer) return; // Handle offline logic separately if needed
    if (!isMyTurn) return; // Security check

    int newPos;
    if (isHost) {
      // Player 1
      newPos = player1Position + steps;
      if (newPos > 30) newPos = 30;
    } else {
      // Player 2
      newPos = player2Position + steps;
      if (newPos > 30) newPos = 30;
    }

    String newTask = "";
    int nextPlayer = (currentPlayer == 1) ? 2 : 1;

    // Check Collision (Logic from your original code)
    // Note: We use the local 'newPos' against the 'other' player's current DB pos
    int otherPlayerPos = isHost ? player2Position : player1Position;

    bool collision = (newPos == otherPlayerPos) && (newPos != 1);

    if (collision) {
      newTask =
          "Let your eyes meet and then let your tongue slide over their lips.";
      // Special rule: collision usually knocks someone back or keeps them together.
      // Your original logic kept them together.
    } else {
      // Generate Task
      List<String>? cellTasks = gridCells[newPos];
      if (cellTasks != null && cellTasks.isNotEmpty) {
        String text = cellTasks[Random().nextInt(cellTasks.length)];
        String gender = isHost ? "Male" : "Female"; // Or strictly P1/P2 logic
        // P1 moves -> generates task for P1
        // Using your helper function:
        Map<int, String> msgs = generateTaskMessages(gender, text);
        newTask = msgs[newPos] ?? text;
      } else {
        newTask = "Rest and enjoy the moment.";
      }
    }

    // Update Firestore
    Map<String, dynamic> updates = {
      'currentPlayer': nextPlayer,
      'task': newTask,
      'lastDiceValue': steps,
    };

    if (isHost) {
      updates['player1Position'] = newPos;
    } else {
      updates['player2Position'] = newPos;
    }

    await _firestore.collection('games').doc(roomId).update(updates);
  }
}
