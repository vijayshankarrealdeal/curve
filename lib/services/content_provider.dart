import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContentProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cache Storage
  List<String> truths = [];
  List<String> dares = [];
  Map<int, List<String>> fourCardsData = {};
  Map<int, List<String>> mazeData = {};
  Map<String, String>? currentScratchCard;

  bool isLoading = true;

  ContentProvider() {
    fetchAllContent();
  }

  Future<void> fetchAllContent() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _fetchTruthDare(),
        _fetchFourCards(),
        _fetchMaze(),
        _fetchScratchCard(), // NEW
      ]);
    } catch (e) {
      print("Error fetching game content: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchTruthDare() async {
    final snap = await _db
        .collection('truth_dare_tasks')
        .where('active', isEqualTo: true)
        .get();
    truths.clear();
    dares.clear();
    for (var doc in snap.docs) {
      if (doc['type'] == 'truth')
        truths.add(doc['content']);
      else
        dares.add(doc['content']);
    }
    // Fallback
    if (truths.isEmpty) truths = ["What is your biggest fear?"];
    if (dares.isEmpty) dares = ["Do 10 pushups."];
  }

  Future<void> _fetchFourCards() async {
    final snap = await _db
        .collection('four_cards_tasks')
        .where('active', isEqualTo: true)
        .get();
    fourCardsData.clear();
    for (var doc in snap.docs) {
      int catId = doc['category_id'];
      String content = doc['content'];
      if (!fourCardsData.containsKey(catId)) fourCardsData[catId] = [];
      fourCardsData[catId]!.add(content);
    }
  }

  Future<void> _fetchMaze() async {
    final snap = await _db.collection('maze_tasks').get();
    mazeData.clear();
    for (var doc in snap.docs) {
      int cellId = int.parse(doc.id);
      List<dynamic> rawActions = doc['actions'];
      mazeData[cellId] = rawActions.cast<String>();
    }
  }

  // NEW METHOD
  Future<void> _fetchScratchCard() async {
    try {
      final snap = await _db
          .collection('daily_scratch_cards')
          .where('active', isEqualTo: true)
          .get();

      if (snap.docs.isNotEmpty) {
        // Pick random card
        var doc = snap.docs[Random().nextInt(snap.docs.length)];

        // Safely cast fields
        currentScratchCard = {
          'image':
              (doc.data().containsKey('image_url')) ? doc['image_url'] : "",
          'title': (doc.data().containsKey('title'))
              ? doc['title']
              : "Daily Insight",
          'desc': (doc.data().containsKey('description'))
              ? doc['description']
              : "Enjoy the moment.",
        };
      } else {
        // Fallback Data if collection empty
        currentScratchCard = {
          'image':
              "https://i.pinimg.com/736x/87/4a/74/874a7481bbe0cab8f51827722dde96ec.jpg",
          'title': "Connection",
          'desc':
              "A hug lasting 20 seconds releases oxytocin, reducing stress and boosting connection.",
        };
      }
    } catch (e) {
      print("Error fetching scratch card: $e");
      // Fallback on error
      currentScratchCard = {
        'image':
            "https://i.pinimg.com/736x/87/4a/74/874a7481bbe0cab8f51827722dde96ec.jpg",
        'title': "Connection",
        'desc':
            "A hug lasting 20 seconds releases oxytocin, reducing stress and boosting connection.",
      };
    }
  }
}
