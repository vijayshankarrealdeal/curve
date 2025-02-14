import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class ScratchProvider extends ChangeNotifier {
  double _scratchProgress = 0.0;
  double get srcathcProgress => _scratchProgress;

  bool _thresholdReached = false;
  bool get thresholdReached => _thresholdReached;
  bool animationEnded = false;
  void updateScratchProgress(double progress) {
    _scratchProgress = progress;
    notifyListeners();
  }

  void setThresholdReached() {
    _thresholdReached = true;
    notifyListeners();
  }

  void endAnimation(LottieComposition composition) async{
    Future.delayed(composition.duration, () {
      animationEnded = true;
      notifyListeners();
    });
  }

  void resetProgress() {
    _scratchProgress = 0.0;
    _thresholdReached = false;
    animationEnded = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _scratchProgress = 0.0;
    _thresholdReached = false;
    animationEnded = false;
    super.dispose();
  }
}
