import 'dart:math';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/responsive.dart';
import 'package:curve/logs/truth_dare_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TruthDareCardPage extends StatefulWidget {
  const TruthDareCardPage({super.key});

  @override
  State<TruthDareCardPage> createState() => _TruthDareCardPageState();
}

class _TruthDareCardPageState extends State<TruthDareCardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showBack = false; // Track which side of the card is shown
  String _currentTask = '';
  int itemSelectInt = Random().nextInt(10) + 1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Initially show some message or no task
    _currentTask = "Tap to Reveal";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() async {
    if (_showBack) {
      // If currently showing the back, we want to flip back to front
      // Reverse the animation
      await _controller.reverse();
      setState(() {
        _showBack = false;
        _currentTask = "Tap to Reveal";
        itemSelectInt = Random().nextInt(10) + 1;
      });
    } else {
      // If currently showing the front, we want to flip to back
      // Pick truth or dare randomly
      bool isTruth = Random().nextBool();
      String task;
      if (isTruth) {
        task = truths[Random().nextInt(truths.length)];
      } else {
        task = dares[Random().nextInt(dares.length)];
      }

      setState(() {
        _currentTask = (isTruth ? "Truth: " : "Dare: ") + task;
      });

      // Forward the animation to flip the card
      await _controller.forward();
      setState(() {
        _showBack = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = Responsive.isMobile(context)
        ? MediaQuery.of(context).size.width * 0.9
        : MediaQuery.of(context).size.width * 0.3;
    final cardHeight = Responsive.isMobile(context)
        ? MediaQuery.of(context).size.height * 0.6
        : MediaQuery.of(context).size.height;
    Map<int, Color> items = {
      1: Colors.brown.shade100,
      2: Colors.blue.shade100,
      3: Colors.green.shade100,
      4: Colors.brown.shade100,
      5: Colors.lightBlueAccent.shade100,
      6: Colors.brown.shade100,
      7: Colors.lightBlue.shade100,
      8: Colors.redAccent.shade100,
      9: Colors.blueAccent.shade100,
      10: Colors.blueGrey.shade100,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text("Truth or Dare"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // Rotate the card
              double rotationValue = _animation.value;
              // Check if we show front or back
              final isFront = rotationValue < (pi / 2);

              // We need to adjust the rotation so that
              // front and back show correctly (no mirror text)
              final displayRotation =
                  isFront ? rotationValue : rotationValue - pi;

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(displayRotation),
                alignment: Alignment.center,
                child: Consumer<ColorsProvider>(
                    builder: (context, colorProvide, _) {
                  return Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        opacity: 0.6,
                        image:
                            AssetImage("assets/images/love$itemSelectInt.jpg"),
                      ),
                      color: CupertinoColors.black,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: isFront
                            ? Text("Tap to Reveal",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: items[itemSelectInt],
                                      fontWeight: FontWeight.bold,
                                    ))
                            : Text(
                                _currentTask,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: items[itemSelectInt],
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
