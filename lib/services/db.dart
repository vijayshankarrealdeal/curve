import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curve/models/learn_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Management ---
  /// Creates a user document if it doesn't exist, or updates last_login if it does.
  Future<void> createUser(String uid, String email) async {
    try {
      final userDoc = _db.collection('users').doc(uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create new user document
        await userDoc.set({
          'uid': uid,
          'email': email,
          'created_at': FieldValue.serverTimestamp(),
          'last_login': FieldValue.serverTimestamp(),
          // Add default settings or other fields here if needed
        });
      } else {
        // User exists, update last_login
        await userDoc.update({
          'last_login': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error creating/updating user in Firestore: $e");
      // Decide if you want to throw exception to block auth or just log it
      throw Exception("Failed to save user data.");
    }
  }

  // --- Feedback ---
  Future<void> addFeedback({
    required double rating,
    required bool? isEasyToUnderstand,
    required String improvementSuggestion,
    required String favoriteFeature,
    required String additionalFeedback,
    required String userId,
  }) async {
    try {
      await _db.collection('feedback').add({
        'rating': rating,
        'is_easy_to_understand': isEasyToUnderstand,
        'improvement_suggestion': improvementSuggestion,
        'favorite_feature': favoriteFeature,
        'additional_feedback': additionalFeedback,
        'user_id': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding feedback: $e");
      throw Exception(e);
    }
  }

  // --- Learn Content (Articles) ---
  Future<List<Article>> getArticles() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection('articles').orderBy('id').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // If your JSON model expects 'id' to be an int, ensure Firestore stores it as number
        return Article.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error getting articles: $e");
      return [];
    }
  }

  // --- Learn Content (Sections) ---
  Future<List<SectionsReadings>> getSections(int articleId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('sections')
          .where('article_id', isEqualTo: articleId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SectionsReadings.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error getting sections: $e");
      return [];
    }
  }
}
