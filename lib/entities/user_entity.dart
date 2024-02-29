import 'dart:typed_data';

class UserEntity {
  final String name;
  final String favouriteFood;
  final String funFact;
  final int interval;
  String profilePic;
  int water;
  Uint8List? profileImage;

  UserEntity(
      {required this.name,
      required this.favouriteFood,
      required this.funFact,
      required this.interval,
      required this.water,
      required this.profilePic,
      this.profileImage});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      name: map['name'],
      favouriteFood: map['favouriteFood'],
      funFact: map['funFact'],
      interval: map['interval'],
      water: map['water'],
      profilePic: map['profilePic'],
      profileImage: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'favouriteFood': favouriteFood,
      'funFact': funFact,
      'interval': interval,
      'water': water,
      'profilePic': profilePic,
    };
  }
}
