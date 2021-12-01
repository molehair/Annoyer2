// A box for containing training data

// The hive_generator package can automatically generate TypeAdapters for almost any class.
// 1. To generate a TypeAdapter for a class, annotate it with @HiveType and provide a typeId (between 0 and 223)
// 2. Annotate all fields which should be stored with @HiveField
// 3. Run build task `flutter packages pub run build_runner build`
// 4. Register the generated adapter

import 'package:hive_flutter/hive_flutter.dart';

part 'training_data.g.dart';

@HiveType(typeId: 2)
class TrainingData {
  static const String boxName = 'training';

  // the box key
  static const String key = 'training';

  @HiveField(0)
  DateTime expiration;

  @HiveField(1)
  List<dynamic> wordKeys;

  TrainingData({required this.expiration, required this.wordKeys});
}
