import 'package:uuid/uuid.dart';
import 'dart:math' as math;

class FourCardModel {
  int cardNumber;
  String cardId;

  FourCardModel({int? cardNumber, String? cardId})
      : cardNumber = cardNumber ??
            math.Random().nextInt(4) + 1, // Use provided cardNumber or random
        cardId =
            cardId ?? const Uuid().v4(); // Generate unique UUID if not provided
}
