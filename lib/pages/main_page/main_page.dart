import 'dart:async';
import 'dart:math';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/pages/home_page.dart';
import 'package:macrohard/pages/main_page/navigation_usecase.dart';
import 'package:macrohard/pages/profile_page.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:provider/provider.dart';

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
  // copy paste this for color
  bool _isCrazyMode = false;
  MainColorScheme mainColorScheme = MainColorScheme();
  late Timer _timer;
  void _startTimer() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _timer =
        Timer.periodic(Duration(milliseconds: Random().nextInt(50)), (timer) {
      debugPrint("crazy");
      if (!mounted) return;
      setState(() {
        // add every colour case
        mainColorScheme.bottomBar = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.blue[900]!, Random().nextDouble())!;
        mainColorScheme.middleButton = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.tealAccent, Random().nextDouble())!;
        mainColorScheme.activeColor = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.white, Random().nextDouble())!;
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
    if (_isCrazyMode) _timer.cancel();
    super.dispose();
  }
  // color code ends here

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationUseCase>(
      builder: (context, navUseCase, child) {
        return Scaffold(
          backgroundColor:
              _isCrazyMode ? mainColorScheme.middleButton : Colors.white,
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
                // stop sound and flashing
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
              items: [BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "home"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile")],
              onTap: (index) => navUseCase.changeIdx(index)),
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
