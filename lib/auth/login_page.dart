import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/auth/auth_usecase.dart';
import 'package:macrohard/auth/firebase_auth_services.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/user_usecase.dart';
import 'package:macrohard/utilities/my_audio.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

// add color class
class LoginColorScheme {
  Color h1Text = Colors.blue[900]!;
  Color linkText = Colors.lightBlue[200]!;
  Color normalText = Colors.black;
  Color border = Colors.lightBlue;
  Color shadow = Colors.grey;
  Color button = Colors.tealAccent;
  Color textFeild = Colors.purple;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var inEmailTextController = TextEditingController();
  var inPassTextController = TextEditingController();
  var upEmailTextController = TextEditingController();
  var upPassTextController = TextEditingController();

  bool _isSignIn = true;

  final _confetticontroller = ConfettiController();
  bool _confetPlay = false;

  // copy paste this for color
  bool _isCrazyMode = false;
  LoginColorScheme loginColorScheme = LoginColorScheme();
  late Timer _timer;
  void _startTimer() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _timer =
        Timer.periodic(Duration(milliseconds: Random().nextInt(30)), (timer) {
      if (!mounted) return;
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
        loginColorScheme.textFeild = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.red, Random().nextDouble())!;
      });
    });
  }

  void crazyButton() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    if (!crazyRGBUsecase.isCrazyMode) {
      crazyRGBUsecase.changeCrazy();
      _isCrazyMode = crazyRGBUsecase.isCrazyMode;
      // max volume & play random audio
        VolumeController().maxVolume();
        AssetsAudioPlayer.newPlayer()
            .open(Audio(MyAudio().getButtonPress()), autoStart: true);
      _startTimer();
    } else {
      crazyRGBUsecase.changeCrazy();
      _isCrazyMode = crazyRGBUsecase.isCrazyMode;
      // max volume & play random audio
        VolumeController().maxVolume();
        AssetsAudioPlayer.newPlayer()
            .open(Audio(MyAudio().getButtonPress()), autoStart: true);
      _timer.cancel();
      loginColorScheme = LoginColorScheme();
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
    _confetticontroller.dispose();
  }
  // color code ends here

  @override
  Widget build(BuildContext context) {
    AuthUseCase authUseCase = Provider.of<AuthUseCase>(context, listen: false);
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      backgroundColor: _isCrazyMode ? loginColorScheme.button : Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 150, 25, 150),
              decoration: BoxDecoration(
                color: _isCrazyMode ? loginColorScheme.border : Colors.white,
                border: Border.all(color: loginColorScheme.border, width: 1.0),
                borderRadius: BorderRadius.circular(32.0),
                boxShadow: [
                  BoxShadow(
                    color: loginColorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(4, 8), // Shadow position
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: _isSignIn
                  ? Column(
                      children: [
                        Text(
                          "SIGN IN",
                          style: TextStyle(
                              color: loginColorScheme.h1Text,
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        inputTextWidget(
                            "email", emailVerify, inEmailTextController),
                        inputTextWidget(
                            "password", passwordVerify, inPassTextController),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: "forgot password?",
                                      style: TextStyle(
                                          color: loginColorScheme.linkText),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          if (inEmailTextController
                                              .text.isNotEmpty) {
                                            FirebaseAuthServices()
                                                .forgotPassword(context,
                                                    inEmailTextController.text);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.blue[200],
                                                duration: const Duration(
                                                    milliseconds: 700),
                                                content: const Text(
                                                  "Enter your email",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            );
                                          }
                                        }))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 24, 0, 16),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    authUseCase.changeBool(true);
                                    await FirebaseAuthServices().signIn(
                                        context,
                                        inEmailTextController.text,
                                        inPassTextController.text,
                                        userUsecase);
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    authUseCase.changeBool(false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5.0),
                                    elevation: 5,
                                    shadowColor: loginColorScheme.shadow,
                                    backgroundColor: loginColorScheme.button,
                                  ),
                                  child: Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                        color: loginColorScheme.h1Text,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: loginColorScheme.h1Text, height: 2.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: RichText(
                              text: TextSpan(
                                  style: const TextStyle(fontSize: 16),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: "Create a new account ",
                                    style: TextStyle(
                                        color: loginColorScheme.normalText)),
                                TextSpan(
                                    text: "Here",
                                    style: TextStyle(
                                        color: loginColorScheme.linkText),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _isSignIn = !_isSignIn;
                                        setState(() {});
                                      })
                              ])),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: loginColorScheme.h1Text,
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        inputTextWidget(
                            "email", emailVerify, upEmailTextController),
                        inputTextWidget(
                            "password", passwordVerify, upPassTextController),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 24, 0, 16),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    authUseCase.changeBool(true);
                                    await FirebaseAuthServices().signUp(
                                        context,
                                        upEmailTextController.text,
                                        upPassTextController.text,
                                        userUsecase);
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    authUseCase.changeBool(false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5.0),
                                    elevation: 5,
                                    shadowColor: loginColorScheme.shadow,
                                    backgroundColor: loginColorScheme.button,
                                  ),
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        color: loginColorScheme.h1Text,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: loginColorScheme.h1Text, height: 2.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: RichText(
                              text: TextSpan(
                                  style: const TextStyle(fontSize: 16),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(
                                        color: loginColorScheme.normalText)),
                                TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                        color: loginColorScheme.linkText),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _isSignIn = !_isSignIn;
                                        setState(() {});
                                      })
                              ])),
                        ),
                      ],
                    ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                iconSize: 45,
                onPressed: () {
                  crazyButton();
                  if (_confetPlay) {
                    _confetticontroller.stop();
                  } else {
                    _confetticontroller.play();
                  }
                  _confetPlay = !_confetPlay;
                },
                icon: Icon(
                  Icons.warning_amber_rounded,
                  color: loginColorScheme.h1Text,
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: _confetticontroller,
              emissionFrequency: 0.9,
              blastDirection: pi / 2,
              numberOfParticles: 10,
            )
          ],
        ),
      ),
    ));
  }

  String emailVerify(value) {
    return EmailValidator.validate(value ?? "")
        ? ""
        : "Please enter a valid email";
  }

  String passwordVerify(value) {
    return value != null ? "" : "Please enter a valid password";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(
        validator: (value) => validator(value),
        controller: controller,
        style: TextStyle(color: loginColorScheme.h1Text),
        decoration: InputDecoration(
            filled: true,
            fillColor: _isCrazyMode ? loginColorScheme.textFeild : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: loginColorScheme.border),
              borderRadius: BorderRadius.circular(32.0),
            ),
            focusColor: loginColorScheme.linkText,
            hintText: hint,
            hintStyle: TextStyle(color: loginColorScheme.h1Text)),
      ),
    );
  }
}
