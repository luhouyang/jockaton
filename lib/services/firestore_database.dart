import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macrohard/entities/user_entity.dart';

class FirestoreDatabase {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserEntity userEntity) async {
    try {
      await firebaseFirestore.collection("users").add(userEntity.toMap());
    } catch (e) {
      debugPrint("Error add user: $e");
    }
  }
}
