import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:curve/api/colors_provider.dart';
import 'package:curve/api/gird_provider.dart';
import 'package:curve/api/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:provider/provider.dart';

// ------------------ PROVIDER ------------------

class MazeGrid extends StatelessWidget {
  const MazeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Intimacy Maze"),
        actions: [
          IconButton(
            onPressed: () => gameProvider.reset(),
            icon: const Icon(CupertinoIcons.restart),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ColorsProvider>(builder: (context, color, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: 30,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isMobile(context) ? 5 : 10,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemBuilder: (ctx, idx) {
                    // Board cell number for this index:
                    int cellNumber = 30 - idx;

                    bool p1Here = (30 - gameProvider.player1Position) == idx;
                    bool p2Here = (30 - gameProvider.player2Position) == idx;

                    Color cellColor = color.cellColor();
                    String textToShow = "$cellNumber";

                    if (p1Here && p2Here) {
                      // Both players on same cell
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
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //color: CupertinoColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if ((textToShow == Ion.female_sharp) ||
                                (textToShow == Ion.male_sharp) ||
                                (textToShow == Ion.heart))
                              Iconify(textToShow,
                                  size: 60,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: color.placeHolders(),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        gameProvider.task,
                        maxLines: 3,
                      ),
                    )),
              ),
              SizedBox(
                  height: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.height * 0.03
                      : 0),
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
                          "${gameProvider.currentPlayer == 1 ? "Male" : "Female"} Turn"),
                    ],
                  ),
                  const SizedBox(width: 20),
                  const DiceRollerPage(),
                ],
              ),
              const SizedBox(height: 5)
            ],
          );
        }),
      ),
    );
  }
}

// ------------------ DICE ROLLER ------------------

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

    // Default rotations (will be reset on each roll)
    _rotationX = Tween<double>(begin: 0, end: 0).animate(_controller);
    _rotationY = Tween<double>(begin: 0, end: 0).animate(_controller);

    // When animation ends, finalize the dice face
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Stop cycling
        _randomizerTimer?.cancel();
        setState(() {
          _currentDiceValue = _finalDiceValue;
        });

        // Once dice stops, move the current player by finalDiceValue with animation
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
      // Choose a final face and random rotations
      _finalDiceValue = Random().nextInt(6) + 1;

      // Randomize how many spins (each spin ~ 2π)
      double spinsX = Random().nextInt(2) + 2; // between 2 and 3 full rotations
      double spinsY = Random().nextInt(2) + 2; // between 2 and 3 full rotations

      // Random direction: positive or negative rotation
      if (Random().nextBool()) spinsX = -spinsX;
      if (Random().nextBool()) spinsY = -spinsY;

      _rotationX = Tween<double>(begin: 0, end: spinsX * 2 * pi)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _rotationY = Tween<double>(begin: 0, end: spinsY * 2 * pi)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.reset();
    });

    // During the animation, rapidly change the dice face to simulate tumbling
    _randomizerTimer?.cancel();
    _randomizerTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Set a random face while rolling
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
        // Apply 3D-like transforms. A perspective transform adds realism.
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
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
                size: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.05,
                color: color.diceColor(),
              );
            }),
          ),
        );
      },
    );
  }
}
