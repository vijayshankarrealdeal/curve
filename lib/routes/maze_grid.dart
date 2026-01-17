import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/content_provider.dart';
import 'package:curve/services/gird_provider.dart';
import 'package:curve/services/language_provider.dart';
import 'package:curve/services/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:provider/provider.dart';

class MazeGrid extends StatelessWidget {
  const MazeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    if (gameProvider.roomId == null) {
      return const LobbyPage();
    }
    return const GameBoardPage();
  }
}

// ------------------ LOBBY PAGE ------------------
class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});
  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  void _createGame() async {
    setState(() => _isLoading = true);
    try {
      await context.read<GameProvider>().createGame();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _joinGame() async {
    if (_codeController.text.length != 6) return;
    setState(() => _isLoading = true);
    try {
      await context.read<GameProvider>().joinGame(_codeController.text.trim());
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final color = Provider.of<ColorsProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(lang.getText('maze'),
            style: TextStyle(color: color.navBarIconActiveColor())),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemPink.withAlpha(34),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.heart_fill,
                        size: 60, color: CupertinoColors.systemPink),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    lang.getText('play_with_partner'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: color.navBarIconActiveColor(),
                        ),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(),
                    onPressed: () =>
                        context.read<GameProvider>().startOfflineGame(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        lang.getText('play_offline'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(children: [
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("ONLINE",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 12)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                    ]),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: color.seedColorColor()),
                          ),
                          onPressed: _createGame,
                          child: _isLoading
                              ? const CupertinoActivityIndicator()
                              : Text(lang.getText('create_online')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: lang.getText('enter_code'),
                      filled: true,
                      fillColor: color.placeHolders(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: _joinGame,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------ GAME BOARD PAGE ------------------

class GameBoardPage extends StatelessWidget {
  const GameBoardPage({super.key});

  void _showGameOverDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        String winner = "Tie";
        if (provider.p1Score > provider.p2Score) winner = "Male Wins!";
        if (provider.p2Score > provider.p1Score) winner = "Female Wins!";

        return AlertDialog(
          backgroundColor: Provider.of<ColorsProvider>(context, listen: false)
              .getScaffoldColor(),
          title: Text(
            "🏁 Game Over!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Provider.of<ColorsProvider>(context, listen: false)
                    .primaryColor()),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events,
                  size: 60, color: CupertinoColors.activeOrange),
              const SizedBox(height: 10),
              Text(winner,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<ColorsProvider>(context, listen: false)
                          .diceColor())),
              const SizedBox(height: 10),
              Text("Male Score: ${provider.p1Score}",
                  style: TextStyle(
                      color: Provider.of<ColorsProvider>(context, listen: false)
                          .diceColor())),
              Text("Female Score: ${provider.p2Score}",
                  style: TextStyle(
                      color: Provider.of<ColorsProvider>(context, listen: false)
                          .diceColor())),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                provider.reset();
                Navigator.pop(ctx);
              },
              child: const Text("Exit"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                provider.startOfflineGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final lang = Provider.of<LanguageProvider>(context);
    final color = Provider.of<ColorsProvider>(context);
    final isWaiting = gameProvider.status == 'waiting';

    if (gameProvider.status == 'finished') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(context, gameProvider);
      });
    }

    // REMOVED: SnackBar Logic

    return Scaffold(
      backgroundColor: color.getScaffoldColor(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.getAppBarColor(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.getText('maze'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (gameProvider.isMultiplayer)
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: gameProvider.roomId ?? ""));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(lang.getText('copy_code'))));
                },
                child: Row(
                  children: [
                    Text("${lang.getText('room')}: ${gameProvider.roomId}",
                        style: TextStyle(
                            fontSize: 12, color: color.seedColorColor())),
                    const SizedBox(width: 5),
                    Icon(Icons.copy, size: 12, color: color.seedColorColor()),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => gameProvider.reset(),
            icon: const Icon(CupertinoIcons.power, color: Colors.redAccent),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. SCOREBOARD
          Container(
            height: 60,
            margin: const EdgeInsets.fromLTRB(
                16, 10, 16, 5), // Reduced bottom margin
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: color.getAppBarColor(),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPlayerScore("Male", Ion.male_sharp, gameProvider.p1Score,
                    gameProvider.currentPlayer == 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: VerticalDivider(
                    width: 1,
                    color: color.navBarIconActiveColor().withAlpha(70),
                  ),
                ),
                _buildPlayerScore("Female", Ion.female_sharp,
                    gameProvider.p2Score, gameProvider.currentPlayer == 2),
              ],
            ),
          ),

          // NEW: SPECIAL EVENT TEXT (Replaces SnackBar)
          if (gameProvider.specialEvent.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  gameProvider.specialEvent,
                  key: ValueKey(gameProvider.specialEvent),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gameProvider.specialEvent.contains("TRAP")
                        ? CupertinoColors.destructiveRed
                        : CupertinoColors.activeGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: (gameProvider.specialEvent.contains("TRAP")
                                ? CupertinoColors.destructiveRed
                                : CupertinoColors.activeGreen)
                            .withAlpha(128),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 10), // Placeholder to keep grid stable

          // 2. THE GRID
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = 5;
                double mainAxisSpacing = 3;
                double crossAxisSpacing = 3;

                double cellHeight =
                    (constraints.maxHeight - (5 * mainAxisSpacing)) / 6;
                double cellWidth = (constraints.maxWidth -
                        ((crossAxisCount - 1) * crossAxisSpacing)) /
                    crossAxisCount;
                double finalSize = min(cellHeight, cellWidth);
                double childAspectRatio = cellWidth / cellHeight;

                return GridView.builder(
                  itemCount: 30,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: crossAxisSpacing,
                      childAspectRatio: childAspectRatio),
                  itemBuilder: (ctx, idx) {
                    int cellNumber = 30 - idx;
                    bool p1Here = (30 - gameProvider.player1Position) == idx;
                    bool p2Here = (30 - gameProvider.player2Position) == idx;

                    bool isBonus = GameProvider.bonusCells.contains(cellNumber);
                    bool isTrap = GameProvider.trapCells.contains(cellNumber);

                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? CupertinoColors.systemBlue.withAlpha(25)
                            : CupertinoColors.systemBlue.withAlpha(12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$cellNumber",
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? CupertinoColors.systemBlue
                                          .withAlpha(225)
                                      : CupertinoColors.systemBlue
                                          .withAlpha(200),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          if (isBonus)
                            const Positioned(
                                top: 2,
                                right: 2,
                                child: Icon(Icons.star,
                                    color: Colors.amber, size: 12)),
                          if (isTrap)
                            const Positioned(
                                top: 2,
                                right: 2,
                                child: Icon(Icons.warning_amber_rounded,
                                    color: Colors.redAccent, size: 12)),
                          if (p1Here && p2Here)
                            const Center(
                                child: Iconify(Ion.heart,
                                    color: Colors.red, size: 28))
                          else if (p1Here)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blue, width: 2)),
                                child: const Iconify(Ion.male_sharp,
                                    color: Colors.blue, size: 20),
                              ),
                            )
                          else if (p2Here)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.pink.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.pink, width: 2)),
                                child: const Iconify(Ion.female_sharp,
                                    color: Colors.pink, size: 20),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          // 3. BOTTOM PANEL
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            decoration: BoxDecoration(
              color: color.getScaffoldColor(),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              //  mainAxisSize: MainAxisSize.min,
              children: [
                if (isWaiting)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CupertinoActivityIndicator(),
                      const SizedBox(width: 10),
                      Text(lang.getText('waiting_partner'),
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )
                else ...[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: color.placeHolders().withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: color
                                  .navBarIconActiveColor()
                                  .withOpacity(0.1))),
                      child: AutoSizeText(
                        gameProvider.task,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: color.navBarIconActiveColor()),
                        maxLines: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            gameProvider.isMyTurn
                                ? lang.getText('your_turn')
                                : lang.getText('partner_turn'),
                            style: TextStyle(
                                color: gameProvider.isMyTurn
                                    ? Colors.green
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          Icon(
                            gameProvider.currentPlayer == 1
                                ? Icons.male
                                : Icons.female,
                            color: gameProvider.currentPlayer == 1
                                ? Colors.blue
                                : Colors.pink,
                            size: 30,
                          )
                        ],
                      ),
                      Opacity(
                        opacity:
                            (gameProvider.isMyTurn && !isWaiting) ? 1.0 : 0.5,
                        child: IgnorePointer(
                          ignoring: (!gameProvider.isMyTurn ||
                              isWaiting ||
                              gameProvider.status == 'finished'),
                          child: const DiceRollerPage(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(
      String label, String icon, int score, bool isActive) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.5,
      child: Consumer<ColorsProvider>(builder: (context, color, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Iconify(icon,
                size: 20, color: color.navBarIconActiveColor().withAlpha(170)),
            const SizedBox(width: 18),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 10, color: color.navBarIconActiveColor())),
                Text("$score",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: color.navBarIconActiveColor())),
              ],
            ),
          ],
        );
      }),
    );
  }
}

// ------------------ DICE ROLLER (Unchanged) ------------------
class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});
  @override
  State<DiceRollerPage> createState() => _DiceRollerPageState();
}

class _DiceRollerPageState extends State<DiceRollerPage>
    with TickerProviderStateMixin {
  int _finalDiceValue = 1;
  int _currentDiceValue = 1;
  late AnimationController _controller;
  late Animation<double> _rotationX;
  late Animation<double> _rotationY;
  Timer? _randomizerTimer;
  final _diceIcons = [
    Mdi.dice_1,
    Mdi.dice_2,
    Mdi.dice_3,
    Mdi.dice_4,
    Mdi.dice_5,
    Mdi.dice_6
  ];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _rotationX = Tween<double>(begin: 0, end: 0).animate(_controller);
    _rotationY = Tween<double>(begin: 0, end: 0).animate(_controller);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _randomizerTimer?.cancel();
        setState(() {
          _currentDiceValue = _finalDiceValue;
        });
        final content = context.read<ContentProvider>();
        await context
            .read<GameProvider>()
            .advancePlayer(_finalDiceValue, content.mazeData);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _randomizerTimer?.cancel();
    super.dispose();
  }

  void _rollDice() {
    if (_controller.isAnimating) return;
    setState(() {
      _finalDiceValue = Random().nextInt(6) + 1;
      double spinsX = Random().nextInt(2) + 2.0;
      double spinsY = Random().nextInt(2) + 2.0;
      if (Random().nextBool()) spinsX = -spinsX;
      if (Random().nextBool()) spinsY = -spinsY;
      _rotationX = Tween<double>(begin: 0, end: spinsX * 2 * pi).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
      _rotationY = Tween<double>(begin: 0, end: spinsY * 2 * pi).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
      _controller.reset();
    });
    _randomizerTimer?.cancel();
    _randomizerTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentDiceValue = Random().nextInt(6) + 1;
      });
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(_rotationX.value)
          ..rotateY(_rotationY.value);
        return GestureDetector(
          onTap: _rollDice,
          child: Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey.shade100, Colors.grey.shade300])),
              child: Center(
                  child: Iconify(_diceIcons[_currentDiceValue - 1],
                      size: 50, color: Colors.black87)),
            ),
          ),
        );
      },
    );
  }
}
