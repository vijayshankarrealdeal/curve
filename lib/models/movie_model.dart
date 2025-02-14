class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  // Optional fields
  final String? rated;
  final String? released;
  final String? runtime;
  final String? genre;
  final String? director;
  final String? writer;
  final String? actors;
  final String? plot;
  final String? language;
  final String? country;
  final String? awards;
  final List<Map<String, String>>? ratings;
  final String? metascore;
  final String? imdbRating;
  final String? imdbVotes;
  final String? dvd;
  final String? boxOffice;
  final String? production;
  final String? website;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.ratings,
    this.metascore,
    this.imdbRating,
    this.imdbVotes,
    this.dvd,
    this.boxOffice,
    this.production,
    this.website,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
      rated: json['Rated'],
      released: json['Released'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      director: json['Director'],
      writer: json['Writer'],
      actors: json['Actors'],
      plot: json['Plot'],
      language: json['Language'],
      country: json['Country'],
      awards: json['Awards'],
      ratings: (json['Ratings'] as List?)?.map((e) => Map<String, String>.from(e)).toList(),
      metascore: json['Metascore'],
      imdbRating: json['imdbRating'],
      imdbVotes: json['imdbVotes'],
      dvd: json['DVD'],
      boxOffice: json['BoxOffice'],
      production: json['Production'],
      website: json['Website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'imdbID': imdbID,
      'Type': type,
      'Poster': poster,
      if (rated != null) 'Rated': rated,
      if (released != null) 'Released': released,
      if (runtime != null) 'Runtime': runtime,
      if (genre != null) 'Genre': genre,
      if (director != null) 'Director': director,
      if (writer != null) 'Writer': writer,
      if (actors != null) 'Actors': actors,
      if (plot != null) 'Plot': plot,
      if (language != null) 'Language': language,
      if (country != null) 'Country': country,
      if (awards != null) 'Awards': awards,
      if (ratings != null) 'Ratings': ratings,
      if (metascore != null) 'Metascore': metascore,
      if (imdbRating != null) 'imdbRating': imdbRating,
      if (imdbVotes != null) 'imdbVotes': imdbVotes,
      if (dvd != null) 'DVD': dvd,
      if (boxOffice != null) 'BoxOffice': boxOffice,
      if (production != null) 'Production': production,
      if (website != null) 'Website': website,
    };
  }
}
