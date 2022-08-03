/// isar code gen: flutter pub run build_runner build

import 'dart:convert';

import 'package:annoyer/database/database.dart';
import 'package:isar/isar.dart';

part 'local_settings.g.dart';

@Collection()
class LocalSettings {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  @Id()
  int id;

  String value;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  // ids
  static const int _alarmEnabled = 0;
  static const int _alarmTimeHour = 1;
  static const int _alarmTimeMinute = 2;
  static const int _alarmWeekdays = 3;
  static const int _deviceId = 4;
  static const int _predefineWordsVersion = 5;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  LocalSettings(this.id, this.value);

  static Future<bool?> getAlarmEnabled() async {
    var obj = await Database.isar.localSettingss.get(_alarmEnabled);
    return (obj != null) ? jsonDecode(obj.value) : null;
  }

  static Future<void> setAlarmEnabled(bool alarmEnabled) {
    LocalSettings obj = LocalSettings(_alarmEnabled, jsonEncode(alarmEnabled));
    return Database.isar.writeTxn((isar) async {
      await Database.isar.localSettingss.put(obj);
    });
  }

  static Future<int?> getAlarmTimeHour() async {
    var obj = await Database.isar.localSettingss.get(_alarmTimeHour);
    return (obj != null) ? jsonDecode(obj.value) : null;
  }

  static Future<void> setAlarmTimeHour(int alarmTimeHour) {
    LocalSettings obj =
        LocalSettings(_alarmTimeHour, jsonEncode(alarmTimeHour));
    return Database.isar.writeTxn((isar) async {
      await Database.isar.localSettingss.put(obj);
    });
  }

  static Future<int?> getAlarmTimeMinute() async {
    var obj = await Database.isar.localSettingss.get(_alarmTimeMinute);
    return (obj != null) ? jsonDecode(obj.value) : null;
  }

  static Future<void> setAlarmTimeMinute(int alarmTimeMinute) {
    LocalSettings obj =
        LocalSettings(_alarmTimeMinute, jsonEncode(alarmTimeMinute));
    return Database.isar.writeTxn((isar) async {
      await Database.isar.localSettingss.put(obj);
    });
  }

  static Future<List<bool>?> getAlarmWeekdays() async {
    var obj = await Database.isar.localSettingss.get(_alarmWeekdays);
    return (obj != null) ? List.castFrom(jsonDecode(obj.value)) : null;
  }

  static Future<void> setAlarmWeekdays(List<bool> alarmWeekdays) {
    assert(alarmWeekdays.length == 7);
    LocalSettings obj =
        LocalSettings(_alarmWeekdays, jsonEncode(alarmWeekdays));
    return Database.isar.writeTxn((isar) async {
      await Database.isar.localSettingss.put(obj);
    });
  }

  static Future<String?> getDeviceId() async {
    var obj = await Database.isar.localSettingss.get(_deviceId);
    return (obj != null) ? jsonDecode(obj.value) : null;
  }

  static Future<void> setDeviceId(String deviceId) {
    LocalSettings obj = LocalSettings(_deviceId, jsonEncode(deviceId));
    return Database.isar.writeTxn((isar) async {
      await Database.isar.localSettingss.put(obj);
    });
  }

  static Future<int?> getPredefinedWordsVersion() async {
    var obj = await Database.isar.localSettingss.get(_predefineWordsVersion);
    return (obj != null) ? jsonDecode(obj.value) : null;
  }

  static Future<void> setPredefinedWordsVersion(int version) {
    LocalSettings obj =
        LocalSettings(_predefineWordsVersion, jsonEncode(version));
    return Database.isar.writeTxn((isar) async {
      await Database.isar.localSettingss.put(obj);
    });
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
