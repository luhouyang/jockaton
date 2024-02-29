import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macrohard/entities/user_entity.dart';
import 'package:macrohard/services/crazy_rgb_usecase.dart';
import 'package:macrohard/services/firestore_database.dart';
import 'package:macrohard/services/image_services.dart';
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

class EditProfileImage extends StatefulWidget {
  const EditProfileImage({super.key});

  @override
  State<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends State<EditProfileImage> {
  // image picking and cropping
  File? profilePicFile;
  Uint8List? profilePicBytes;

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final ImageServices imageServices = ImageServices();

  // crop selected image
  Future _cropImage(XFile pickedFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 1080,
          maxWidth: 1080,
          compressFormat:
              ImageCompressFormat.jpg, // maybe change later, test quality first
          compressQuality: 40,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));

      profilePicFile = File(croppedFile!.path);
      profilePicBytes = await profilePicFile!.readAsBytes();

      debugPrint(profilePicFile!.path);
      debugPrint(profilePicFile!.lengthSync().toString());

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // pick image from gallery
  Future getImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _cropImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // take picture with camera
  Future getImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        _cropImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // ui component for pick image button
  Widget _pickImageContainer() {
    return profilePicBytes == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: profileColorScheme.border)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  getImageFromGallery();
                                },
                                tooltip: 'Pick Image from gallery or Camera',
                                icon: const Icon(Icons.photo),
                              ),
                            ),
                            const Text("Gallery"),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  getImageFromCamera();
                                },
                                icon: const Icon(Icons.camera),
                              ),
                            ),
                            const Text("Camera"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: profileColorScheme.border)),
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Image.memory(profilePicBytes!),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left: -12,
                        child: IconButton(
                          onPressed: () {
                            profilePicFile = null;
                            profilePicBytes = null;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: _isCrazyMode
                                ? profileColorScheme.button
                                : Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  UserUsecase userUsecase =
                      Provider.of<UserUsecase>(context, listen: false);
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  UserEntity newUserEntity = UserEntity(
                    name: userUsecase.userEntity.name,
                    favouriteFood: userUsecase.userEntity.favouriteFood,
                    funFact: userUsecase.userEntity.funFact,
                    interval: userUsecase.userEntity.interval,
                    water: userUsecase.userEntity.water,
                    profilePic: "image${p.extension(profilePicFile!.path)}",
                  );
                  userUsecase.userEntity.profileImage = profilePicBytes!;
                  await FirestoreDatabase().setUser(newUserEntity, uid);
                  await ImageServices()
                      .postImage(newUserEntity.profilePic, uid, profilePicFile!)
                      .then((value) => Navigator.pop(context));
                },
                child: const Text("SAVE IMAGE"),
              ),
            ],
          );
  }

  // error handling image
  Widget _previewImages() {
    if (_retrieveDataError != null) {
      //return retrieveError;
    }
    if (_pickImageError != null) {
      // Pick imageError;
    }
    return _pickImageContainer();
  }

  // incase app crashes, previous image data can be retrieved
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
        } else {
          profilePicFile = response.files!.first as File?;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
  // end of pictures code

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
      userUsecase.setUser(await FirestoreDatabase().getUser(uid), uid);
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

  // orientation code
  bool useOrientationSensor = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return _pickImageContainer();
                    case ConnectionState.done:
                      return _previewImages();
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        return _pickImageContainer();
                      } else {
                        return _pickImageContainer();
                      }
                    default:
                      return _pickImageContainer();
                  }
                },
              )
            : _previewImages(),
      ),
    );
  }
}
