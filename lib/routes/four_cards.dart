import 'package:curve/api/colors_provider.dart';
import 'package:curve/api/responsive.dart';
import 'package:curve/logs/4_cards_task.dart';
import 'package:curve/models/four_card_model.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class FourCards extends StatefulWidget {
  const FourCards({super.key});

  @override
  State<FourCards> createState() => _FourCardsState();
}

class _FourCardsState extends State<FourCards> with TickerProviderStateMixin {
  // Words to show on each card
  List<FourCardModel> words = List.generate(4, ((_) => FourCardModel()));

  // Keep track of whether the task card is being shown.
  bool _showTask = false;
  String _selectedTask = "";
  String _selectedCard = "";

  // Animation controllers for flip animation
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _onCardTap(String cardId, String task) async {
    setState(() {
      _selectedCard = cardId;
      _selectedTask = task;
    });
    // Start the flip animation
    await _flipController.forward();
    // After the flip is completed, show the overlay card
    setState(() {
      _showTask = true;
    });
  }

  void _closeTask() async {
    // Close the overlay card and flip back
    setState(() {
      _showTask = false;
    });
    words = List.generate(4, ((_) => FourCardModel()));
    await _flipController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("4 Cards"),
      ),
      body: Stack(
        children: [
          // Grid covering the main screen
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05,
                horizontal: Responsive.isMobile(context)
                    ? 0
                    : MediaQuery.of(context).size.width * 0.35),
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Responsive.isMobile(context) ? 4 : 10,
                crossAxisSpacing: Responsive.isMobile(context) ? 4 : 10,
                mainAxisExtent: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.height * 0.35
                    : MediaQuery.of(context).size.height * 0.3,
              ),
              scrollDirection: Responsive.isMobile(context)
                  ? Axis.vertical
                  : Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                String cardID = words[index].cardId;
                int cardNumber = words[index].cardNumber;
                String task = "";
                List<String> taskList = combinedTasks[cardNumber] ?? [];
                if (taskList.isNotEmpty) {
                  task = taskList[math.Random().nextInt(43)];
                }

                return GestureDetector(
                  onTap: !_showTask ? () => _onCardTap(cardID, task) : null,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      bool isSelected =
                          _selectedCard == cardID && _flipController.value > 0;

                      final flipValue = isSelected ? _flipAnimation.value : 0.0;
                      double angle =
                          flipValue * math.pi; // rotate from 0 to 180 degrees

                      if (!isSelected) {
                        angle = 0;
                      }

                      bool showBack = angle > math.pi / 2;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.85,
                              fit: BoxFit.fill,
                              image: AssetImage(
                                "assets/images/c${words[index].cardNumber}.jpg",
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(233),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: showBack
                                ? Container() // Once flipped beyond 90°, show the "back" (blank)
                                : Text(
                                    "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Blur background and overlay card
          if (_showTask)
            Positioned.fill(
              child: Stack(
                children: [
                  // ignore: deprecated_member_use
                  Container(color: Colors.black.withOpacity(0.4)),
                  // Blur effect
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                  // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                  // The task card
                  Center(
                    child: Consumer<ColorsProvider>(
                      builder: (context, color, _) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: color.taskCard(),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(90),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _selectedTask,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                             
                              const Text(
                                "Here is a task. Complete this challenge!",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                             
                              TextButton(
                                onPressed: _closeTask,
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
