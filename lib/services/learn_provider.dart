import 'package:curve/models/learn_model.dart';
import 'package:curve/services/db.dart';
import 'package:flutter/material.dart';

class LearnProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  // Initialize with fallback articles IMMEDIATELY so the UI is never blank/loading
  List<Article> articles = _fallbackArticles;

  // Default to false so we show content right away
  bool isLoading = false;

  LearnProvider() {
    getArticles();
  }

  Future<void> getArticles() async {
    // We do NOT set isLoading = true here.
    // We want the user to read the default content while we check the DB in the background.

    try {
      // Try to fetch from DB with a timeout to prevent infinite hanging
      List<Article> fetchedArticles = await _db.getArticles().timeout(
            const Duration(seconds: 5),
            onTimeout: () => [], // If it takes too long, just return empty
          );

      if (fetchedArticles.isNotEmpty) {
        articles = fetchedArticles;
        articles.sort((a, b) => a.id.compareTo(b.id));
        notifyListeners(); // Only update UI if we actually found new data
      }
    } catch (e) {
      print('Using offline content (DB Error: $e)');
      // No need to do anything, we already have the fallback articles loaded.
    }
  }

  Future<bool> getArticle(Article article) async {
    // If sections are already loaded (like in fallback data), return true immediately
    if (article.sections.isNotEmpty) return true;

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

  // --- HARDCODED CONTENT FOR HEALTHY INTIMACY ---
  // Static so it can be used for initialization
  static final List<Article> _fallbackArticles = [
    Article(
      id: 1,
      title: "The Art of Aftercare",
      introduction:
          "Intimacy doesn't end when the physical act does. Aftercare is the practice of attending to your partner's emotional and physical needs after sexual activity. It fosters safety, trust, and deeper connection.",
      conclusion:
          "Prioritizing aftercare shows your partner they are valued beyond just the physical pleasure, building a resilient and loving bond.",
      sectionsCount: 3,
      sections: [
        SectionsReadings(
          id: 101,
          articleId: 1,
          heading: "1. Physical Comfort",
          content:
              "### Physical Reconnection\n\nAfter high-energy or intense intimacy, the body needs to regulate. Offer:\n\n*   **Hydration:** Bring a glass of water.\n*   **Warmth:** Pull up the blankets or offer a cuddle.\n*   **Touch:** Gentle stroking of hair or back can help the nervous system calm down.",
        ),
        SectionsReadings(
          id: 102,
          articleId: 1,
          heading: "2. Emotional Check-in",
          content:
              "### Checking In\n\nAsk simple, open-ended questions to gauge how they are feeling:\n\n*   \"How are you feeling right now?\"\n*   \"Is there anything you need from me?\"\n*   \"What was your favorite part?\"\n\nThis validates their experience and ensures no negative feelings are left unaddressed.",
        ),
        SectionsReadings(
          id: 103,
          articleId: 1,
          heading: "3. Reaffirming the Bond",
          content:
              "### Verbal Affirmation\n\nRemind your partner that you care for them. Phrases like *\"I feel so close to you\"* or *\"Thank you for sharing that with me\"* go a long way in preventing feelings of vulnerability or 'drop' (a sudden drop in mood after endorphins fade).",
        ),
      ],
    ),
    Article(
      id: 2,
      title: "Non-Sexual Intimacy",
      introduction:
          "A healthy sex life often starts outside the bedroom. Building intimacy without the expectation of sex creates a foundation of safety and desire.",
      conclusion:
          "By weaving intimacy into your daily routine, you lower the pressure around sex and increase the natural desire to connect.",
      sectionsCount: 3,
      sections: [
        SectionsReadings(
          id: 201,
          articleId: 2,
          heading: "1. The 6-Second Kiss",
          content:
              "### The 6-Second Rule\n\nRelationship researcher Dr. John Gottman suggests that a kiss lasting at least six seconds is a 'kiss with potential.' It’s long enough to stop the busyness of your brain and focus on your partner. Try this when you greet each other or say goodbye.",
        ),
        SectionsReadings(
          id: 202,
          articleId: 2,
          heading: "2. Active Listening",
          content:
              "### Eye Contact & Presence\n\nPut the phone down. When your partner speaks, look at them. Intimacy is the feeling of being *seen*. \n\n*   Ask follow-up questions.\n*   Validate their feelings (\"That sounds really stressful\") instead of immediately trying to fix the problem.",
        ),
        SectionsReadings(
          id: 203,
          articleId: 2,
          heading: "3. Non-Demand Touch",
          content:
              "### Touch without Strings\n\nTouch your partner frequently without it leading to sex. \n\n*   Hold hands while driving.\n*   Stroke their arm while watching TV.\n*   Hug for 20 seconds.\n\nThis builds 'skin hunger' and associates your touch with comfort, not just demand.",
        ),
      ],
    ),
    Article(
      id: 3,
      title: "Navigating Consent & Boundaries",
      introduction:
          "Consent isn't just a legal requirement; it's the sexiest tool in your arsenal. Enthusiastic consent means both partners are fully present, excited, and safe.",
      conclusion:
          "Boundaries are not walls; they are the guidelines that allow you to play safely and freely.",
      sectionsCount: 2,
      sections: [
        SectionsReadings(
          id: 301,
          articleId: 3,
          heading: "1. The Traffic Light System",
          content:
              "### Red, Yellow, Green\n\nUse this simple system to discuss new activities:\n\n*   **Green:** Yes! I want to try this.\n*   **Yellow:** I'm curious but hesitant. I need to go slow or talk more about it.\n*   **Red:** Hard no. I am not interested.\n\nRespecting 'Red' makes 'Green' feel much safer.",
        ),
        SectionsReadings(
          id: 302,
          articleId: 3,
          heading: "2. Checking in During Play",
          content:
              "### Continuous Consent\n\nConsent can be withdrawn at any time. Check in during the act:\n\n*   \"Do you like this?\"\n*   \"Is this pressure okay?\"\n*   \"Do you want to stop or keep going?\"\n\nThis feedback loop ensures both partners are enjoying the experience.",
        ),
      ],
    ),
    Article(
      id: 4,
      title: "Understanding Desire Types",
      introduction:
          "Not everyone feels desire the same way. Understanding if you are 'Spontaneous' or 'Responsive' can save a relationship from misunderstanding.",
      conclusion:
          "There is no 'wrong' way to feel desire. Knowing your type helps you engineer the context needed to get in the mood.",
      sectionsCount: 2,
      sections: [
        SectionsReadings(
          id: 401,
          articleId: 4,
          heading: "1. Spontaneous Desire",
          content:
              "### The 'Lightning Bolt'\n\nThis is the type of desire most people see in movies. It happens out of the blue, simply by seeing your partner or having a stray thought. Roughly 75% of men and 15% of women primarily experience this type.",
        ),
        SectionsReadings(
          id: 402,
          articleId: 4,
          heading: "2. Responsive Desire",
          content:
              "### The 'Simmering Pot'\n\nResponsive desire means arousal comes *first*, and desire follows. You might not be 'in the mood' initially, but once you start kissing or touching, your body wakes up and your mind follows. This is perfectly healthy and normal. For responsive types, waiting to be 'in the mood' might mean waiting forever—sometimes you have to start the engine to get it running.",
        ),
      ],
    ),
  ];
}
