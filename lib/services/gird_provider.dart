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
  bool isHost = false; // Player 1 (Male usually)
  String status = 'idle'; 

  int player1Position = 1;
  int player2Position = 1;
  int currentPlayer = 1; // 1 (Male/Host) or 2 (Female/Guest)
  
  // Scoring
  int p1Score = 0;
  int p2Score = 0;

  String task = "Welcome! Create, Join, or Play Offline.";
  String specialEvent = ""; // To show snacks for traps/bonus

  bool get isMyTurn {
    if (!isMultiplayer) return true; // Always true in offline (pass and play)
    if (status != 'playing') return false;
    if (isHost && currentPlayer == 1) return true;
    if (!isHost && currentPlayer == 2) return true;
    return false;
  }

  // --- OFFLINE MODE ---
  void startOfflineGame() {
    reset();
    isMultiplayer = false;
    roomId = "OFFLINE";
    status = 'playing';
    task = "Player 1 (Male) Start! Roll the dice.";
    notifyListeners();
  }

  // --- ONLINE LOBBY LOGIC ---

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
    isHost = false; // Player 2

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
    _gameStream = _firestore.collection('games').doc(roomId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
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
    });
  }

  void resetStateValues() {
    player1Position = 1;
    player2Position = 1;
    p1Score = 0;
    p2Score = 0;
    currentPlayer = 1;
    specialEvent = "";
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

  // --- GAMEPLAY LOGIC (Online & Offline) ---

  Future<void> advancePlayer(int steps) async {
    // Determine who is moving
    // In Offline: currentPlayer tracks turn. In Online: same logic.
    bool isP1Turn = (currentPlayer == 1);

    int currentPos = isP1Turn ? player1Position : player2Position;
    int newPos = currentPos + steps;
    
    // Cap at 30
    if (newPos > 30) newPos = 30;

    String eventMsg = "";
    int pointsEarned = steps; // Base points = dice roll

    // --- RULES & TRAPS ---
    
    // 1. TRAP: Multiples of 7 (7, 14, 21, 28) -> Go Back 3 spaces
    if (newPos % 7 == 0 && newPos != 0) {
      newPos = (newPos - 3 < 1) ? 1 : newPos - 3;
      eventMsg = "⚠️ TRAP! Moved back 3 spaces!";
      pointsEarned -= 5; // Penalty
    }
    // 2. BONUS: Multiples of 5 (5, 10, 15, 20, 25, 30) -> +20 Points
    else if (newPos % 5 == 0 && newPos != 0) {
      eventMsg = "🌟 BONUS CELL! +20 Points!";
      pointsEarned += 20;
    }

    // Update Score
    if (isP1Turn) p1Score += pointsEarned;
    else p2Score += pointsEarned;
    
    if (p1Score < 0) p1Score = 0;
    if (p2Score < 0) p2Score = 0;

    // --- TASK GENERATION ---
    String newTask = "";
    
    // Collision Logic (Super Bonus)
    int otherPlayerPos = isP1Turn ? player2Position : player1Position;
    bool collision = (newPos == otherPlayerPos) && (newPos != 1);

    if (collision) {
      newTask = "💞 COLLISION! Kiss passionately for 10 seconds. (+50 pts)";
      if (isP1Turn) p1Score += 50; else p2Score += 50;
      eventMsg = "💞 LOVE COLLISION!";
    } else {
      List<String>? cellTasks = gridCells[newPos];
      if (cellTasks != null && cellTasks.isNotEmpty) {
        String baseAction = cellTasks[Random().nextInt(cellTasks.length)];
        
        // GENDER LOGIC:
        // P1 is usually Male, P2 Female (or generic partners).
        // If P1 moves, P1 does the action TO P2.
        String actor = isP1Turn ? "Male" : "Female";
        String receiver = isP1Turn ? "Female" : "Male";
        
        newTask = "$actor Turn: Perform '$baseAction' on $receiver.";
      } else {
        newTask = "Safe spot. Relax.";
      }
    }

    specialEvent = eventMsg;

    // Update Local State (for offline)
    if (isP1Turn) player1Position = newPos; else player2Position = newPos;
    currentPlayer = isP1Turn ? 2 : 1;
    task = newTask;

    notifyListeners();

    // Update Firebase (if Online)
    if (isMultiplayer && roomId != "OFFLINE") {
      Map<String, dynamic> updates = {
        'currentPlayer': currentPlayer,
        'task': task,
        'specialEvent': specialEvent,
        'lastDiceValue': steps,
        'p1Score': p1Score,
        'p2Score': p2Score,
      };
      if (isP1Turn) updates['player1Position'] = newPos;
      else updates['player2Position'] = newPos;

      await _firestore.collection('games').doc(roomId).update(updates);
    }
  }
}