import 'package:cached_network_image/cached_network_image.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/content_provider.dart'; // Import
import 'package:curve/services/scratch_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

class CardScratch extends StatelessWidget {
  const CardScratch({super.key});

  void _showKnowMoreDialog(BuildContext context, Map<String, String>? data) {
    if (data == null) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(data['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          data['desc']!, 
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScratcherState> key = GlobalKey();
    
    // Access Content
    final content = Provider.of<ContentProvider>(context);
    final cardData = content.currentScratchCard;
    final String imageUrl = cardData?['image'] ?? "https://via.placeholder.com/400"; // Fallback

    return Consumer<ScratchProvider>(builder: (context, scPro, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Odyssey"),
        ),
        body: Center(
          child: LayoutBuilder(builder: (context, constraint) {
            double size = constraint.maxWidth * 0.9;
            if (size > 500) size = 500; 

            return Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Consumer<ColorsProvider>(
                      builder: (context, colorPro, _) {
                        return Scratcher(
                          key: key,
                          color: scPro.thresholdReached
                              ? Colors.transparent
                              : colorPro.scratchCard(),
                          threshold: 45,
                          brushSize: 65,
                          onScratchEnd: () {},
                          onThreshold: () => scPro.setThresholdReached(),
                          onScratchUpdate: () {},
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: CupertinoColors.black,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
                (scPro.thresholdReached && (scPro.animationEnded == false))
                    ? Positioned(
                        bottom: 100,
                        right: 150,
                        child: SizedBox(
                          height: 200,
                          width: 400,
                          child: Lottie.asset("assets/animation/custom_made.json",
                              repeat: false,
                              width: 400, onLoaded: (composition) async {
                            scPro.endAnimation(composition);
                          }),
                        ),
                      )
                    : const SizedBox.shrink(),
                (scPro.thresholdReached && (scPro.animationEnded == false))
                    ? Positioned(
                        bottom: 2,
                        child: Lottie.asset("assets/animation/go_blue.json",
                            repeat: false),
                    )
                  : const SizedBox.shrink(),
              ],
            );
          }),
        ),
        floatingActionButton: scPro.thresholdReached
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () => _showKnowMoreDialog(context, cardData),
                    label: const Text("Know More"),
                    icon: const Icon(CupertinoIcons.info),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    child: const Icon(CupertinoIcons.refresh),
                    onPressed: () {
                      key.currentState?.reset();
                      scPro.resetProgress();
                    },
                  ),
                ],
              )
            : null,
      );
    });
  }
}