import 'dart:math';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/content_provider.dart'; // Import ContentProvider
import 'package:curve/services/language_provider.dart';
import 'package:curve/services/responsive.dart';
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
  bool _showBack = false;
  String _currentTask = '';
  int itemSelectInt = Random().nextInt(10) + 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(begin: 0, end: pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Updated method to accept ContentProvider
  void _flipCard(LanguageProvider lang, ContentProvider content) async {
    if (_showBack) {
      await _controller.reverse();
      setState(() {
        _showBack = false;
        itemSelectInt = Random().nextInt(10) + 1;
      });
    } else {
      bool isTruth = Random().nextBool();
      String task;

      // USE PROVIDER DATA INSTEAD OF LOCAL LISTS
      if (isTruth) {
        if (content.truths.isNotEmpty) {
          task = content.truths[Random().nextInt(content.truths.length)];
        } else {
          task = "Loading tasks...";
        }
      } else {
        if (content.dares.isNotEmpty) {
          task = content.dares[Random().nextInt(content.dares.length)];
        } else {
          task = "Loading tasks...";
        }
      }

      setState(() {
        String prefix = isTruth ? lang.getText('truth') : lang.getText('dare');
        _currentTask = "$prefix: $task";
      });

      await _controller.forward();
      setState(() {
        _showBack = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final content =
        Provider.of<ContentProvider>(context); // Get ContentProvider

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
      10: Colors.blueGrey.shade100
    };

    return Scaffold(
      appBar: AppBar(title: Text(lang.getText('truth_dare'))),
      body: Center(
        child: GestureDetector(
          // Pass content provider to the method
          onTap: () => _flipCard(lang, content),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double rotationValue = _animation.value;
              final isFront = rotationValue < (pi / 2);
              final displayRotation =
                  isFront ? rotationValue : rotationValue - pi;

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
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
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: isFront
                            ? Text(lang.getText('tap_reveal'),
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
