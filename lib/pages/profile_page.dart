import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/auth/firebase_auth_services.dart';
import 'package:macrohard/entities/user_entity.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/firestore_database.dart';
import 'package:macrohard/services/user_usecase.dart';
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
  var foodTextController = TextEditingController();
  var factTextController = TextEditingController();

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
      await userUsecase.setUser(await FirestoreDatabase()
          .getUser(FirebaseAuth.instance.currentUser!.uid));
      nameTextController.text = userUsecase.userEntity.name;
      foodTextController.text = userUsecase.userEntity.favouriteFood;
      factTextController.text = userUsecase.userEntity.funFact;
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
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    nameTextController.text = userUsecase.userEntity.name;
    foodTextController.text = userUsecase.userEntity.favouriteFood;
    factTextController.text = userUsecase.userEntity.funFact;
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
        profileColorScheme = ProfileColorScheme();
        setState(() {});
      }
    }

    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      backgroundColor: crazyRGBUsecase.isCrazyMode
          ? profileColorScheme.button
          : Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 25,),
            Container(
              margin: const EdgeInsets.fromLTRB(75, 0, 75, 10),
              child: Stack(
                children: [
                  ClipOval(
                    child: Image.asset("assets/profile_placeholder.jpg"),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 10,
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: profileColorScheme.button,
                          child: Icon(
                            color: profileColorScheme.h1Text,
                            Icons.camera_enhance,
                            size: 35,
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
                                backgroundColor: MaterialStatePropertyAll(_isEditing
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
                                      water: userUsecase.userEntity.water,);
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
                                backgroundColor: MaterialStatePropertyAll(_isEditing
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
                          ],
                        )
                      : Column(
                          children: [
                            displayTextWidget(nameTextController.text),
                            displayTextWidget(foodTextController.text),
                            displayTextWidget(factTextController.text),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
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
        ));
  }
}
