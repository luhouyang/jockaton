import 'dart:async';
import 'package:flutter/material.dart';
import 'package:macrohard/utilities/my_colors.dart';

class CrazyRGBUsecase extends ChangeNotifier {
  late Timer timer;
  int currentColorIndex = 0;
  Color currentColor = MyColors().gamingRGB[0];

  bool isCrazyMode = false;

  CrazyRGBUsecase() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      currentColorIndex =
          (currentColorIndex + 60) % MyColors().gamingRGB.length;
      currentColor = MyColors().gamingRGB[currentColorIndex];
      notifyListeners();
    });
  }

  void changeCrazy() {
    isCrazyMode = !isCrazyMode;
    notifyListeners();
  }
}
