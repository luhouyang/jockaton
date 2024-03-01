import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/pages/home_page.dart';
import 'package:macrohard/pages/main_page/navigation_usecase.dart';
import 'package:macrohard/pages/profile_page.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/user_usecase.dart';
import 'package:macrohard/utilities/my_audio.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_controller/volume_controller.dart';

// add color class
class MainColorScheme {
  Color bottomBar = Colors.blue[900]!;
  Color middleButton = Colors.tealAccent;
  Color activeColor = Colors.white;
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // torch controller
  bool _isTorch = false;
  int _torchIndex = 1;
  final torchController = TorchController();

  // forever play sound
  bool _isPlaySounds = false;

  // vibration
  bool _isVibration = false;

  // brightness
  bool _isBrightness = false;
  int _brightnessIndex = 1;
  Future<void> setBrightness() async {
    try {
      await ScreenBrightness.instance.setScreenBrightness(
          (_brightnessIndex % 2 == 0) ? 0.5 : Random().nextDouble());
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness.instance.resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  // extream crazy mode
  bool _isExtreme = false;
  Future<void> exCrazyButton() async {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    if (!_isExtreme) {
      crazyRGBUsecase.changeExtremeCrazy();
      crazyRGBUsecase.changeCrazy();
      _isExtreme = !_isExtreme;
      _isTorch = !_isTorch;
      _isPlaySounds = !_isPlaySounds;
      _isVibration = !_isVibration;
      _isBrightness = !_isBrightness;
      userUsecase.addWater(FirebaseAuth.instance.currentUser!.uid);
      _startTimer();
    } else {
      crazyRGBUsecase.changeExtremeCrazy();
      crazyRGBUsecase.changeCrazy();
      _isExtreme = !_isExtreme;
      _isTorch = !_isTorch;
      _isPlaySounds = !_isPlaySounds;
      _isVibration = !_isVibration;
      _isBrightness = !_isBrightness;
      _timer.cancel();
      Vibration.cancel();
      resetBrightness();
      if (await torchController.isTorchActive ?? false) {
        torchController.toggle();
      }
      mainColorScheme = MainColorScheme();
      if (!mounted) return;
      setState(() {});
    }
  }

  // copy paste this for color
  bool _isCrazyMode = false;
  MainColorScheme mainColorScheme = MainColorScheme();
  late Timer _timer;
  Future<void> _startTimer() async {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);

    if (_isVibration) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate();
      } else {
        _isVibration = false;
      }
    }

    _timer =
        Timer.periodic(Duration(milliseconds: Random().nextInt(50)), (timer) {
      if (!mounted) return;
      setState(() {
        // add every colour case
        mainColorScheme.bottomBar = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.blue[900]!, Random().nextDouble())!;
        mainColorScheme.middleButton = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.tealAccent, Random().nextDouble())!;
        mainColorScheme.activeColor = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.white, Random().nextDouble())!;
        if (_isTorch) {
          torchController.toggle(intensity: (_torchIndex % 2 == 0 ? 0.1 : 1.0));
          _torchIndex++;
        } else {
          _torchIndex = 1;
        }
        if (_isPlaySounds) {
          VolumeController().maxVolume();
          AssetsAudioPlayer.newPlayer()
              .open(Audio(MyAudio().getButtonPress()), autoStart: true);
        }
        if (_isVibration) {
          Vibration.vibrate();
        }
        if (_isBrightness) {
          setBrightness();
          _brightnessIndex++;
        } else {
          _brightnessIndex = 1;
        }
      });
    });
  }

  void crazyButton() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    if (!crazyRGBUsecase.isCrazyMode) {
      crazyRGBUsecase.changeCrazy();
      _isCrazyMode = crazyRGBUsecase.isCrazyMode;
      _startTimer();
    } else {
      crazyRGBUsecase.changeCrazy();
      _isCrazyMode = crazyRGBUsecase.isCrazyMode;
      _timer.cancel();
      mainColorScheme = MainColorScheme();
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _isCrazyMode = crazyRGBUsecase.isCrazyMode;
    if (_isCrazyMode) {
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_isCrazyMode || _isExtreme) _timer.cancel();
    super.dispose();
  }
  // color code ends here

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationUseCase>(
      builder: (context, navUseCase, child) {
        return Scaffold(
          backgroundColor: _isCrazyMode || _isExtreme
              ? mainColorScheme.middleButton
              : Colors.white,
          body: Stack(
            children: [
              SizedBox(
                child: changePage(navUseCase.bottomNavigationIdx),
              ),
              Positioned(
                top: 25,
                right: 10,
                child: IconButton(
                  iconSize: 45,
                  onPressed: () => crazyButton(),
                  icon: Icon(
                    Icons.warning_amber_rounded,
                    color: mainColorScheme.bottomBar,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              foregroundColor: mainColorScheme.bottomBar,
              backgroundColor: mainColorScheme.middleButton,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                exCrazyButton();
              },
              tooltip: 'Start/Stop sensing',
              child: const Icon(Icons.donut_large_sharp)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: mainColorScheme.bottomBar,
            selectedItemColor: mainColorScheme.activeColor,
            unselectedItemColor: mainColorScheme.activeColor.withOpacity(0.4),
            currentIndex: navUseCase.bottomNavigationIdx,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: "home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "profile")
            ],
            onTap: (index) => navUseCase.changeIdx(index),
          ),
        );
      },
    );
  }

  Widget changePage(int idx) {
    if (idx == 0) {
      return const HomePage();
    } else {
      return const ProfilePage();
    }
  }
}
