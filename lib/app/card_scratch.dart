import 'package:cached_network_image/cached_network_image.dart';
import 'package:curve/services/colors_provider.dart';
import 'package:curve/services/scratch_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

class CardScratch extends StatelessWidget {
  const CardScratch({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScratcherState> key = GlobalKey();

    // Placeholder URL or your future Firebase URL
    // Note: Pinterest URLs often block CORS on web.
    // See instructions below on how to run to fix this.
    final String imageUrl =
        "https://nyc.cloud.appwrite.io/v1/storage/buckets/696a6c5f00017c372cdc/files/696a6c77002ad9eaf43d/view?project=696a6c4a00150de3707a&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbklkIjoiNjk2YTZjYmFiN2M2ZmExZWMyZmYiLCJyZXNvdXJjZUlkIjoiNjk2YTZjNWYwMDAxN2MzNzJjZGM6Njk2YTZjNzcwMDJhZDllYWY0M2QiLCJyZXNvdXJjZVR5cGUiOiJmaWxlcyIsInJlc291cmNlSW50ZXJuYWxJZCI6Ijg3MTk0OjIiLCJpYXQiOjE3Njg1ODIzMzB9.oynTFTDxlq5vZdiFgvE4XqAFmGjQl0nXTb-Iyyqxzkk";

    return Consumer<ScratchProvider>(builder: (context, scPro, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Odyssey"),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          final size = constraint.maxWidth * 0.9;
          return Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      Consumer<ColorsProvider>(builder: (context, colorPro, _) {
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
                  }),
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
              scPro.thresholdReached
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("Know More"),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          );
        }),
        floatingActionButton: scPro.thresholdReached
            ? FloatingActionButton(
                child: const Icon(
                  CupertinoIcons.refresh,
                ),
                onPressed: () {
                  key.currentState?.reset();
                  scPro.resetProgress();
                },
              )
            : null,
      );
    });
  }
}
