final Map<int, List<String>> gridCells = {
  1: [
    'Gentle Kiss',
    'Forehead Kiss',
    'Cheek Kiss',
    'Hold Hands',
    'Smile Together'
  ],
  2: [
    'Whisper a Secret',
    'Whisper a Compliment',
    'Say a Memory',
    'Laugh Together',
    'Hum a Song'
  ],
  3: [
    'Sensual Touch (Arm)',
    'Stroke Hair',
    'Trace Fingers on Arm',
    'Gently Hold Forearm',
    'Soft Shoulder Touch'
  ],
  4: [
    'Compliment',
    'Say Something Sweet',
    'Share a Positive Thought',
    'Tell What You Admire',
    'Encourage Gently'
  ],
  5: [
    'Eye Contact Hold',
    'Blink Synchronization',
    'Mirror Smile',
    'Wink Playfully',
    'Observe Closely'
  ],
  6: [
    'Tease (Light Touch)',
    'Lightly Tickling Palm',
    'Brush Fingers',
    'Hover Near Skin',
    'Gentle Poke'
  ],
  7: [
    'Massage (Back)',
    'Massage (Neck)',
    'Massage (Shoulders)',
    'Massage (Lower Back)',
    'Massage (Spine Gently)'
  ],
  8: [
    'Blindfold',
    'Cover Eyes Playfully',
    'Guess Who Touch',
    'Sense of Direction Test',
    'Peek-a-Boo'
  ],
  9: [
    'Kiss (Neck)',
    'Brush Lips on Neck',
    'Gentle Neck Nuzzle',
    'Nibble Lightly',
    'Trace Neckline'
  ],
  10: [
    'Scent Play',
    'Use a Candle Scent',
    'Waft Perfume',
    'Describe a Scent',
    'Breathe in Fresh Air'
  ],
  11: ['Body Kiss', 'Butterfly Kiss', 'Heart Kiss', 'Chest Kiss', 'Hand Kiss'],
  12: [
    'Shared Breath',
    'Synchronized Inhale',
    'Exhale Together',
    'Breathe in Harmony',
    'Gentle Breath Hug'
  ],
  13: [
    'Lingerie Reveal',
    'Pick Favorite Outfit',
    'Try a New Look',
    'Fashion Advice',
    'Compliment Style'
  ],
  14: [
    'Describe a Fantasy',
    'Dream Vacation Story',
    'Dream House Plan',
    'Your Ideal Day',
    'Imaginative World'
  ],
  15: [
    'Sensual Touch (Leg)',
    'Trace Knee',
    'Light Leg Caress',
    'Knee Bump Play',
    'Calf Massage'
  ],
  16: [
    'Undress (One Item)',
    'Slip Off Accessories',
    'Fold Item Neatly',
    'Playful Shoe Removal',
    'Light Sock Tug'
  ],
  17: [
    'Kiss (Inner Thigh)',
    'Linger Near Thigh',
    'Light Thigh Nibble',
    'Gentle Thigh Stroke',
    'Trace Lines'
  ],
  18: [
    'Use a Feather/Light Hand touch',
    'Brush Cheek with Feather',
    'Circle Palm with Feather',
    'Trace Arm Patterns',
    'Light Skin Taps'
  ],
  19: [
    'Erotic Command',
    'Request a Gentle Task',
    'Ask for Whisper',
    'Ask for Eye Contact',
    'Softly Request a Pose'
  ],
  20: [
    'Massage (Hands)',
    'Fingers Massage',
    'Palm Circles',
    'Wrist Relaxation',
    'Squeeze Gently'
  ],
  21: [
    'Taste Me',
    'Explore Lips Taste',
    'Test Favorite Flavor',
    'Savor Together',
    'Describe Tastes'
  ],
  22: [
    'Explore with Tongue',
    'Taste Gentle Forearm',
    'Sense Playful Knuckle',
    'Tongue Texture Guess',
    'Gentle Wrist Explore'
  ],
  23: [
    'Blind Taste Test',
    'Use Sweet',
    'Use Salt Flavor Guess',
    'Citrus Touch Guess',
    'Playful Snack'
  ],
  24: [
    'Roleplay Start',
    'Pick Character',
    'Role Soft Action Play',
    'Lead a Story Tell',
    'Add Lines Soft Act'
  ],
  25: [
    'Body Lick',
    'Gentle Style Trace',
    'Bare Arm Feel',
    'Slow Describe Move',
    'Taste Clear Area Soft'
  ],
  26: [
    'Guide my Hands',
    'Motion Soft Tied',
    'Lead Pause Feels',
    'Trace Smoother Built',
    'Draw Limited Mapping'
  ],
  27: [
    'Tease (Bite)',
    'Nip Holding Easy Timing',
    'Explores Yield Oppress',
    'Ending/A+Alt Connect',
    'Twilight Debug+ =DivideTrace(Snip Timing)'
  ],
  28: [
    'Explicit Whisper',
    'Erotic Word Choice',
    'Naughty Suggest',
    'Vivid Details Feel',
    'Breath Control Play'
  ],
  29: [
    'Soft Spank',
    'Gentle Touch Play',
    'Tapping Lightly',
    'Press Feel Skin',
    'Soft Beat Rhythm'
  ],
  30: [
    'Full Body Exploration',
    'Slow Body Trace',
    'Gentle Full Mapping',
    'Explore Feel Soft',
    'Connect Each Touch'
  ],
};

Map<int, String> generateTaskMessages(String playerGender, String taskX) {
  Map<int, String> taskMessages = {
    1: "Allow your $playerGender partner to greet you with a $taskX",
    2: "Your $playerGender partner will now $taskX",
    3: "Let your $playerGender partner explore your $taskX",
    4: "Now let your $playerGender partner express what they $taskX",
    5: "Hold a loving gaze with your $playerGender partner or $taskX",
    6: "Your $playerGender partner will now tease you with $taskX",
    7: "Let your $playerGender partner now relax you with a $taskX",
    8: "Allow your $playerGender partner to play with your sense of sight, have them $taskX",
    9: "Now let your $playerGender partner kiss and explore your neck, allow them to $taskX",
    10: "Allow your $playerGender partner to play with your sense of smell, allow them to $taskX",
    11: "Your $playerGender partner will now explore your body with a sensual kiss, choosing between a $taskX",
    12: "Breathe deeply with your $playerGender partner, and $taskX",
    13: "Your $playerGender partner will now show you their favorite outfit, and they will $taskX",
    14: "Now let your $playerGender partner captivate your mind by $taskX",
    15: "Let your $playerGender partner move their hands on your leg, exploring your knee with $taskX",
    16: "Allow your $playerGender partner to slowly remove one item of your clothing. They can $taskX",
    17: "Allow your $playerGender partner to heighten your arousal with a kiss on your inner thigh. They can $taskX",
    18: "Let your $playerGender partner explore your skin with a feather or with a light hand touch. Your skin can be explored on your $taskX",
    19: "Allow your $playerGender partner to give you an erotic command. They can $taskX",
    20: "Let your $playerGender partner provide you a sensual massage on your hands. They can $taskX",
    21: "Allow your $playerGender partner to explore your taste and your lips, they can also $taskX",
    22: "Now let your $playerGender partner explore you with their tongue. Allow them to $taskX",
    23: "Your $playerGender partner will now have you participate in a blind taste test using $taskX",
    24: "Let your $playerGender partner choose a character and let them $taskX",
    25: "Allow your $playerGender partner to explore your body with a lick. Let them $taskX",
    26: "Allow your $playerGender partner to guide you to explore their body. They can $taskX",
    27: "Your $playerGender partner will now tease you with a bite, they can choose to $taskX",
    28: "Now let your $playerGender partner whisper you an erotic message, with $taskX",
    29: "Allow your $playerGender partner to explore your skin using a soft spank. They can $taskX",
    30: "Now let your $playerGender partner fully explore your body. They can $taskX",
  };
  return taskMessages;
}
