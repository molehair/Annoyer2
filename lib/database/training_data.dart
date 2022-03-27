// A struct for containing training data

/// isar code gen: flutter pub run build_runner build

import 'dart:convert';

import 'package:isar/isar.dart';

import 'database.dart';

part 'training_data.g.dart';

@Collection()
class TrainingData {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  @Id()
  int? id;

  List<int> wordIds;
  DateTime expiration;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  TrainingData({
    this.id,
    required this.wordIds,
    required this.expiration,
  });

  /// RETURN true if the training data is good to use
  bool isValid() {
    // expiration check
    return expiration.isAfter(DateTime.now());
  }

  TrainingData.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        wordIds = List.castFrom(map['wordIds'] as List),
        expiration = map['expiration'] as DateTime;

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'wordIds': wordIds,
      'expiration': expiration,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  TrainingData.fromJson(String jsonString)
      : this.fromMap(jsonDecode(
          jsonString,
          reviver: (key, value) => key == 'expiration'
              ? DateTime.fromMicrosecondsSinceEpoch(value as int)
              : value,
        ));

  String toJson() {
    return jsonEncode(
      toMap(),
      toEncodable: (item) =>
          item is DateTime ? item.microsecondsSinceEpoch : item,
    );
  }

  /// Get an item
  static Future<TrainingData?> get(int id) {
    return Database.isar.trainingDatas.get(id);
  }

  /// Get all items
  static Future<List<TrainingData>> getAll() {
    return Database.isar.trainingDatas.where().findAll();
  }

  /// Add an item
  static Future<void> add(TrainingData trainingData) {
    trainingData.id = null;
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.put(trainingData);
    });
  }

  /// Save an item with id
  static Future<void> put(TrainingData trainingData) {
    assert(trainingData.id != null);
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.put(trainingData);
    });
  }

  /// Delete an item
  static Future<void> delete(int id) async {
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.delete(id);
    });
  }

  /// Delete all items with [ids]
  static Future<void> deleteAll(List<int> ids) async {
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.deleteAll(ids);
    });
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
