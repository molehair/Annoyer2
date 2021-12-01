// A box for containing settings

// The hive_generator package can automatically generate TypeAdapters for almost any class.
// 1. To generate a TypeAdapter for a class, annotate it with @HiveType and provide a typeId (between 0 and 223)
// 2. Annotate all fields which should be stored with @HiveField
// 3. Run build task `flutter packages pub run build_runner build`
// 4. Register the generated adapter

import 'package:hive_flutter/hive_flutter.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings {
  static const String boxName = 'settings';

  // the box key
  static const String key = 'settings';

  @HiveField(0)
  bool alarmEnabled = false;

  @HiveField(1)
  int alarmTimeHour = 0;

  @HiveField(2)
  int alarmTimeMinute = 0;

  @HiveField(3)
  List<bool> alarmWeekdays = [false, false, false, false, false, false, false];

  Settings();

  Settings.from(Settings other)
      : alarmEnabled = other.alarmEnabled,
        alarmTimeHour = other.alarmTimeHour,
        alarmTimeMinute = other.alarmTimeMinute,
        alarmWeekdays = other.alarmWeekdays;
}
