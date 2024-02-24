import 'dart:async';
import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/auth/login_page.dart';
import 'package:macrohard/pages/home_page.dart';
import 'package:macrohard/pages/main_page/navigation_usecase.dart';
import 'package:macrohard/pages/profile_page.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // copy paste this for color
  LoginColorScheme loginColorScheme = LoginColorScheme();
  late Timer _timer;
  void _startTimer() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      debugPrint("crazy");
      setState(() {
        // add every colour case
        loginColorScheme.h1Text = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.blue[900]!, Random().nextDouble())!;
        loginColorScheme.linkText = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.lightBlue[200]!, Random().nextDouble())!;
        loginColorScheme.normalText = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.black, Random().nextDouble())!;
        loginColorScheme.border = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.lightBlue, Random().nextDouble())!;
        loginColorScheme.shadow = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.grey, Random().nextDouble())!;
        loginColorScheme.button = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.tealAccent, Random().nextDouble())!;
      });
    });
  }

  void crazyButton() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    if (!crazyRGBUsecase.isCrazyMode) {
      crazyRGBUsecase.changeCrazy();
      _startTimer();
    } else {
      crazyRGBUsecase.changeCrazy();
      _timer.cancel();
      loginColorScheme = LoginColorScheme();
      setState(() {});
    }
  }

  @override
  void dispose() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    if (crazyRGBUsecase.isCrazyMode) _timer.cancel();
    super.dispose();
  }
  // color code ends here
  
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationUseCase>(
      builder: (context, navUseCase, child) {
        return Scaffold(
          body: SizedBox(
            child: changePage(navUseCase.bottomNavigationIdx),
          ),
          floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.blue[900],
              backgroundColor: Colors.tealAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                // stop sound and flashing
              },
              tooltip: 'Start/Stop sensing',
              child: const Icon(Icons.donut_large_sharp)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
              backgroundColor: Colors.blue[900],
              activeColor: Colors.white,
              inactiveColor: Colors.white.withOpacity(0.4),
              activeIndex: navUseCase.bottomNavigationIdx,
              icons: const [
                Icons.home_filled,
                Icons.person,
              ],
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              blurEffect: true,
              leftCornerRadius: 20,
              rightCornerRadius: 20,
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
