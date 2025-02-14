import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  final _supabase = Supabase.instance.client;

  Future<void> addVisitCount() async {
    try {
      final response = await _supabase.from("curve").select();
      int count = response.first['count'] + 1;
      await _supabase.from("curve").update({"count": count + 1}).eq('id', 1);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addFeedback(rating, easyToUnderstand, improvementSuggestion,
      favoriteFeature, additionalFeedback) async {
    try {
      await _supabase.from("curve_feedback").insert({
        "star_rating": rating,
        "easy": easyToUnderstand,
        "feature": favoriteFeature,
        "improvement": improvementSuggestion,
        "add_feedback": additionalFeedback
      });
    } catch (e) {
      Exception(e);
    }
  }
}
