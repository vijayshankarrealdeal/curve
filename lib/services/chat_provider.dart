import 'dart:convert';
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

  // REPLACE WITH YOUR GEMINI API KEY
  static const String _apiKey = "AIzaSyCmsMcSqtuMAn6_u5ueXZj-Bu6oRLmCayw";

  // Model settings
  static const String _modelId =
      "gemini-3-flash-preview"; // Using stable model, or use "gemini-2.0-flash-thinking-exp" if available to you
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/$_modelId:generateContent";

  // System Prompt for Specialization
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

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    // 1. Add User Message to UI
    _messages.add({'role': 'user', 'text': text});
    _isLoading = true;
    notifyListeners();
    _scrollToBottom();

    // 2. Log to Firebase
    if (userId != null) {
      DatabaseService().logChatMessage(userId, 'user', text);
    }

    try {
      // 3. Prepare API Request
      final url = Uri.parse("$_baseUrl?key=$_apiKey");

      // Construct history for context
      List<Map<String, dynamic>> contents = _messages.map((m) {
        return {
          "role": m['role'] == 'user' ? 'user' : 'model',
          "parts": [
            {"text": m['text']}
          ]
        };
      }).toList();

      // Add System Instruction (Simulated by prepending or using system_instruction field if model supports it)
      // For standard API, we often prepend it to the first message or context.
      // Here we stick to the structure you requested.

      final body = jsonEncode({
        "contents": contents,
        "systemInstruction": {
          "parts": [
            {"text": _systemInstruction}
          ]
        },
        // Using standard config. "thinkingConfig" is specific to experimental models.
        // If you have access to the preview model, uncomment the thinkingConfig.
        "generationConfig": {
          "temperature": 0.7,
          "maxOutputTokens": 800,
          // "thinkingConfig": {"thinkingLevel": "HIGH"}, // Only works with specific preview models
        },
        "tools": [
          // {"googleSearch": {}} // Uncomment if your API key tier supports search grounding
        ]
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

        // 4. Add AI Response to UI
        _messages.add({'role': 'model', 'text': aiResponse});

        // 5. Log to Firebase
        if (userId != null) {
          DatabaseService().logChatMessage(userId, 'model', aiResponse);
        }
      } else {
        _messages.add({
          'role': 'model',
          'text':
              "I'm having trouble connecting right now. (Error: ${response.statusCode})"
        });
        print("API Error: ${response.body}");
      }
    } catch (e) {
      _messages.add({
        'role': 'model',
        'text': "Something went wrong. Please check your connection."
      });
      print("Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
