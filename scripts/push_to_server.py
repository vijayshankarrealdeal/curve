import firebase_admin
from firebase_admin import credentials, firestore

# ==========================================
# 1. SETUP
# ==========================================
# Make sure your JSON file name matches exactly
cred = credentials.Certificate(
    "/Users/vijayshankar/Desktop/curve/scripts/evesdrops-46b4b-firebase-adminsdk-fbsvc-208f9658fd.json"
)

try:
    firebase_admin.get_app()
except ValueError:
    firebase_admin.initialize_app(cred)

db = firestore.client()
print("🔥 Firebase Initialized.")

# ==========================================
# 2. DATA SOURCE (Copied from your Dart files)
# ==========================================

TRUTHS = [
    "What is your biggest fear?",
    "Have you ever lied to your best friend?",
    "What is a secret you've never told anyone?",
    "What makes you feel most loved when we are in bed together?",
    "What is your favorite memory of us in bed?",
    "What small gesture in bed makes you feel most cherished?",
    "How has being in bed with me changed your view of intimacy?",
    "What are three words you would use to describe our connection in bed?",
    "What do you dream of doing in bed together?",
    "What is the most erotically charged thing we've done in bed?",
    "Which of my touches in bed make you shiver?",
    "Have you ever had a sexual experience under the influence of alcohol or another drug?",
    "What part of my body is your favorite to kiss, lick, or touch in bed?",
    "Have you ever had a memorable experience with oral sex in bed?",
    "What is the most daring thing you'd like to try in bed?",
    "Have you ever experimented with spanking or impact play in bed?",
    "What is the most extreme fantasy you would like to explore in bed?",
    "What kind of power dynamic turns you on the most in bed?",
    "What is your favorite way to be touched before sex in bed?",
    "What is the hottest thing I can do during sex in bed?",
    "What is your favorite sex position?",
    "What turns you off during sex?",
    "What do you fantasize about when you masturbate in bed?",
    "What kind of lingerie would you like to see me wear in bed?",
    "Have you ever explored bondage or light bondage in bed?",
    "What is your favorite toy to use for pleasure in bed?",
    "What do you like the most about dominance and submission in bed?",
    "Have you ever experienced the thrill of teasing and denial in bed?",
    "Have you ever been adventurous with anal sex in bed?",
    "What makes a massage sensual and exciting for you in bed?",
    "What kind of foot play do you enjoy the most in bed?",
    "What have you learned from tantra that changed you in bed?",
    "What is your most exciting experience playing a role in bed?",
    "What is the most impactful type of sensory deprivation for you in bed?",
    "What do you enjoy about masturbation, and how does it make you feel in bed?",
    "What is the first thing you notice in a person’s body when using body writing in bed?",
    "Have you ever had a partner use breath play on you in bed?",
    "What is your favorite thing about hair play in bed?",
    "What makes you enjoy voyeurism in bed?",
    "How would you describe the feeling of exhibitionism in bed?",
    "Have you ever experimented with choking as a form of play in bed?",
    "What is your feeling about light bondage, is it for you in bed?",
    "What makes you enjoy photos and videos in bed?",
    "What is your feeling about lipstick in bed?",
]

DARES = [
    "Do 10 push-ups right now.",
    "Sing a song loudly.",
    "Dance without music for 30 seconds.",
    "Give your partner a gentle kiss on the forehead.",
    "Cuddle your partner and whisper something sweet into their ear.",
    "Trace a heart on your partner's back with your finger.",
    "Share a loving memory with your partner and recreate its mood with your touch.",
    "Take each other's hand and tell each other how grateful you are to be in bed together.",
    "Describe what makes you feel most connected when you are in bed together",
    "Lick your partner from their neck to their belly button",
    "Give your partner a sensual massage using only your hands and a bit of oil.",
    "Use a blindfold on your partner and use your fingers to explore them on different places",
    "Choose one of the erogenous areas in your partner and kiss and lick them for 2 minutes",
    "Give your partner a light spank and describe the action while it's happening",
    "Pick a toy and demonstrate how you would use it on your partner in bed using only your body",
    "Use a blindfold on your partner and give them an erotic command.",
    "Use a toy or your own body to tease your partner, and then deny them for at least 3 minutes",
    "Give your partner a sensual kiss that is intended to lead to sex",
    "Whisper to your partner a fantasy while you are touching them",
    "Put your partner in your favorite sex position",
    "Guide your partner and give them pleasure with only your hands.",
    "Masturbate while making eye contact with your partner and showing you have a good time.",
    "Ask your partner to put on your favorite lingerie and describe how you feel.",
    "Put on a blindfold and allow your partner to gently guide you around your bed.",
    "Choose a toy and describe how you would use it on your partner, without using any hands",
    "Describe how you would dominate your partner verbally and physically in a few sentences.",
    "Describe using only your tongue what is your favorite thing about giving oral",
    "Blindfold your partner and describe with detail how you will use food to stimulate them.",
    "Tease your partner, but do not touch them.",
    "Allow your partner to slowly move their tongue on you in a place that they choose.",
    "Ask your partner to explore a part of your foot",
    "Incorporate a tantric technique and guide your partner on it.",
    "Act out a sexual role-play using a character that is not you",
    "Blindfold your partner and play different sounds with your mouth or body",
    "Mix an alcoholic beverage and let your partner describe it without tasting it",
    "Take a sexy photo or video of yourself in bed and share it with your partner",
    "Choose a part of your favorite porn video and act it out in bed",
    "Let your partner write on your body using oil or lotion",
    "Use only your breath and try to stimulate your partner without touch",
    "Play with your partner's hair using your hands, mouth, or tongue",
    "Spray a scent or perfume on your body and move around to seduce your partner",
    "Let your partner watch you masturbate in bed",
    "Let your partner exhibit your body for them in bed",
    "Allow your partner to use some pressure on your neck to stimulate you",
    "Wear something that allows your partner to easily apply light bondage to your body in bed",
]

GRID_CELLS = {
    1: ["Gentle Kiss", "Forehead Kiss", "Cheek Kiss", "Hold Hands", "Smile Together"],
    2: [
        "Whisper a Secret",
        "Whisper a Compliment",
        "Say a Memory",
        "Laugh Together",
        "Hum a Song",
    ],
    3: [
        "Sensual Touch (Arm)",
        "Stroke Hair",
        "Trace Fingers on Arm",
        "Gently Hold Forearm",
        "Soft Shoulder Touch",
    ],
    4: [
        "Compliment",
        "Say Something Sweet",
        "Share a Positive Thought",
        "Tell What You Admire",
        "Encourage Gently",
    ],
    5: [
        "Eye Contact Hold",
        "Blink Synchronization",
        "Mirror Smile",
        "Wink Playfully",
        "Observe Closely",
    ],
    6: [
        "Tease (Light Touch)",
        "Lightly Tickling Palm",
        "Brush Fingers",
        "Hover Near Skin",
        "Gentle Poke",
    ],
    7: [
        "Massage (Back)",
        "Massage (Neck)",
        "Massage (Shoulders)",
        "Massage (Lower Back)",
        "Massage (Spine Gently)",
    ],
    8: [
        "Blindfold",
        "Cover Eyes Playfully",
        "Guess Who Touch",
        "Sense of Direction Test",
        "Peek-a-Boo",
    ],
    9: [
        "Kiss (Neck)",
        "Brush Lips on Neck",
        "Gentle Neck Nuzzle",
        "Nibble Lightly",
        "Trace Neckline",
    ],
    10: [
        "Scent Play",
        "Use a Candle Scent",
        "Waft Perfume",
        "Describe a Scent",
        "Breathe in Fresh Air",
    ],
    11: ["Body Kiss", "Butterfly Kiss", "Heart Kiss", "Chest Kiss", "Hand Kiss"],
    12: [
        "Shared Breath",
        "Synchronized Inhale",
        "Exhale Together",
        "Breathe in Harmony",
        "Gentle Breath Hug",
    ],
    13: [
        "Lingerie Reveal",
        "Pick Favorite Outfit",
        "Try a New Look",
        "Fashion Advice",
        "Compliment Style",
    ],
    14: [
        "Describe a Fantasy",
        "Dream Vacation Story",
        "Dream House Plan",
        "Your Ideal Day",
        "Imaginative World",
    ],
    15: [
        "Sensual Touch (Leg)",
        "Trace Knee",
        "Light Leg Caress",
        "Knee Bump Play",
        "Calf Massage",
    ],
    16: [
        "Undress (One Item)",
        "Slip Off Accessories",
        "Fold Item Neatly",
        "Playful Shoe Removal",
        "Light Sock Tug",
    ],
    17: [
        "Kiss (Inner Thigh)",
        "Linger Near Thigh",
        "Light Thigh Nibble",
        "Gentle Thigh Stroke",
        "Trace Lines",
    ],
    18: [
        "Use a Feather/Light Hand touch",
        "Brush Cheek with Feather",
        "Circle Palm with Feather",
        "Trace Arm Patterns",
        "Light Skin Taps",
    ],
    19: [
        "Erotic Command",
        "Request a Gentle Task",
        "Ask for Whisper",
        "Ask for Eye Contact",
        "Softly Request a Pose",
    ],
    20: [
        "Massage (Hands)",
        "Fingers Massage",
        "Palm Circles",
        "Wrist Relaxation",
        "Squeeze Gently",
    ],
    21: [
        "Taste Me",
        "Explore Lips Taste",
        "Test Favorite Flavor",
        "Savor Together",
        "Describe Tastes",
    ],
    22: [
        "Explore with Tongue",
        "Taste Gentle Forearm",
        "Sense Playful Knuckle",
        "Tongue Texture Guess",
        "Gentle Wrist Explore",
    ],
    23: [
        "Blind Taste Test",
        "Use Sweet",
        "Use Salt Flavor Guess",
        "Citrus Touch Guess",
        "Playful Snack",
    ],
    24: [
        "Roleplay Start",
        "Pick Character",
        "Role Soft Action Play",
        "Lead a Story Tell",
        "Add Lines Soft Act",
    ],
    25: [
        "Body Lick",
        "Gentle Style Trace",
        "Bare Arm Feel",
        "Slow Describe Move",
        "Taste Clear Area Soft",
    ],
    26: [
        "Guide my Hands",
        "Motion Soft Tied",
        "Lead Pause Feels",
        "Trace Smoother Built",
        "Draw Limited Mapping",
    ],
    27: [
        "Tease (Bite)",
        "Nip Holding Easy Timing",
        "Explores Yield Oppress",
        "Ending/A+Alt Connect",
        "Twilight Debug",
    ],
    28: [
        "Explicit Whisper",
        "Erotic Word Choice",
        "Naughty Suggest",
        "Vivid Details Feel",
        "Breath Control Play",
    ],
    29: [
        "Soft Spank",
        "Gentle Touch Play",
        "Tapping Lightly",
        "Press Feel Skin",
        "Soft Beat Rhythm",
    ],
    30: [
        "Full Body Exploration",
        "Slow Body Trace",
        "Gentle Full Mapping",
        "Explore Feel Soft",
        "Connect Each Touch",
    ],
}

FOUR_CARDS_DATA = {
    1: [
        "Explore your partner’s body with light kisses.",
        "Use a feather to gently stroke your partner’s skin.",
        "Describe a fantasy you have about exploring nature with your partner.",
        "Give your partner a hand massage using oil or lotion.",
        "Tease your partner’s lips with your fingers.",
        "Draw an imaginary shape on your partner’s body with your breath.",
        "Guide each other to a comfortable position using only touch.",
        "Use a scented lotion or oil to massage your partner's shoulders.",
        "Ask your partner what makes them feel alive and full of light.",
        "Slowly remove one item of clothing from your partner using your teeth.",
        "Make your partner close their eyes and use a touch or a kiss to guess a spot on the body",
        "Move your hands gently on your partner’s skin and see their reaction.",
        "Have your partner choose a music to put on while you are enjoying each other's touch.",
        "Use a silk scarf to trace patterns on your partner's skin.",
        "Massage your partner’s feet using your hands and mouth.",
        "Tease your partner with a small ice cube on their neck and back.",
        "Explore a new part of your partner’s body with a light touch.",
        "Describe a sensual experience in nature with your partner.",
        "Explore your partner’s skin with a light and playful bite.",
        "Share a favorite summer memory with your partner and then recreate it.",
        "Let your partner guide you through a room using only touch and smell.",
        "Guide your partner using a feather and watch where they want you to touch them.",
        "Touch yourself in a sensual way and ask your partner to describe what they are seeing.",
        "Use warm oil to draw patterns on your partner’s skin.",
        "Use a blindfold and have your partner lead you through a dance.",
        "Play with your partner’s hair and explore the textures with your mouth and hands.",
        "Let your partner explore a part of your body that you do not usually enjoy.",
        "Let your partner create a sensual trail of kisses in the path that they choose.",
        "Explore a new position with your partner and allow them to guide you.",
        "Have your partner describe your body as if you were a work of art.",
        "Guide each other through a blind taste test and describe your sensations.",
        "Use your breath to caress your partner’s skin.",
        "Use water, a feather or ice to describe a line in your partner’s body.",
        "Pick a movie or series that you both like and have a sensual experience while watching it.",
        "Have your partner choose a piece of clothing and undress in front of you using it.",
        "Create a playful scenario where you both play and explore your bodies.",
        "Have a competition to see who is the best at seducing, with touch and words.",
        "Use your breath to explore your partner’s body.",
        "Let your partner guide you with their hands and mouth.",
        "Use a scented candle to explore each other’s bodies.",
        "Explore your partner’s body using different textures.",
        "Have your partner use their voice and your body to explore erogenous zones.",
        "Use a soft scarf to explore your partner’s skin, tickling them gently.",
        "Share what makes you feel confident with your partner.",
        "Touch your partner and ask them to tell you what are they feeling.",
        "Describe what you like the most about your partner’s body.",
        "Use slow movements and guide your partner to explore you.",
        "Have your partner explore your back with a sensual massage.",
        "Have your partner tell you what part of their body is the most sensitive to touch.",
        "Share what you like to do when you enjoy your own body.",
        "Describe how your body feels when you are with your partner.",
        "Let your partner design a way for you to show them how much you desire them.",
    ],
    2: [
        "Whisper a sweet compliment.",
        "Give a gentle kiss on the forehead.",
        "Hold your partner’s hand and describe your favorite thing about them.",
        "Share a loving memory you have of your partner and cuddle.",
        "Tell each other what you cherish the most about your relationship.",
        "Share your favorite memory of a sensual moment with your partner.",
        "Hold each other close and sway to an imaginary rhythm.",
        "Give a soft kiss on your partner’s heart while looking into their eyes.",
        "Compliment your partner's features that you find most attractive.",
        "Whisper a silly and playful secret into your partner's ear.",
        "Describe how you feel when your partner smiles at you.",
        "Hold your partner’s hands and breathe in and out together",
        "Tell each other your fears and your dreams.",
        "Offer a gentle touch on your partner’s face and tell them how you cherish them.",
        "Share a moment of vulnerability with your partner.",
        "Give your partner a soft kiss and express a shared wish.",
        "Tell your partner your favorite thing that you’ve learned from them.",
        "Let your partner chose a nickname for you and they can use it while you are playing.",
        "Have a slow dance with your partner in the bedroom, while enjoying the physical contact.",
        "Tell your partner something that you find funny about them while you cuddle.",
        "Write a love note on your partner’s back using your finger.",
        "Share a dream you have about your future with your partner.",
        "Use a soft kiss to express how much you appreciate your partner.",
        "Tell your partner something that you are grateful for.",
        "Share what makes your heart beat faster when you think of them",
        "Make eye contact with your partner and express your feelings without words.",
        "Choose a scent that you associate with your partner.",
        "Tell each other how much you love the feeling of cuddling.",
        "Use only your hands to express gratitude to your partner.",
        "Share with your partner an emotion that you always feel when you are with them.",
        "Sing a song to your partner and enjoy the moment.",
        "Share a secret that makes you feel vulnerable.",
        "Tell your partner the most beautiful thing that you see when looking into their eyes.",
        "Hold your partner's face and express gratitude using your hands.",
        "Use gentle and soft touch to express your deepest emotions for them.",
        "Describe the moment in which you realized you loved your partner.",
        "Share a moment that you thought of your partner and how much you missed them.",
        "Tell your partner what you like about their kindness and sensibility.",
        "Choose a song and tell your partner how much it reminds you of them.",
        "Share a secret of your past with your partner.",
        "Ask your partner how you can express more love with your body.",
        "Share a dream that you have about a future with your partner.",
        "Whisper a line or a poem that makes you feel connected.",
    ],
    3: [
        "Use your tongue to explore your partner's neck and ear.",
        "Blindfold your partner and explore their body with your hands.",
        "Whisper an erotic command and see your partner follow it.",
        "Lick a spot of your partner's choosing, letting the sensation create pleasure.",
        "Explore your partner’s skin with soft bites.",
        "Describe how you would use a blindfold to heighten your senses.",
        "Use your hands to caress your partner’s body and see where you are guided.",
        "Describe an erogenous zone to your partner and use your imagination to build tension.",
        "Have your partner tell you how they would explore your body to elicit pleasure.",
        "Guide your partner to a comfortable position that is new to both of you.",
        "Make a trail of kisses from your partner’s neck to their core.",
        "Tell your partner one thing that makes you feel sexually aroused.",
        "Have your partner use only their tongue and lips to explore you.",
        "Create a sensual story that will be a source of pleasure for both.",
        "Explore your partner's body with long, slow kisses.",
        "Blindfold your partner and describe your touch while exploring their body.",
        "Use your fingers to slowly explore your partner’s lips and mouth.",
        "Let your partner explore your inner thighs with their mouth.",
        "Describe how you want to be touched while your partner touches you in the way you describe.",
        "Share a scene that you have imagined with your partner and then roleplay it.",
        "Use a toy to explore your partner while they are making eye contact with you.",
        "Guide your partner by whispering a sensual command and see them follow your lead.",
        "Describe a sexual fantasy you have using words and movement.",
        "Use your tongue to explore your partner’s body and enjoy the texture.",
        "Have your partner tell you how they would explore a new part of your body.",
        "Play with a mirror and use it while touching yourself and letting your partner enjoy your beauty.",
        "Use a scent of your choice and then guide your partner while they are blindfolded.",
        "Undress your partner slowly while making eye contact and enjoying their beauty.",
        "Use your body to guide your partner into your sexual space without talking.",
        "Use your tongue to explore your partner's erogenous zones, focusing on texture.",
        "Use a sex toy on your partner while making eye contact with them.",
        "Let your partner explore a part of your body that is not usually touched.",
        "Have your partner give you an erotic massage while blindfolded.",
        "Explore your partner's inner thighs and guide them with your mouth.",
        "Describe the most arousing thing that you can imagine happening in bed.",
        "Have your partner use their hands to explore your body while you are blindfolded.",
        "Have your partner describe in detail your body and how much they desire it.",
        "Have your partner pick your favorite piece of clothing and explore you with it.",
        "Explore the pleasure that a nipple play session can offer.",
        "Put on an outfit that you would normally not wear, and allow your partner to explore your body in it.",
        "Try a new position and have your partner take the lead while you explore their body.",
        "Use your mouth to explore your partner’s body with small and playful bites.",
        "Use a toy of your choice and guide your partner to orgasm.",
        "Let your partner explore you while you are blindfolded and they have full control.",
        "Have a full session focusing only on nipple play.",
        "Let your partner tie your hands and give them permission to explore your body.",
        "Share a sensual fantasy and guide your partner to play it with you.",
        "Use only a feather to explore your partner and watch how they react.",
        "Use the help of a vibrator to explore a part of your partner’s body.",
        "Have your partner pick an area of your body and have a sensual experience with it.",
        "Describe what is the best thing that they could do to you and then let them do it.",
        "Choose a position and give your partner pleasure using their body.",
        "Explore the concept of orgasm denial to increase pleasure in your session.",
        "Use your voice to intensify the pleasure in your session by using sensual commands.",
    ],
    4: [
        "Use a toy of your choice to tease your partner.",
        "Tell your partner how you would dominate them.",
        "Explore your partner’s erogenous zones with explicit touches.",
        "Give your partner a soft spank and describe what makes you enjoy it.",
        "Guide each other with erotic commands while taking a deep breath.",
        "Allow your partner to tie you and lead you for exploration.",
        "Use an object as a source of teasing and denial for your partner.",
        "Have a full session of mutual masturbation while making eye contact.",
        "Use an anal toy for penetration.",
        "Allow your partner to penetrate you using their own rhythm.",
        "Have your partner leave marks on your body as you explore each other.",
        "Use a vibrator to explore your partner's body, without directly targeting the erogenous zones.",
        "Have your partner use a toy on your genitals and watch your reaction.",
        "Give your partner control over the pace and intensity of your session.",
        "Explore light bondage and describe how you feel with your partner.",
        "Use a strap-on and let your partner experience a new sensation.",
        "Use your breath as a source of dominance and control.",
        "Use hot wax to stimulate your partner’s skin.",
        "Play with orgasm denial and let it build up your partner’s desire.",
        "Create an experience in which your partner gives you full control of their body.",
        "Have your partner whisper you an erotic command.",
        "Choose an action and use it as a punishment for you or your partner.",
        "Use a toy as a source of teasing and denial and enjoy your partner's reaction.",
        "Do not allow your partner to touch you while you explore their body.",
        "Do not allow your partner to kiss you while you explore their body.",
        "Choose a toy and use it to explore your partner’s limits, without being cruel.",
        "Have a full session where you have full control of your partner’s body.",
        "Explore a new role-play session where you explore power dynamics.",
        "Use a soft bondage piece and explore your partners body while they are tied.",
        "Use orgasm denial to intensify your session and create anticipation.",
        "Create a power-play scenario and have your partner ask for permission while exploring each other.",
        "Explore a new part of your body that you have never shown your partner and have them explore it.",
        "Have a session with a specific object as a source of teasing and explore the reactions that you create.",
        "Use your words to describe how much you enjoy dominating or being dominated.",
        "Have a session where the main focus is domination and submission, following the rules that you create.",
        "Create a sexual fantasy and guide your partner through it in a session of your choosing.",
        "Allow your partner to choose a way to explore your body using touch, sound, or smell.",
        "Use a spank to leave a mark on your partner and then explore it.",
        "Have your partner use you as a toy and explore their sexual side.",
        "Have a role-play session where you punish and reward your partner.",
        "Explore your partner’s sexual limits.",
        "Tie your partner and explore all the reactions they have.",
        "Have your partner lead you with erotic commands and then guide them.",
        "Explore a new position where you can be in full control of your partner.",
        "Use your power as a form of teasing and denial with your partner.",
        "Create a scenario where your partner needs to ask you for permission.",
        "Describe the most submissive and powerful version of yourself.",
        "Use a toy to control your partner and guide them while exploring their body.",
        "Use your mouth and hands to create new sensations while your partner has no say on them.",
        "Leave a mark on your partner and let them be in charge for the rest of the session.",
    ],
}

# ==========================================
# 3. HELPER FUNCTIONS
# ==========================================


def delete_collection(coll_ref, batch_size=100):
    """Recursively delete a collection in batches."""
    docs = coll_ref.limit(batch_size).stream()
    deleted = 0

    for doc in docs:
        doc.reference.delete()
        deleted = deleted + 1

    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)


# ==========================================
# 4. UPLOAD LOGIC
# ==========================================


def upload_truth_dare():
    collection = db.collection("truth_dare_tasks")
    print("🧹 Cleaning truth_dare_tasks collection...")
    delete_collection(collection)

    batch = db.batch()
    print(f"🚀 Uploading {len(TRUTHS)} Truths and {len(DARES)} Dares...")

    count = 0
    for t in TRUTHS:
        doc_id = f"truth_{hash(t)}"
        doc_ref = collection.document(doc_id)
        batch.set(doc_ref, {"type": "truth", "content": t, "active": True})
        count += 1

    for d in DARES:
        doc_id = f"dare_{hash(d)}"
        doc_ref = collection.document(doc_id)
        batch.set(doc_ref, {"type": "dare", "content": d, "active": True})
        count += 1

    batch.commit()
    print(f"✅ Uploaded {count} Truth/Dare items.")


def upload_four_cards():
    collection = db.collection("four_cards_tasks")
    print("🧹 Cleaning four_cards_tasks collection...")
    delete_collection(collection)

    batch = db.batch()
    print("🚀 Uploading 4 Cards data...")
    count = 0

    for category_id, tasks in FOUR_CARDS_DATA.items():
        for task in tasks:
            doc_id = f"card_{category_id}_{hash(task)}"
            doc_ref = collection.document(doc_id)
            batch.set(
                doc_ref, {"category_id": category_id, "content": task, "active": True}
            )
            count += 1
            if count % 400 == 0:
                batch.commit()
                batch = db.batch()

    batch.commit()
    print(f"✅ Uploaded {count} 4-Cards items.")


def upload_maze_data():
    collection = db.collection("maze_tasks")
    print("🧹 Cleaning maze_tasks collection...")
    delete_collection(collection)

    batch = db.batch()
    print("🚀 Uploading Maze Grid data...")
    count = 0

    for cell_id, actions in GRID_CELLS.items():
        doc_ref = collection.document(str(cell_id))
        # Store as array
        batch.set(doc_ref, {"cell_id": cell_id, "actions": actions})
        count += 1

    batch.commit()
    print(f"✅ Uploaded {count} Maze cells.")


if __name__ == "__main__":
    upload_truth_dare()
    upload_four_cards()
    upload_maze_data()
    print("\n🎉 ALL DATA INGESTION COMPLETE! 🎉")
