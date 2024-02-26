import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/entities/user_entity.dart';
import 'package:macrohard/services/firestore_database.dart';
import 'package:macrohard/services/user_usecase.dart';

class FirebaseAuthServices {
  Future<void> signUp(BuildContext context, String email, String password,
      UserUsecase userUsecase) async {
    try {
      debugPrint("SIGNING UP");
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
      .then((value) async {
        UserEntity userEntity = UserEntity(
            name: email,
            favouriteFood: "BIG MEAT",
            funFact: "I CAN FLYYYYY",
            interval: 60);
        await userUsecase.setUser(userEntity);
        await FirestoreDatabase().addUser(userEntity, value.user!.uid);
      });
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during create user: $e");
    }
  }

  Future<void> signIn(BuildContext context, String email, String password,
      UserUsecase userUsecase) async {
    try {
      debugPrint("SIGNING IN");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) async {
         await userUsecase.setUser(await FirestoreDatabase().getUser(value.user!.uid));
      });
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during sign-in: $e");
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle exceptions
      debugPrint("Error during send reset email: $e");
    }
  }
}
