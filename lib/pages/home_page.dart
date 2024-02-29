import 'dart:async';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/firestore_database.dart';
import 'package:macrohard/services/user_usecase.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
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
      userUsecase.setUser(await FirestoreDatabase()
          .getUser(FirebaseAuth.instance.currentUser!.uid));
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _isCrazyMode = crazyRGBUsecase.isCrazyMode;
    useOrientationSensor = crazyRGBUsecase.isCrazyMode;
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

  // orientation code
  bool useOrientationSensor = false;

  @override
  Widget build(BuildContext context) {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: true);
    if (_isCrazyMode != crazyRGBUsecase.isCrazyMode) {
      if (!_isCrazyMode) {
        _isCrazyMode = !_isCrazyMode;
        useOrientationSensor = crazyRGBUsecase.isCrazyMode;
        _startTimer();
      } else {
        _isCrazyMode = !_isCrazyMode;
        useOrientationSensor = crazyRGBUsecase.isCrazyMode;
        _timer.cancel();
        homeColorScheme = HomeColorScheme();
        setState(() {});
      }
    }

    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    final List<String> imgList = [
      'https://i.giphy.com/media/koUtwnvA3TY7C/200.gif',
      'https://i.giphy.com/media/mCRJDo24UvJMA/200.gif',
      'https://i.giphy.com/media/sIIhZliB2McAo/200.gif',
      'https://i.giphy.com/media/qwvOvda2TC5EY/200.gif',
      'https://i.giphy.com/media/uHox9Jm5TyTPa/200.gif',
      'https://i.giphy.com/media/hTh9bSbUPWMWk/200.gif',
      'https://i.giphy.com/media/euGq9pgXoOVJcVhwRF/200.gif',
      'https://i.giphy.com/media/JIX9t2j0ZTN9S/200.gif',
      'https://i.giphy.com/media/111ebonMs90YLu/200.gif',
      'https://i.giphy.com/media/8m4R4pvViWtRzbloJ1/200.gif',
      'https://i.giphy.com/media/cF7QqO5DYdft6/200.gif',
    ];

    Widget homeScreen() {
      return SingleChildScrollView(
        physics: useOrientationSensor ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 75,
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
                height: 60,
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
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: Image.network(item, loadingBuilder:
                                        (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              int maxHeight = 200;
                              int maxWidth = 200;
                              int dis = 40;
                              return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Stack(children: [
                                    LoadingAnimationWidget.hexagonDots(
                                        color: homeColorScheme.h1TextColor,
                                        size: 75),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.hexagonDots(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.beat(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.bouncingBall(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child:
                                          LoadingAnimationWidget.discreteCircle(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.dotsTriangle(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.fallingDot(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.flickr(
                                          rightDotColor: homeColorScheme.button,
                                          leftDotColor:
                                              homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child:
                                          LoadingAnimationWidget.fourRotatingDots(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child:
                                          LoadingAnimationWidget.halfTriangleDot(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.hexagonDots(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget
                                          .horizontalRotatingDots(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.inkDrop(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.newtonCradle(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child:
                                          LoadingAnimationWidget.prograssiveDots(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.stretchedDots(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget
                                          .threeArchedCircle(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget
                                          .threeRotatingDots(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.twistingDots(
                                          rightDotColor: homeColorScheme.button,
                                          leftDotColor:
                                              homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child:
                                          LoadingAnimationWidget.twoRotatingArc(
                                              color: homeColorScheme.h1TextColor,
                                              size: 75),
                                    ),
                                    Positioned(
                                      top:
                                          Random().nextDouble() * maxHeight - dis,
                                      left:
                                          Random().nextDouble() * maxWidth - dis,
                                      child: LoadingAnimationWidget.waveDots(
                                          color: homeColorScheme.h1TextColor,
                                          size: 75),
                                    ),
                                  ]));
                            },
                                    fit: BoxFit.fill,
                                    color: _isCrazyMode
                                        ? homeColorScheme.button
                                        : Colors.transparent,
                                    colorBlendMode: BlendMode.colorBurn,
                                    height:
                                        MediaQuery.of(context).size.height * 0.7))
                          ],
                        )))
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor:
            crazyRGBUsecase.isCrazyMode ? homeColorScheme.button : Colors.white,
        body: useOrientationSensor
            ? NativeDeviceOrientedWidget(
                landscape: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);
                  return homeScreen();
                },
                landscapeLeft: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight
                  ]);
                  return homeScreen();
                },
                landscapeRight: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft
                  ]);
                  return homeScreen();
                },
                portrait: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                  return homeScreen();
                },
                portraitUp: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitDown,
                  ]);
                  return homeScreen();
                },
                portraitDown: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  return homeScreen();
                },
                fallback: (context) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  return homeScreen();
                },
                useSensor: useOrientationSensor,
              )
            : () {
              SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
                return homeScreen();
              }());
  }
}
