import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curve/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  List<Map<String, String>> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ScrollController scrollController = ScrollController();
  StreamSubscription? _chatSubscription;

  // REPLACE WITH YOUR GEMINI API KEY
  static const String _apiKey = "AIzaSyCmsMcSqtuMAn6_u5ueXZj-Bu6oRLmCayw";
  static const String _modelId =
      "gemini-3-flash-preview"; // Using stable model, or use "gemini-2.0-flash-thinking-exp" if available to you
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/$_modelId:generateContent";
  static const String _systemInstruction = """
  You are Eve, the AI companion for the EvesDrops app. 
  Your area of expertise is intimacy, romantic relationships, sexual wellness, conflict resolution, and emotional connection.
  
  Guidelines:
  1. Be empathetic, non-judgmental, and open-minded.
  2. Provide advice based on healthy communication and consent.
  3. Suggest activities from the EvesDrops app (like the 4 Cards game or Intimacy Maze) when relevant.
  4. If a user asks about medical issues, advise them to see a doctor.
  5. Keep answers concise but warm.
  6. Exclude any thing outside the topic of intimacy and relationships, such as politics, sports, or general trivia.
  """;

  ChatProvider() {
    _loadHistory();
  }

  void _loadHistory() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _chatSubscription?.cancel();
    _chatSubscription =
        DatabaseService().getChatHistory(userId).listen((snapshot) {
      _messages.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        _messages.add({
          'role': data['role'] ?? 'user',
          'text': data['message'] ?? '',
        });
      }
      notifyListeners();
      // Scroll to bottom after loading history
      Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Optimistic Update (Show immediately)
    // Note: Since we listen to the stream, it might duplicate if we add locally + stream updates.
    // The stream is the source of truth, so we just log to DB.
    // However, to show "Loading..." indicator, we set flag.

    _isLoading = true;
    notifyListeners();
    _scrollToBottom();

    // 1. Log User Message to DB (Stream will update UI)
    if (userId != null) {
      await DatabaseService().logChatMessage(userId, 'user', text);
    }

    try {
      final url = Uri.parse("$_baseUrl?key=$_apiKey");

      // Construct context from last 10 messages to save tokens
      int start = (_messages.length > 10) ? _messages.length - 10 : 0;
      List<Map<String, dynamic>> contents = _messages.sublist(start).map((m) {
        return {
          "role": m['role'] == 'user' ? 'user' : 'model',
          "parts": [
            {"text": m['text']}
          ]
        };
      }).toList();

      // Add current message if not yet in stream/list (it usually isn't instantly)
      if (contents.isEmpty || contents.last['parts'][0]['text'] != text) {
        contents.add({
          "role": "user",
          "parts": [
            {"text": text}
          ]
        });
      }

      final body = jsonEncode({
        "contents": contents,
        "systemInstruction": {
          "parts": [
            {"text": _systemInstruction}
          ]
        },
        "generationConfig": {"temperature": 0.7, "maxOutputTokens": 800},
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse =
            data['candidates'][0]['content']['parts'][0]['text'];

        // 2. Log AI Response to DB (Stream will update UI)
        if (userId != null) {
          await DatabaseService().logChatMessage(userId, 'model', aiResponse);
        }
      } else {
        print("API Error: ${response.body}");
        // Optional: Show error in UI
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void clearChat() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Get all docs and delete them
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chat_history')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
    _messages.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}
