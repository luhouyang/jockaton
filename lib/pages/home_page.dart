import 'dart:async';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/firestore_database.dart';
import 'package:macrohard/services/user_usecase.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomeColorScheme {
  Color grey = Colors.grey[300]!;
  Color h1TextColor = Colors.blue[900]!;
  Color waterIconColor = Colors.cyanAccent;
  Color button = Colors.tealAccent;
}

class _HomePageState extends State<HomePage> {
  bool _isCrazyMode = false;
  HomeColorScheme homeColorScheme = HomeColorScheme();
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
        homeColorScheme.grey = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.grey[300]!, Random().nextDouble())!;
        homeColorScheme.h1TextColor = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.blue[900]!, Random().nextDouble())!;
        homeColorScheme.waterIconColor = Color.lerp(
            crazyRGBUsecase.currentColor,
            Colors.cyanAccent,
            Random().nextDouble())!;
        homeColorScheme.button = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.tealAccent, Random().nextDouble())!;
      });
    });
  }

  Future<void> getUserData() async {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    if (userUsecase.userEntity.name == "name" &&
        userUsecase.userEntity.favouriteFood == "favourite food" &&
        userUsecase.userEntity.funFact == "fun fact") {
      await userUsecase.setUser(await FirestoreDatabase()
          .getUser(FirebaseAuth.instance.currentUser!.uid));
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

    getUserData();

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
        homeColorScheme = HomeColorScheme();
        setState(() {});
      }
    }

    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];

    return Scaffold(
      backgroundColor:
          crazyRGBUsecase.isCrazyMode ? homeColorScheme.button : Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: userUsecase.userEntity.water / 100.0,
              center: Icon(Icons.water_drop_rounded,
                  size: 100, color: homeColorScheme.waterIconColor),
              footer: Text(
                "Your Water",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: homeColorScheme.h1TextColor),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: homeColorScheme.grey,
              progressColor: homeColorScheme.h1TextColor,
            ),
            const SizedBox(
              height: 20,
            ),
            CarouselSlider(
              options: CarouselOptions(),
              items: imgList
                  .map((item) => Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          color: homeColorScheme.grey,
                          boxShadow: [
                            BoxShadow(
                              color: homeColorScheme.grey,
                              blurRadius: 4,
                              offset: const Offset(4, 8), // Shadow position
                            ),
                          ],
                        ),
                        child: Center(
                            child: Image.network(item,
                                fit: BoxFit.cover,
                                color: homeColorScheme.button,
                                colorBlendMode: BlendMode.colorBurn,
                                height:
                                    MediaQuery.of(context).size.height * 0.7)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
