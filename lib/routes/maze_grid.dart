import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/gird_provider.dart';
import 'package:curve/services/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ion.dart';
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _joinGame() async {
    if (_codeController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter 6-digit code")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await context.read<GameProvider>().joinGame(_codeController.text.trim());
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _playOffline() {
    context.read<GameProvider>().startOfflineGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intimacy Maze")),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              // Fix for Desktop: Constrain width
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.heart_circle_fill, size: 80, color: Colors.pink),
                    const SizedBox(height: 20),
                    const Text("Play with your partner",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    
                    // OFFLINE BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: _playOffline,
                        child: const Text("Play Offline (Local)"),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text("- OR ONLINE -", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: Colors.blueAccent,
                        onPressed: _createGame,
                        child: _isLoading 
                          ? const CupertinoActivityIndicator(color: Colors.white) 
                          : const Text("Create Online Room"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "Enter 6-digit Room Code",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 15)
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: Colors.grey.shade800,
                        onPressed: _joinGame,
                        child: const Text("Join Room", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
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

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final isWaiting = gameProvider.status == 'waiting';

    // Listener for Special Events (Traps/Bonus)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameProvider.specialEvent.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(gameProvider.specialEvent),
            backgroundColor: gameProvider.specialEvent.contains("TRAP") ? Colors.red : Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // Clear event locally after showing prevents loop
        // (In a real app, you'd manage this state better, but this works for simple rebuilds)
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Intimacy Maze", style: TextStyle(fontSize: 16)),
            Text(gameProvider.isMultiplayer ? "Room: ${gameProvider.roomId}" : "Offline Mode", 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (gameProvider.isMultiplayer)
            IconButton(
              onPressed: () {
                 Clipboard.setData(ClipboardData(text: gameProvider.roomId ?? ""));
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text("Room code copied!"))
                 );
              },
              icon: const Icon(Icons.copy),
            ),
          IconButton(
            onPressed: () => gameProvider.reset(),
            icon: const Icon(CupertinoIcons.power),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // Desktop Constraint
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ColorsProvider>(builder: (context, color, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- SCOREBOARD ---
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: color.placeHolders().withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Iconify(Ion.male_sharp, color: color.playerIcons("m"), size: 20),
                          Text("Player 1: ${gameProvider.p1Score}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        Column(children: [
                          Iconify(Ion.female_sharp, color: color.playerIcons("f"), size: 20),
                          Text("Player 2: ${gameProvider.p2Score}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // --- THE GRID ---
                  Expanded(
                    child: GridView.builder(
                      itemCount: 30,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isMobile(context) ? 5 : 6,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      itemBuilder: (ctx, idx) {
                        int cellNumber = 30 - idx;
                        bool p1Here = (30 - gameProvider.player1Position) == idx;
                        bool p2Here = (30 - gameProvider.player2Position) == idx;

                        Color cellColor = color.cellColor();
                        
                        // Highlight special cells
                        if (cellNumber % 5 == 0) cellColor = Colors.green.withOpacity(0.3); // Bonus
                        if (cellNumber % 7 == 0) cellColor = Colors.red.withOpacity(0.3); // Trap

                        String textToShow = "$cellNumber";

                        if (p1Here && p2Here) {
                          cellColor = color.playerCell("s");
                          textToShow = Ion.heart;
                        } else if (p1Here) {
                          cellColor = color.playerCell("m");
                          textToShow = Ion.male_sharp;
                        } else if (p2Here) {
                          cellColor = color.playerCell("f");
                          textToShow = Ion.female_sharp;
                        }

                        return GridTile(
                          child: Container(
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(12),
                              border: (p1Here || p2Here) ? Border.all(color: Colors.white, width: 2) : null
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if ((textToShow != Ion.female_sharp) &&
                                    (textToShow != Ion.male_sharp) &&
                                    (textToShow != Ion.heart))
                                  Text(
                                    textToShow,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                if ((textToShow == Ion.female_sharp) ||
                                    (textToShow == Ion.male_sharp) ||
                                    (textToShow == Ion.heart))
                                  Iconify(textToShow,
                                      size: 30,
                                      color: textToShow == Ion.heart
                                          ? color.playerIcons("s")
                                          : textToShow != Ion.female_sharp
                                              ? color.playerIcons("m")
                                              : color.playerIcons("f")),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // --- WAITING MSG ---
                  if (isWaiting)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 10),
                      color: Colors.amber.shade100,
                      child: Row(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Room: ${gameProvider.roomId}\nWaiting for partner to join...",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // --- TASK AREA ---
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                        key: ValueKey<String>(gameProvider.task),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: color.placeHolders(),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color.seedColorColor().withOpacity(0.3))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AutoSizeText(
                            gameProvider.task,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // --- CONTROLS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Iconify(
                              gameProvider.currentPlayer == 1
                                  ? Ion.male_sharp
                                  : Ion.female_sharp,
                              size: 45,
                              color: gameProvider.currentPlayer == 1
                                  ? color.playerIcons("m")
                                  : color.playerIcons("f")),
                          Text(
                              gameProvider.isMyTurn 
                              ? "YOUR TURN" 
                              : "PARTNER'S TURN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: gameProvider.isMyTurn ? Colors.green : Colors.grey
                              ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Opacity(
                        opacity: (gameProvider.isMyTurn && !isWaiting) ? 1.0 : 0.4,
                        child: IgnorePointer(
                          ignoring: (!gameProvider.isMyTurn || isWaiting),
                          child: const DiceRollerPage(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ------------------ DICE ROLLER (SAME AS BEFORE) ------------------
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
    Bi.dice_1_fill,
    Bi.dice_2_fill,
    Bi.dice_3_fill,
    Bi.dice_4_fill,
    Bi.dice_5_fill,
    Bi.dice_6_fill,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rotationX = Tween<double>(begin: 0, end: 0).animate(_controller);
    _rotationY = Tween<double>(begin: 0, end: 0).animate(_controller);

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _randomizerTimer?.cancel();
        setState(() {
          _currentDiceValue = _finalDiceValue;
        });
        await context.read<GameProvider>().advancePlayer(_finalDiceValue);
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
      _rotationX = Tween<double>(begin: 0, end: spinsX * 2 * pi)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _rotationY = Tween<double>(begin: 0, end: spinsY * 2 * pi)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
    final currentIcon = _diceIcons[_currentDiceValue - 1];
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(_rotationX.value)
          ..rotateY(_rotationY.value);

        return GestureDetector(
          onTap: _rollDice,
          child: Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Consumer<ColorsProvider>(builder: (context, color, _) {
              return Iconify(
                currentIcon,
                size: 60, 
                color: color.diceColor(),
              );
            }),
          ),
        );
      },
    );
  }
}