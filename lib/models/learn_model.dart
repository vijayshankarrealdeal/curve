class Article {
  final int id;
  final String title;
  final String introduction;
  final String conclusion;
  final int sectionsCount;
  List<SectionsReadings> sections = [];

  // Constructor with a default value for sections
  Article({
    required this.id,
    required this.title,
    required this.introduction,
    required this.conclusion,
    required this.sectionsCount,
    this.sections = const [],
  });

  // Factory constructor to create an Article instance from a JSON object
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      introduction: json['introduction'],
      conclusion: json['conclusion'],
      sectionsCount: json['sections_count'],
    );
  }

  // Method to convert an Article instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'introduction': introduction,
      'conclusion': conclusion,
      'sections_count': sectionsCount,
    };
  }
}

class SectionsReadings {
  final int id;
  final String heading;
  final String content;
  final int articleId;

  SectionsReadings({
    required this.id,
    required this.heading,
    required this.content,
    required this.articleId,
  });

  factory SectionsReadings.fromJson(Map<String, dynamic> json) {
    return SectionsReadings(
      id: json['id'] as int,
      heading: json['heading'] as String,
      content: json['content'] as String,
      articleId: json['article_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heading': heading,
      'content': content,
      'article_id': articleId,
    };
  }
}
