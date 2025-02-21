import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  SettingsModel() {
    fill();
  }
 
  void fill() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _categories = initialCategories.map((name) {
      bool getInital = pref.getBool(name) ?? true;
      return Category(name: name, isSelected: getInital);
    }).toList();
    defautlSpeed =
        pref.getString("game_speed_limit_str") ?? "25 Question per level";
    notifyListeners();
  }

  List<Category> _categories = [];
  String defautlSpeed = "";
  List<String> gameSpeed = [
    "25 Question per level",
    "15 Question per level",
    "10 Question per level",
    "5  Question per level",
    "1  Question per level",
  ];
  void setGameSpeed(String e) async {
    defautlSpeed = e;
    notifyListeners();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("game_speed_limit_str", defautlSpeed);
  }

  List<String> initialCategories = [
    'Bondage',
    'Toys',
    'Dominance/Submission',
    'Oral',
    'Spanking',
    'Food',
    'Teasing/Denial',
    'Anal',
    'Massage',
    'Kiss',
    'Feet',
    'Music',
    'Tantra',
    'Roleplay',
    'Sensory Deprivation',
    'Alcohol',
    'Photo/Video',
    'Porn',
    'Lipstick',
    'Penetration',
    'Masturbation',
    'Lingerie',
    'Body Writing',
    'Breath Play',
    'Hair Play',
    'Scent Play',
    'Fantasy Sharing',
    'Tickling',
    'Storytelling',
    'Striptease',
    'Gamer',
    'Nature',
    'Voyeurism',
    'Exhibitionism',
    'Choking',
    'Light bondage',
  ];

  Map<String, List<String>> generateCategoryTasks() {
    Map<String, List<String>> categoryTasks = {};
    for (var category in categories) {
      if (category.isSelected) {
        switch (category.name) {
          case 'Bondage':
            categoryTasks[category.name] = [
              'Try tying each other’s hands with soft cloth',
              'Explore light bondage with your partner, using only rope',
              'Use a blindfold for your partner and have them guess where you touch them',
              'Have your partner choose a bondage item that you will wear',
              'Incorporate a full bondage session with safeword.',
            ];
            break;
          case 'Toys':
            categoryTasks[category.name] = [
              'Explore a toy that you do not usually use with your partner',
              'Have your partner chose a toy they want to use on you',
              'Try using only one type of toy during a love making session',
              'Use the toy as a source of teasing and denial',
              'Create a game with a toy for the enjoyment of both of you.',
            ];
            break;
          case 'Dominance/Submission':
            categoryTasks[category.name] = [
              'Have your partner guide you with an erotic command',
              'Have your partner roleplay as a person that is in a position of power',
              'Allow your partner to explore the limits that you have set for your submissive side.',
              'Try a session where your partner has full control over your body',
              'Incorporate dominance/submission in a role-playing session.',
            ];
            break;
          case 'Oral':
            categoryTasks[category.name] = [
              'Have your partner gently kiss your lips',
              'Have your partner slowly lick your neck',
              'Allow your partner to explore your body with their tongue.',
              'Allow your partner to orally explore your body while you are blindfolded.',
              'Have an oral session using a blindfold and explore different tastes',
            ];
            break;
          case 'Spanking':
            categoryTasks[category.name] = [
              'Try gently tapping your partner’s body',
              'Have your partner trace your body using their palm',
              'Have your partner play with your skin with soft pressure',
              'Use your hand to tap your partner while you whisper a naughty word',
              'Use a spanking session as a source of foreplay.',
            ];
            break;
          case 'Food':
            categoryTasks[category.name] = [
              'Have your partner taste you with a sweet treat.',
              'Have your partner lick honey off a part of your body',
              'Have your partner put a piece of food in your mouth while blindfolded',
              'Use different textures of food to explore each other’s skin',
              'Have a full body food massage.',
            ];
            break;
          case 'Teasing/Denial':
            categoryTasks[category.name] = [
              'Tease your partner without touching them',
              'Slowly remove one piece of clothing from your partner',
              'Touch your partner everywhere except for their erogenous zones',
              'Use your mouth to kiss your partner on their body but stopping before getting to erogenous zones',
              'Deny your partner any physical touch for 5 minutes after having them at their edge.',
            ];
            break;
          case 'Anal':
            categoryTasks[category.name] = [
              'Explore your partners anal area gently with fingers',
              'Use a toy to explore your partner anal area with a light touch',
              'Ask your partner to describe what they like about anal stimulation',
              'Use your tongue to explore your partner’s anal area',
              'Have an anal sex session using a lubricant',
            ];
            break;
          case 'Massage':
            categoryTasks[category.name] = [
              'Give your partner a relaxing hand massage.',
              'Massage your partners back using sensual strokes',
              'Give your partner a full body massage using oil or lotion',
              'Have your partner lie in bed while you use different textures to massage them',
              'Have your partner guide your massage to their erogenous zones',
            ];
            break;
          case 'Kiss':
            categoryTasks[category.name] = [
              'Give your partner a soft kiss on the lips',
              'Explore the different parts of your partner’s face while kissing them.',
              'Use your tongue to slowly explore your partner’s mouth',
              'Kiss your partner’s body starting from the neck to the belly button',
              'Have a deep and sensual kiss with your partner that leads to further exploration.',
            ];
            break;
          case 'Feet':
            categoryTasks[category.name] = [
              'Let your partner touch your feet gently with their fingers',
              'Let your partner massage your feet with oil or lotion',
              'Have your partner explore your feet with their mouth',
              'Have your partner use different textures on your feet to explore',
              'Have your partner draw on your feet with their fingers or a toy',
            ];
            break;
          case 'Music':
            categoryTasks[category.name] = [
              'Put on music that you and your partner enjoy and move your body together',
              'Create a playlist for your partner that you think they will like during intimacy',
              'Put on a song and have your partner create a striptease based on it',
              'Let your partner put on a song that they want to listen to during intimacy',
              'Listen to a sensual song with your partner and try to communicate your feelings without words',
            ];
            break;
          case 'Tantra':
            categoryTasks[category.name] = [
              'Try a tantric breathing technique with your partner in bed.',
              'Explore the concept of dual energy with your partner',
              'Have your partner guide you using the principles of tantric sexuality.',
              'Try a tantric meditation with your partner',
              'Share a tantric practice and learn a new sensual practice',
            ];
            break;
          case 'Roleplay':
            categoryTasks[category.name] = [
              'Have your partner dress as a character and then you describe how you feel',
              'Have your partner use their hands and voice as they portray a character during sex',
              'Have your partner chose a character and act out your favorite sexual scenario',
              'Try to add lines from a movie to enhance a sexual encounter using a character',
              'Explore roleplay in bed using props and costumes',
            ];
            break;
          case 'Sensory Deprivation':
            categoryTasks[category.name] = [
              'Use a blindfold with your partner and then ask them to describe their surroundings with your touch',
              'Put on a blindfold for your partner and use different textures to touch them on their skin',
              'Put on earplugs and have your partner explore your body with their mouth',
              'Create a sensory deprivation experience by putting on blindfold and earplugs to your partner',
              'Explore with sounds and touch while your partner has their eyes closed',
            ];
            break;
          case 'Alcohol':
            categoryTasks[category.name] = [
              'Have a drink while you explore each other’s bodies with your hands',
              'Drink while you describe what is the best part of your partner',
              'Have your partner drink something and describe how they feel after drinking it.',
              'Have a glass of wine while making love',
              'Use a cocktail as a source of teasing and denial',
            ];
            break;
          case 'Photo/Video':
            categoryTasks[category.name] = [
              'Have your partner take a picture of your face after an orgasm',
              'Take a full body photo of your partner in bed while they are wearing something sexy',
              'Take a video together while having sex',
              'Take a video of your partner while you describe their beauty.',
              'Take turns directing how the other person should take the photo or video',
            ];
            break;
          case 'Porn':
            categoryTasks[category.name] = [
              'Choose a scene and act it out using the position, the moves, and the pace',
              'Have your partner choose a type of porn and describe how they feel about it',
              'Choose a pornographic movie and explore each other while watching it',
              'Choose a pornographic movie and do a roleplay with your partner',
              'Have your partner choose a porn and describe what they would change about it',
            ];
            break;
          case 'Lipstick':
            categoryTasks[category.name] = [
              'Have your partner apply lipstick on your lips',
              'Kiss your partner leaving a mark on their body.',
              'Have your partner use the lipstick on their body to write a message.',
              'Use the lipstick to create a drawing on your body',
              'Have your partner apply lipstick to your genitals',
            ];
            break;
          case 'Penetration':
            categoryTasks[category.name] = [
              'Have slow penetration while looking each other in the eyes',
              'Focus on the sensation of penetration, and use only that to reach orgasm',
              'Do not allow any touching or kissing only penetration to enhance the pleasure',
              'Use penetration in a position that is unusual and try to focus on the pleasure only',
              'Incorporate penetration while using a toy',
            ];
            break;
          case 'Masturbation':
            categoryTasks[category.name] = [
              'Masturbate slowly while your partner watches you from afar',
              'Guide your partner while they masturbate and touch you with their hands.',
              'Masturbate while your partner touches you and use their feedback to your masturbation',
              'Let your partner describe to you what is hot to watch, while they are watching you masturbate',
              'Use a toy to masturbate while your partner focuses on your pleasure',
            ];
            break;
          case 'Lingerie':
            categoryTasks[category.name] = [
              'Choose a lingerie for your partner and let them try it on',
              'Let your partner choose your lingerie and show it to them while you are in bed',
              'Tell your partner what makes you feel horny when you wear lingerie',
              'Choose a piece of lingerie for you to wear while you have sex.',
              'Have your partner buy you a piece of lingerie that you would like to wear',
            ];
            break;
          case 'Body Writing':
            categoryTasks[category.name] = [
              'Write a message on your partner using a feather or a brush',
              'Use oil or lotion to draw a simple image on your partner’s body',
              'Use your tongue to write on your partner’s body',
              'Use different textures to write messages on your partners body',
              'Ask your partner to describe how they feel when you write on their body',
            ];
            break;
          case 'Breath Play':
            categoryTasks[category.name] = [
              'Have your partner breathe on your neck or erogenous zones.',
              'Have your partner use only their breath to stimulate you',
              "Explore the pleasure of your breath on your partner's body",
              'Focus on your breathing during sex with your partner',
              'Use your breath to guide your partner into your sexual space',
            ];
            break;
          case 'Hair Play':
            categoryTasks[category.name] = [
              'Have your partner play with your hair using their hands',
              'Have your partner lick your hair and explore the different textures',
              'Have your partner pull your hair with different intensity and directions',
              'Have your partner touch your hair slowly while looking at your eyes',
              'Have your partner create a sensual massage using your hair',
            ];
            break;
          case 'Scent Play':
            categoryTasks[category.name] = [
              'Have your partner use a sensual scent on your body.',
              'Put a scented oil on your hands and have your partner explore your skin',
              'Let your partner discover your favorite scent and use it during intimacy',
              'Use different textures while exploring scents',
              'Have your partner use the scents to make you feel different emotions.',
            ];
            break;
          case 'Fantasy Sharing':
            categoryTasks[category.name] = [
              'Have your partner describe your favorite fantasy while touching you',
              'Describe to your partner one of your deepest fantasies and act it out',
              'Describe a fantasy that you have never told anyone before and then act it out',
              'Share a fantasy with your partner and see if they enjoy it',
              'Create a fantasy together and act it out',
            ];
            break;
          case 'Tickling':
            categoryTasks[category.name] = [
              'Use soft tickling motions in sensitive parts of the body',
              'Ask your partner to tickle you to increase your heart rate',
              'Have your partner tickle your feet and see how you react to it',
              'Let your partner tickle you everywhere, but only for a certain period',
            "Tickle a part of your partner's body and describe your sensation",
            ];
            break;
          case 'Storytelling':
            categoryTasks[category.name] = [
              'Have your partner tell you a story that makes you feel horny.',
              'Have your partner read you a sensual story while you touch them.',
              'Have your partner describe a sexual encounter using a story format',
              'Create a story together that will enhance your pleasure',
              'Write a story together and then act it out',
            ];
            break;
          case 'Striptease':
            categoryTasks[category.name] = [
              'Have your partner slowly remove one piece of clothing to seduce you',
              'Have your partner do a striptease while you blindfold yourself and then remove it',
              'Tell your partner what you would like them to wear during a striptease',
              'Tell your partner to do a striptease according to a music you choose',
              'Create a striptease together while exploring your bodies',
            ];
            break;
          case 'Gamer':
            categoryTasks[category.name] = [
              'Play a game of your choice while exploring your partners body with your hands',
              'Play a game and reward or punish each other based on the result',
              'Play a video game together and incorporate a touch session',
              'Create a board game or a role-playing game that will enhance the intensity of your session',
              'Create a game where you have to undress each other during gameplay',
            ];
            break;
          case 'Nature':
            categoryTasks[category.name] = [
              'Take each other for a walk in nature while holding hands',
              'Have sex in nature while listening to the sound of your surroundings',
              'Take a bath in nature and explore your bodies while you are in water',
              'Use the nature surrounding you to discover new ways of exploring each other',
              'Let the nature inspire your sensuality',
            ];
            break;
          case 'Voyeurism':
            categoryTasks[category.name] = [
              'Have your partner watch you in a mirror while you are masturbating',
              'Have your partner watch you while you are undressing yourself',
              'Have your partner film you while you are getting pleasure.',
              'Let your partner look at you while you are taking a bath or a shower',
              'Create an experience where you are being observed by your partner',
            ];
            break;
          case 'Exhibitionism':
            categoryTasks[category.name] = [
              'Masturbate in front of your partner and allow them to enjoy your body',
              'Have a full body photoshoot and share it with your partner.',
              'Expose yourself to your partner and have them describe what is it that they like about you',
              'Show your body to your partner while performing a striptease',
              'Have a date with your partner while doing sensual activities in public'
            ];
            break;
          case 'Choking':
            categoryTasks[category.name] = [
              'Use a scarf to gently put pressure on your partners neck and describe the sensations',
              'Have your partner describe the sensation when you put pressure on their neck while kissing them',
              'Have your partner put pressure on your neck while you are kissing them',
              'Explore light choking as a way to intensify the pleasure with your partner',
              'Use a blindfold while you are applying pressure to your partner’s neck',
            ];
            break;
          case 'Light bondage':
            categoryTasks[category.name] = [
              'Use soft cloth to restrain your partner’s hands while exploring them',
              'Tie your partner to the bed and kiss them while you have full control over their body',
              'Use rope to tie your partner legs and explore them while they are tied',
              'Use different materials while you are tying your partner to increase stimulation',
              'Have your partner tie you and lead the way for exploration',
            ];
            break;

          default:
            categoryTasks[category.name] = [
              "Try a new intimate activity tonight related to ${category.name}.",
              "Discuss fantasies involving ${category.name}.",
              "Purchase a new accessory related to ${category.name}.",
              "Explore a new position or scenario themed around ${category.name}.",
              "Spend 10 minutes focusing solely on ${category.name}-inspired sensations.",
            ];
        }
      }
    }
    return categoryTasks;
  }

  List<Category> get categories => _categories;

  int selectedItem() => _categories.where((i) => i.isSelected == true).length;

  void toggleCategory(String categoryName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    for (var category in _categories) {
      if (category.name == categoryName) {
        category.isSelected = !category.isSelected;
        await pref.setBool(category.name, category.isSelected);
        notifyListeners();
        return;
      }
    }
  }
}

class Category {
  final String name;
  bool isSelected;

  Category({required this.name, this.isSelected = true});
}
