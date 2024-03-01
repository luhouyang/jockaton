import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:macrohard/utilities/my_colors.dart';

class CrazyRGBUsecase extends ChangeNotifier {
  late Timer timer;
  int currentColorIndex = 0;
  Color currentColor = MyColors().gamingRGB[0];

  bool isCrazyMode = false;
  bool isExtremeCrazy = false;

  CrazyRGBUsecase() {
    timer =
        Timer.periodic(Duration(milliseconds: Random().nextInt(30)), (timer) {
      currentColorIndex = (currentColorIndex + Random().nextInt(50)) %
          MyColors().gamingRGB.length;
      currentColor = MyColors().gamingRGB[currentColorIndex];
      notifyListeners();
    });
  }

  void changeCrazy() {
    isCrazyMode = !isCrazyMode;
    notifyListeners();
  }

  void changeExtremeCrazy() {
    isExtremeCrazy = !!isExtremeCrazy;
    notifyListeners();
  }
}
