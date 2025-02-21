import 'package:curve/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieApi {
  List<String> movies = [
    // Soft Romance
    "Call Me By Your Name",
    "In The Mood For Love",
    "Lost in Translation",
    "Amélie",
    "Carol",
    "A Single Man",
    "Weekend",
    "Bridgerton",
    "Portrait of a Lady on Fire",
    "Crazy Rich Asians",
    "About Time",
    "La La Land",
    "500 Days of Summer",
    "Pride & Prejudice",
    "Sleepless in Seattle",
    // Romantic & Sensual
    "Y Tu Mamá También",
    "Out of Sight",
    "The Piano",
    "Belle de Jour",
    "Mr. & Mrs. Smith",
    "Body Heat",
    "The Lover",
    "Chloe",
    // Erotic
    "Wild Orchid",
    "9 1/2 Weeks",
    "Emmanuelle",
    "Basic Instinct",
    "Secretary",
    "Below Her Mouth",
    "Love",
    "The Last Seduction",
    "The Dreamers",
    "Little Ashes",
    // Intense Desire & Eroticism
    "Fifty Shades of Grey",
    "Fifty Shades Darker",
    "Fifty Shades Freed",
    "365 Days",
    "365 Days: This Day",
    "365 Days: The Next 365 Days",
    "After",
    "After We Collided",
    "After We Fell",
    "After Ever Happy",
    "Shame",
    "Eyes Wide Shut",

    // Strong Fantasy & Sexual Exploration
    "The Handmaiden",
    "Fatal Attraction",
    "Cruel Intentions",
    "American Beauty",
    "Audition",
    "Irreversible",
    "Teorema",
    "Taxidermia",
  ];
  Future<List<Movie>> fetchMovies(String movieName) async {
    final url = Uri.parse(
        'https://www.omdbapi.com/?s=$movieName&type=movie&apikey=be5a1360');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Search'] != null) {
        return List<Movie>.from(data['Search'].map((e) => Movie.fromJson(e)));
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> fetchMovieDetails(String movieId) async {
    final url =
        Uri.parse('https://www.omdbapi.com/?i=$movieId&apikey=be5a1360');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
