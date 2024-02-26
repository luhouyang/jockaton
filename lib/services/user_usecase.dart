import 'package:flutter/material.dart';
import 'package:macrohard/entities/user_entity.dart';

class UserUsecase extends ChangeNotifier {
  UserEntity userEntity = UserEntity(
      name: "name",
      favouriteFood: "favourite food",
      funFact: "fun fact",
      interval: 60);

  void setUser(UserEntity newUserEntity) {
    userEntity = newUserEntity;
    notifyListeners();
  }
}
