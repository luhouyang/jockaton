import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:provider/provider.dart';

// add color class
class ProfileColorScheme {
  Color h1Text = Colors.blue[900]!;
  Color linkText = Colors.lightBlue[200]!;
  Color normalText = Colors.black;
  Color border = Colors.lightBlue;
  Color shadow = Colors.grey;
  Color button = Colors.tealAccent;
  Color textFeild = Colors.purple;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var nameTextController = TextEditingController();

  bool _isEditing = false;

  // copy paste this for color
  bool _isCrazyMode = false;
  ProfileColorScheme profileColorScheme = ProfileColorScheme();
  late Timer _timer;
  void _startTimer() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      debugPrint("crazy");
      setState(() {
        // add every colour case
        profileColorScheme.h1Text = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.blue[900]!, Random().nextDouble())!;
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
      profileColorScheme = ProfileColorScheme();
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
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(75, 20, 75, 10),
            child: Stack(
              children: [
                ClipOval(
                  child: Image.asset("assets/profile_placeholder.jpg"),
                ),
                const Positioned(
                    right: 15,
                    bottom: 15,
                    child: Icon(
                      Icons.camera_enhance,
                      size: 35,
                    )),
              ],
            ),
          ),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(_isEditing ? "Save" : "Edit"),
                  ),
                _isEditing
                    ? Column(
                        children: [
                          inputTextWidget("name", textVerify, nameTextController)
                        ],
                      )
                    : Column(
                        children: [],
                      ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  String textVerify(value) {
    return value != null ? "" : "Please enter a valid input";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(
        validator: (value) => validator(value),
        controller: controller,
        style: TextStyle(color: profileColorScheme.h1Text),
        decoration: InputDecoration(
            filled: true,
            fillColor:
                _isCrazyMode ? profileColorScheme.textFeild : Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: profileColorScheme.border),
              borderRadius: BorderRadius.circular(32.0),
            ),
            focusColor: profileColorScheme.linkText,
            hintText: hint,
            hintStyle: TextStyle(color: profileColorScheme.h1Text)),
      ),
    );
  }
}
