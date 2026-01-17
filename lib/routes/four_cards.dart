import 'package:curve/models/four_card_model.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/content_provider.dart';
import 'package:curve/services/language_provider.dart';
import 'package:curve/services/responsive.dart';
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
  List<FourCardModel> words = List.generate(4, ((_) => FourCardModel()));
  bool _showTask = false;
  String _selectedTask = "";
  String _selectedCard = "";
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.easeInOut));
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
    await _flipController.forward();
    setState(() {
      _showTask = true;
    });
  }

  void _closeTask() async {
    setState(() {
      _showTask = false;
    });
    words = List.generate(4, ((_) => FourCardModel()));
    await _flipController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final content = Provider.of<ContentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang.getText('4_cards'))),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05,
                horizontal: Responsive.isMobile(context)
                    ? 0
                    : MediaQuery.of(context).size.width * 0.35),
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0), // Increased padding
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15, // Better spacing
                crossAxisSpacing: 15,
                childAspectRatio: 0.7, // Adjust aspect ratio for card shape
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                String cardID = words[index].cardId;
                int cardNumber = words[index].cardNumber;
                String task = "";

                List<String> taskList = content.fourCardsData[cardNumber] ?? [];

                if (taskList.isNotEmpty) {
                  task = taskList[math.Random().nextInt(taskList.length)];
                } else {
                  task = "Loading...";
                }

                return GestureDetector(
                  onTap: !_showTask ? () => _onCardTap(cardID, task) : null,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      bool isSelected =
                          _selectedCard == cardID && _flipController.value > 0;
                      final flipValue = isSelected ? _flipAnimation.value : 0.0;
                      double angle = flipValue * math.pi;
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
                              opacity: 0.9,
                              // CHANGED: Use BoxFit.cover to fix stretching
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/images/c${words[index].cardNumber}.jpg"),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(2, 4))
                            ],
                          ),
                          child: Center(
                            child: showBack
                                ? Container() // Shows "back" (blank)
                                : const SizedBox(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Overlay Task Card
          if (_showTask)
            Positioned.fill(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _closeTask, // Close on background tap
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.transparent),
                  ),
                  Center(
                    child:
                        Consumer<ColorsProvider>(builder: (context, color, _) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        constraints:
                            const BoxConstraints(maxWidth: 400, maxHeight: 500),
                        decoration: BoxDecoration(
                          color: color.taskCard(),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(90),
                                blurRadius: 15,
                                offset: const Offset(0, 5))
                          ],
                        ),
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite,
                                color: Colors.pinkAccent, size: 40),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _selectedTask,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              lang.getText('task_prompt'),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: color
                                      .navBarIconActiveColor()
                                      .withOpacity(0.6)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _closeTask,
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Text(lang.getText('close')),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
