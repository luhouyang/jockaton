import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:macrohard/entities/user_entity.dart';
import 'package:macrohard/services/image_services.dart';

class UserUsecase extends ChangeNotifier {
  UserEntity userEntity = UserEntity(
      name: "name",
      favouriteFood: "favourite food",
      funFact: "fun fact",
      interval: 60.0,
      water: 0.0,
      profilePic: "");

  Future<void> setUser(UserEntity newUserEntity, String uid) async {
    userEntity = newUserEntity;
    notifyListeners();
    if (userEntity.profileImage == null && newUserEntity.profilePic != "") {
      Uint8List? imageData =
          await ImageServices().retrieveImage(newUserEntity.profilePic, uid);
      userEntity.profileImage = imageData!;
    }
  }
}
