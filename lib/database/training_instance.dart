/// A struct of practice instances in training

/// isar code gen: flutter pub run build_runner build

import 'dart:convert';

import 'package:annoyer/database/database.dart';
import 'package:isar/isar.dart';

part 'training_instance.g.dart';

@Collection()
class TrainingInstance {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  @Id()
  int? id;

  // id for training data
  int trainingId;

  // id for practice instance in a certain day
  int trainingIndex;

  // notification id for canceling
  int notificationId;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  TrainingInstance({
    this.id,
    required this.trainingId,
    required this.trainingIndex,
    required this.notificationId,
  });

  TrainingInstance.fromMap(Map<String, Object?> map)
      : id = map['id'] as int?,
        trainingId = map['trainingId'] as int,
        trainingIndex = map['trainingIndex'] as int,
        notificationId = map['notificationId'] as int;

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'trainingId': trainingId,
      'trainingIndex': trainingIndex,
      'notificationId': notificationId,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  TrainingInstance.fromJson(String jsonString)
      : this.fromMap(jsonDecode(jsonString));

  String toJson() {
    return jsonEncode(toMap());
  }

  /// Get an item
  static Future<TrainingInstance?> get(int id) {
    return Database.isar.trainingInstances.get(id);
  }

  /// Get items by ids
  static Future<List<TrainingInstance?>> gets(List<int> ids) {
    return Database.isar.trainingInstances.getAll(ids);
  }

  /// Get all items
  static Future<List<TrainingInstance>> getAll() {
    return Database.isar.trainingInstances.where().findAll();
  }

  /// Add an item
  static Future<void> add(TrainingInstance inst) async {
    inst.id = null;
    await Database.isar.writeTxn((isar) async {
      await isar.trainingInstances.put(inst);
    });
  }

  /// Save an item associated with id
  static Future<void> put(TrainingInstance inst) async {
    assert(inst.id != null);
    await Database.isar.writeTxn((isar) async {
      await isar.trainingInstances.put(inst);
    });
  }

  /// Delete an item
  static Future<void> delete(int id) async {
    await Database.isar.writeTxn((isar) async {
      await isar.trainingInstances.delete(id);
    });
  }

  /// Delete items by [ids]
  static Future<void> deletes(List<int> ids) async {
    await Database.isar.writeTxn((isar) async {
      await isar.trainingInstances.deleteAll(ids);
    });
  }

  /// Delete all items
  static Future<void> deleteAll() async {
    await Database.isar.writeTxn((isar) async {
      await isar.trainingInstances.where().deleteAll();
    });
  }

  /// RETURN: the number of all items
  static Future<int> count() {
    return Database.isar.trainingInstances.where().count();
  }

  /// Get stream
  static Stream<void> getStream() {
    return Database.isar.trainingInstances.watchLazy();
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
