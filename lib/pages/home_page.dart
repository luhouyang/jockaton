import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:macrohard/auth/firebase_auth_services.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class LoginColorScheme {
  Color button = Colors.tealAccent;
}

class _HomePageState extends State<HomePage> {
  bool _isCrazyMode = false;
  LoginColorScheme loginColorScheme = LoginColorScheme();
  late Timer _timer;
  void _startTimer() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _timer =
        Timer.periodic(Duration(milliseconds: Random().nextInt(30)), (timer) {
      debugPrint("crazy");
      if (!mounted) return;
      setState(() {
        // add every colour case
        loginColorScheme.button = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.tealAccent, Random().nextDouble())!;
      });
    });
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
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: true);
    if (_isCrazyMode != crazyRGBUsecase.isCrazyMode) {
      if (!_isCrazyMode) {
      _isCrazyMode = !_isCrazyMode;
      _startTimer();
    } else {
      _isCrazyMode = !_isCrazyMode;
      _timer.cancel();
      loginColorScheme = LoginColorScheme();
      setState(() {});
    }
    }

    return Scaffold(
      backgroundColor:
          crazyRGBUsecase.isCrazyMode ? loginColorScheme.button : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  await FirebaseAuthServices().logout();
                },
                child: const Text("LOGOUT"))
          ],
        ),
      ),
    );
  }
}
