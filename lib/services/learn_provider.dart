import 'package:curve/models/learn_model.dart';
import 'package:curve/services/db.dart';
import 'package:flutter/material.dart';

class LearnProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  LearnProvider() {
    getArticles();
  }

  List<Article> articles = [];
  bool isLoading = false;

  void getArticles() async {
    isLoading = true;
    // notifyListeners(); // Optional: trigger loading state in UI if needed

    try {
      List<Article> fetchedArticles = await _db.getArticles();
      articles = fetchedArticles;
      articles.sort((a, b) => a.id.compareTo(b.id));
      notifyListeners();
    } catch (e) {
      print('Error fetching articles: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getArticle(Article article) async {
    try {
      List<SectionsReadings> sections = await _db.getSections(article.id);
      article.sections = sections;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error fetching sections for article ${article.id}: $e');
      return false;
    }
  }
}
