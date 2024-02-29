import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macrohard/auth/firebase_auth_services.dart';
import 'package:macrohard/entities/user_entity.dart';
import 'package:macrohard/pages/edit_profile_image.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/firestore_database.dart';
import 'package:macrohard/services/user_usecase.dart';
import 'package:macrohard/utilities/my_audio.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

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
  var foodTextController = TextEditingController();
  var factTextController = TextEditingController();
  var waterTextController = TextEditingController();
  double _currentSliderValue = 20.0;

  bool _isEditing = false;

  // copy paste this for color
  bool _isCrazyMode = false;
  ProfileColorScheme profileColorScheme = ProfileColorScheme();
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
        profileColorScheme.h1Text = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.blue[900]!, Random().nextDouble())!;
        profileColorScheme.linkText = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.lightBlue[200]!, Random().nextDouble())!;
        profileColorScheme.normalText = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.black, Random().nextDouble())!;
        profileColorScheme.border = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.lightBlue, Random().nextDouble())!;
        profileColorScheme.shadow = Color.lerp(
            crazyRGBUsecase.currentColor, Colors.grey, Random().nextDouble())!;
        profileColorScheme.button = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.tealAccent, Random().nextDouble())!;
        profileColorScheme.textFeild = Color.lerp(crazyRGBUsecase.currentColor,
            Colors.purple, Random().nextDouble())!;
      });
    });
  }

  Future<void> getUserData() async {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    if (userUsecase.userEntity.name == "name" &&
        userUsecase.userEntity.favouriteFood == "favourite food" &&
        userUsecase.userEntity.funFact == "fun fact") {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await userUsecase.setUser(await FirestoreDatabase().getUser(uid), uid);
      nameTextController.text = userUsecase.userEntity.name;
      foodTextController.text = userUsecase.userEntity.favouriteFood;
      factTextController.text = userUsecase.userEntity.funFact;
      waterTextController.text = userUsecase.userEntity.water.toString();
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    CrazyRGBUsecase crazyRGBUsecase =
        Provider.of<CrazyRGBUsecase>(context, listen: false);
    _isCrazyMode = crazyRGBUsecase.isCrazyMode;
    useOrientationSensor = crazyRGBUsecase.isCrazyMode;
    if (_isCrazyMode) {
      _startTimer();
    }

    getUserData();
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    nameTextController.text = userUsecase.userEntity.name;
    foodTextController.text = userUsecase.userEntity.favouriteFood;
    factTextController.text = userUsecase.userEntity.funFact;
    waterTextController.text = userUsecase.userEntity.water.toString();

    VolumeController().maxVolume();
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
        // max volume & play random audio
        VolumeController().maxVolume();
        AssetsAudioPlayer.newPlayer()
            .open(Audio(MyAudio().getButtonPress()), autoStart: true);
        _startTimer();
      } else {
        _isCrazyMode = !_isCrazyMode;
        useOrientationSensor = crazyRGBUsecase.isCrazyMode;
        _timer.cancel();
        profileColorScheme = ProfileColorScheme();
        // max volume & play random audio
        VolumeController().maxVolume();
        AssetsAudioPlayer.newPlayer()
            .open(Audio(MyAudio().getRandomAudio()), autoStart: true);
        setState(() {});
      }
    }

    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    Widget profileScreen() {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(75, 0, 75, 10),
              child: Stack(
                children: [
                  ClipOval(
                      child: (userUsecase.userEntity.profileImage == null ||
                              userUsecase.userEntity.profilePic == "")
                          ? Image.asset(
                              "assets/profile_placeholder.jpg",
                              color: _isCrazyMode
                                  ? profileColorScheme.h1Text
                                  : Colors.transparent,
                              colorBlendMode: BlendMode.colorBurn,
                            )
                          : Image.memory(userUsecase.userEntity.profileImage!)),
                  Positioned(
                      right: 10,
                      bottom: 10,
                      child: ClipOval(
                        child: InkWell(
                          onHover: (value) {},
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const EditProfileImage(),
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: profileColorScheme.button,
                            child: Icon(
                              color: profileColorScheme.h1Text,
                              Icons.camera_enhance,
                              size: 35,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuthServices().logout();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(_isEditing
                                      ? Colors.blue[100]
                                      : _isCrazyMode
                                          ? profileColorScheme.textFeild
                                          : profileColorScheme.button)),
                          child: Text(
                            "LOGOUT",
                            style:
                                TextStyle(color: profileColorScheme.normalText),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            setState(() {
                              if (_isEditing) {
                                UserEntity newUserEntity = UserEntity(
                                  name: nameTextController.text,
                                  favouriteFood: foodTextController.text,
                                  funFact: factTextController.text,
                                  interval: userUsecase.userEntity.interval,
                                  water: userUsecase.userEntity.water,
                                  profilePic: userUsecase.userEntity.profilePic,
                                );
                                FirestoreDatabase().setUser(newUserEntity, uid);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: profileColorScheme.shadow,
                                    content: Text(
                                      "Editing Mode",
                                      style: TextStyle(
                                          color: _isCrazyMode
                                              ? profileColorScheme.linkText
                                              : Colors.white),
                                    ),
                                  ),
                                );
                              }
                              _isEditing = !_isEditing;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(_isEditing
                                      ? Colors.blue[100]
                                      : _isCrazyMode
                                          ? profileColorScheme.textFeild
                                          : profileColorScheme.button)),
                          child: Text(
                            _isEditing ? "Save" : "Edit",
                            style:
                                TextStyle(color: profileColorScheme.normalText),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _isEditing
                      ? Column(
                          children: [
                            inputTextWidget(
                                "name", textVerify, nameTextController),
                            inputTextWidget("favourite food", textVerify,
                                foodTextController),
                            inputTextWidget(
                                "fun fact", textVerify, factTextController),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Slider(
                                value: _currentSliderValue,
                                max: 60,
                                divisions: 5,
                                label: _currentSliderValue.round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    waterTextController.text =
                                        _currentSliderValue.toString();
                                    _currentSliderValue = value;
                                  });
                                },
                              ),
                            ),
                            waterTimerWidget(),
                          ],
                        )
                      : Column(
                          children: [
                            displayTextWidget(nameTextController.text),
                            displayTextWidget(foodTextController.text),
                            displayTextWidget(factTextController.text),
                            waterTimerWidget(),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: crazyRGBUsecase.isCrazyMode
                ? profileColorScheme.button
                : Colors.white,
            body: useOrientationSensor
                ? NativeDeviceOrientedWidget(
                    landscape: (context) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown
                      ]);
                      return profileScreen();
                    },
                    landscapeLeft: (context) {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeRight]);
                      return profileScreen();
                    },
                    landscapeRight: (context) {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                      return profileScreen();
                    },
                    portrait: (context) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft
                      ]);
                      return profileScreen();
                    },
                    portraitUp: (context) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                      ]);
                      return profileScreen();
                    },
                    portraitDown: (context) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                      return profileScreen();
                    },
                    fallback: (context) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      return profileScreen();
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
                    return profileScreen();
                  }()));
  }

  String textVerify(value) {
    return value != null ? "" : "Please enter a valid input";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFormField(
          validator: (value) => validator(value),
          controller: controller,
          style: TextStyle(color: profileColorScheme.h1Text),
          decoration: InputDecoration(
              filled: true,
              fillColor: _isCrazyMode
                  ? profileColorScheme.textFeild
                  : Colors.blue[100],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: profileColorScheme.border),
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusColor: profileColorScheme.linkText,
              hintText: hint,
              hintStyle: TextStyle(color: profileColorScheme.h1Text)),
        ),
      ),
    );
  }

  Widget displayTextWidget(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: _isCrazyMode ? profileColorScheme.textFeild : Colors.white,
            border: Border.all(color: profileColorScheme.border),
            borderRadius: BorderRadius.circular(16.0)),
        child: Text(
          text,
          style: TextStyle(color: profileColorScheme.h1Text),
        ),
      ),
    );
  }

  Widget waterTimerWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            color: _isEditing
                ? Colors.blue[100]
                : _isCrazyMode
                    ? profileColorScheme.textFeild
                    : Colors.white,
            border: Border.all(color: profileColorScheme.border),
            borderRadius: BorderRadius.circular(16.0)),
        child: Text(
          waterTextController.text,
          style: TextStyle(color: profileColorScheme.h1Text),
        ),
      ),
    );
  }
}
