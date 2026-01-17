import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<DocumentSnapshot>? _gameStream;

  // --- GAME CONFIGURATION ---
  static const List<int> trapCells = [4, 13, 21, 29];
  static const List<int> bonusCells = [6, 11, 18, 25];

  // Game State
  String? roomId;
  bool isMultiplayer = false;
  bool isHost = false;
  String status = 'idle'; // 'idle', 'waiting', 'playing', 'finished'

  int player1Position = 1;
  int player2Position = 1;
  int currentPlayer = 1;

  int p1Score = 0;
  int p2Score = 0;

  String task = "Welcome! Create, Join, or Play Offline.";
  String specialEvent = "";

  // To lock UI during animation
  bool isAnimating = false;

  bool get isMyTurn {
    if (isAnimating) return false; // Lock interactions while moving
    if (!isMultiplayer) return true;
    if (status != 'playing') return false;
    if (isHost && currentPlayer == 1) return true;
    if (!isHost && currentPlayer == 2) return true;
    return false;
  }

  // ... (OFFLINE/ONLINE LOBBY METHODS REMAIN THE SAME) ...
  // Paste startOfflineGame, createGame, joinGame, _listenToGame, resetStateValues, reset from previous code here.
  // I will include them briefly to ensure file completeness.

  void startOfflineGame() {
    reset();
    isMultiplayer = false;
    roomId = "OFFLINE";
    status = 'playing';
    task = "Player 1 (Male) Start! Roll the dice.";
    notifyListeners();
  }

  Future<String> createGame() async {
    isMultiplayer = true;
    isHost = true;
    resetStateValues();
    roomId = (Random().nextInt(900000) + 100000).toString();
    try {
      await _firestore.collection('games').doc(roomId).set({
        'roomId': roomId,
        'player1Id': _auth.currentUser?.uid,
        'player2Id': null,
        'player1Position': 1,
        'player2Position': 1,
        'p1Score': 0,
        'p2Score': 0,
        'currentPlayer': 1,
        'task': "Waiting for partner...",
        'specialEvent': "",
        'status': 'waiting',
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

  Future<void> joinGame(String inputCode) async {
    final docRef = _firestore.collection('games').doc(inputCode);
    final doc = await docRef.get();
    if (!doc.exists) throw Exception("Room not found");
    roomId = inputCode;
    isMultiplayer = true;
    isHost = false;
    await docRef.update({
      'player2Id': _auth.currentUser?.uid,
      'status': 'playing',
      'task': "Player 2 Joined! Player 1, roll the dice.",
    });
    _listenToGame();
  }

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

        // Only update positions from stream if NOT currently animating locally
        // This prevents jitter for the person rolling the dice
        if (!isAnimating) {
          player1Position = data['player1Position'];
          player2Position = data['player2Position'];
          p1Score = data['p1Score'] ?? 0;
          p2Score = data['p2Score'] ?? 0;
          currentPlayer = data['currentPlayer'];
          task = data['task'];
          status = data['status'];
          specialEvent = data['specialEvent'] ?? "";
          notifyListeners();
        }
      }
    });
  }

  void resetStateValues() {
    player1Position = 1;
    player2Position = 1;
    p1Score = 0;
    p2Score = 0;
    currentPlayer = 1;
    specialEvent = "";
    isAnimating = false;
  }

  void reset() {
    _gameStream?.cancel();
    roomId = null;
    isMultiplayer = false;
    status = 'idle';
    resetStateValues();
    task = "Game Reset.";
    notifyListeners();
  }

  // --- ANIMATED GAMEPLAY LOGIC ---

  Future<void> advancePlayer(int steps, Map<int, List<String>> mazeData) async {
    if (status == 'finished') return;

    isAnimating = true; // Lock UI
    notifyListeners();

    bool isP1Turn = (currentPlayer == 1);
    int currentPos = isP1Turn ? player1Position : player2Position;

    // 1. ANIMATE FORWARD STEP-BY-STEP
    for (int i = 0; i < steps; i++) {
      currentPos++;

      // Stop at 30
      if (currentPos >= 30) {
        currentPos = 30;
        _updatePositionLocally(isP1Turn, currentPos);
        await Future.delayed(const Duration(milliseconds: 400));
        break;
      }

      _updatePositionLocally(isP1Turn, currentPos);
      await Future.delayed(
          const Duration(milliseconds: 400)); // Smooth step duration
    }

    // 2. CHECK GAME OVER (Reached 30)
    if (currentPos == 30) {
      await _handleGameOver(isP1Turn);
      isAnimating = false;
      notifyListeners();
      return;
    }

    String eventMsg = "";
    int pointsEarned = steps;

    // 3. CHECK LOGIC (Traps/Bonus) at final landing spot

    if (trapCells.contains(currentPos)) {
      // 3.1 ANIMATE BACKWARDS
      eventMsg = "⚠️ TRAP! Moving back 3 spaces...";
      specialEvent = eventMsg;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1)); // Read msg

      for (int i = 0; i < 3; i++) {
        currentPos--;
        if (currentPos < 1) currentPos = 1;
        _updatePositionLocally(isP1Turn, currentPos);
        await Future.delayed(const Duration(milliseconds: 400));
      }
      pointsEarned -= 5;
    } else if (bonusCells.contains(currentPos)) {
      eventMsg = "🌟 BONUS CELL! +20 Points!";
      pointsEarned += 20;
    }

    // Update Scores
    if (isP1Turn)
      p1Score += pointsEarned;
    else
      p2Score += pointsEarned;
    if (p1Score < 0) p1Score = 0;
    if (p2Score < 0) p2Score = 0;

    // Generate Task
    String newTask = "";
    int otherPlayerPos = isP1Turn ? player2Position : player1Position;
    bool collision = (currentPos == otherPlayerPos) && (currentPos != 1);

    if (collision) {
      newTask = "💞 COLLISION! Kiss passionately for 10 seconds. (+50 pts)";
      if (isP1Turn)
        p1Score += 50;
      else
        p2Score += 50;
      eventMsg = "💞 LOVE COLLISION!";
    } else {
      List<String>? cellTasks = mazeData[currentPos];
      if (cellTasks != null && cellTasks.isNotEmpty) {
        String baseAction = cellTasks[Random().nextInt(cellTasks.length)];
        String actor = isP1Turn ? "Male" : "Female";
        String receiver = isP1Turn ? "Female" : "Male";
        newTask = "$actor Turn: Perform '$baseAction' on $receiver.";
      } else {
        newTask = "Safe spot. Relax.";
      }
    }

    specialEvent = eventMsg;
    currentPlayer = isP1Turn ? 2 : 1;
    task = newTask;
    isAnimating = false;

    notifyListeners();

    // 4. SYNC TO CLOUD (Once at the end of animation)
    if (isMultiplayer && roomId != "OFFLINE") {
      await _syncToFirebase(isP1Turn, currentPos);
    }
  }

  void _updatePositionLocally(bool isP1, int pos) {
    if (isP1)
      player1Position = pos;
    else
      player2Position = pos;
    notifyListeners();
  }

  Future<void> _handleGameOver(bool isP1Winner) async {
    status = 'finished';

    // Give completion bonus
    if (isP1Winner)
      p1Score += 30;
    else
      p2Score += 30;

    String winner =
        p1Score > p2Score ? "Male" : (p2Score > p1Score ? "Female" : "Tie");
    task = "GAME OVER! $winner Wins!";

    if (isMultiplayer && roomId != "OFFLINE") {
      await _firestore.collection('games').doc(roomId).update({
        'status': 'finished',
        'task': task,
        'p1Score': p1Score,
        'p2Score': p2Score,
        'player1Position': player1Position,
        'player2Position': player2Position,
      });
    }
  }

  Future<void> _syncToFirebase(bool isP1Turn, int pos) async {
    Map<String, dynamic> updates = {
      'currentPlayer': currentPlayer,
      'task': task,
      'specialEvent': specialEvent,
      'p1Score': p1Score,
      'p2Score': p2Score,
    };
    if (isP1Turn)
      updates['player1Position'] = pos;
    else
      updates['player2Position'] = pos;

    await _firestore.collection('games').doc(roomId).update(updates);
  }
}
