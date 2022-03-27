/// A struct of practice instances in training

/// isar code gen: flutter pub run build_runner build

import 'dart:convert';

import 'package:annoyer/database/database.dart';
import 'package:isar/isar.dart';

part 'practice_instance.g.dart';

@Collection()
class PracticeInstance {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  @Id()
  int? id;

  // id for training data
  int trainingId;

  // id for practice instance in a certain day
  int dailyIndex;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  PracticeInstance({
    this.id,
    required this.trainingId,
    required this.dailyIndex,
  });

  PracticeInstance.fromMap(Map<String, Object?> map)
      : id = map['id'] as int?,
        trainingId = map['trainingId'] as int,
        dailyIndex = map['dailyIndex'] as int;

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'trainingId': trainingId,
      'dailyIndex': dailyIndex,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  PracticeInstance.fromJson(String jsonString)
      : this.fromMap(jsonDecode(jsonString));

  String toJson() {
    return jsonEncode(toMap());
  }

  /// Get an item
  static Future<PracticeInstance?> get(int id) {
    return Database.isar.practiceInstances.get(id);
  }

  /// Get items by ids
  static Future<List<PracticeInstance?>> gets(List<int> ids) {
    return Database.isar.practiceInstances.getAll(ids);
  }

  /// Get all items
  static Future<List<PracticeInstance>> getAll() {
    return Database.isar.practiceInstances.where().findAll();
  }

  /// Add an item
  static Future<void> add(PracticeInstance inst) async {
    inst.id = null;
    await Database.isar.writeTxn((isar) async {
      await isar.practiceInstances.put(inst);
    });
  }

  /// Save an item associated with id
  static Future<void> put(PracticeInstance inst) async {
    assert(inst.id != null);
    await Database.isar.writeTxn((isar) async {
      await isar.practiceInstances.put(inst);
    });
  }

  /// Delete an item
  static Future<void> delete(int id) async {
    await Database.isar.writeTxn((isar) async {
      await isar.practiceInstances.delete(id);
    });
  }

  /// Delete items by [ids]
  static Future<void> deletes(List<int> ids) async {
    await Database.isar.writeTxn((isar) async {
      await isar.practiceInstances.deleteAll(ids);
    });
  }

  /// Delete all items
  static Future<void> deleteAll() async {
    await Database.isar.writeTxn((isar) async {
      await isar.practiceInstances.where().deleteAll();
    });
  }

  /// RETURN: the number of all items
  static Future<int> count() {
    return Database.isar.practiceInstances.where().count();
  }

  /// Get stream
  static Stream<void> getStream() {
    return Database.isar.practiceInstances.watchLazy();
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
