import 'package:curve/api/urls.dart';
import 'package:curve/models/learn_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LearnProvider extends ChangeNotifier {
  LearnProvider() {
    getArticles();
  }
  List<Article> articles = [];
  void getArticles() async {
    final Uri url = Uri.parse(APIUrls.ARTICLES);

    try {
      // Sending the GET request
      final response =
          await http.get(url, headers: {'accept': 'application/json'});

      // Checking if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the response body
        var data = jsonDecode(response.body);
        articles = List<Article>.from(
            data.map((article) => Article.fromJson(article)).toList());
        articles.sort((a, b) => a.id.compareTo(b.id));
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> getArticle(Article article) async {
    final Uri url = Uri.parse(APIUrls.SECTION_READINGS(article.id));
    try {
      // Sending the GET request
      final response =
          await http.get(url, headers: {'accept': 'application/json'});

      // Checking if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // If successful, parse the response body
        var data = jsonDecode(response.body);
        article.sections = List<SectionsReadings>.from(
            data.map((section) => SectionsReadings.fromJson(section)).toList());
            notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
    return false;
  }
}
