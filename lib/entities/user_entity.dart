class UserEntity {
  final String name;
  final String favouriteFood;
  final String funFact;
  final int interval;
  int water;

  UserEntity(
      {required this.name,
      required this.favouriteFood,
      required this.funFact,
      required this.interval,
      required this.water});

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      name: map['name'],
      favouriteFood: map['favouriteFood'],
      funFact: map['funFact'],
      interval: map['interval'],
      water: map['water'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'favouriteFood': favouriteFood,
      'funFact': funFact,
      'interval': interval,
      'water': water,
    };
  }
}
