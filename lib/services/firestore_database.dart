import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/entities/user_entity.dart';

class FirestoreDatabase {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> setUser(UserEntity userEntity, String uid) async {
    try {
      await firebaseFirestore
          .collection("users")
          .doc(uid)
          .set(userEntity.toMap());
    } catch (e) {
      debugPrint("Error add user: $e");
    }
  }

  Future<UserEntity> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await firebaseFirestore.collection("users").doc(uid).get();
      Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
      UserEntity userEntity = UserEntity.fromMap(map);
      return userEntity;
    } catch (e) {
      debugPrint("Error get user: $e");
      return UserEntity(
          name: "name",
          favouriteFood: "favourite food",
          funFact: "fun fact",
          interval: 60);
    }
  }
}
