import 'dart:math';

class MyAudio {
  String button = "assets/areyousure.mp3";
  List<String> audioAssets = [
    "assets/areyousure.mp3",
    "assets/hellounderwater.mp3",
    "assets/bingchilling.mp3",
    "assets/dadog.mp3",
    "assets/emotionaldmg.mp3",
    "assets/fbi.mp3"
  ];

  String getButtonPress() {
    return button;
  }

  String getRandomAudio() {
    return audioAssets[Random().nextInt(audioAssets.length)];
  }
}
