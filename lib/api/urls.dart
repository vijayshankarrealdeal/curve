class APIUrls {
  static const String BASE_URL = "https://sample-e1mp.onrender.com";
  static const String LOGIN = "$BASE_URL/user/login";
  static const String REGISTER = "$BASE_URL/user/register";
  static const String ARTICLES = "$BASE_URL/learn/get_articles";
  static String SECTIONS(articleID) =>
      "$BASE_URL/learn/get_section?article_id=$articleID";
  static String SECTION_READINGS(int article_id) =>
      "$BASE_URL/learn/get_section?article_id=$article_id";
}
