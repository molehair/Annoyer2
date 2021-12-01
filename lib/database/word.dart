// A box for containing all words

// The hive_generator package can automatically generate TypeAdapters for almost any class.
// 1. To generate a TypeAdapter for a class, annotate it with @HiveType and provide a typeId (between 0 and 223)
// 2. Annotate all fields which should be stored with @HiveField
// 3. Run build task `flutter packages pub run build_runner build`
// 4. Register the generated adapter

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word {
  // The key for this word in Hive Box.
  // This field should be used for a convenience only.
  // For example, when passing a Word to another function with its key.
  int? key;

  @HiveField(0)
  String name;

  @HiveField(1)
  String def;

  @HiveField(2)
  String ex;

  @HiveField(3)
  String? mnemonic;

  @HiveField(4)
  int level; // >= 1

  // id for synchronization
  // the same word in different devices must have the same syncId
  @HiveField(5)
  String syncId;

  Word({
    required this.name,
    required this.def,
    required this.ex,
    this.mnemonic,
    this.level = 1,
    this.syncId = '', // randomly generated string, unique, for synchronization
  }) {
    if (syncId == '') {
      syncId = _createSyncId();
    }
  }

  Word.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        def = map['def'],
        ex = map['ex'],
        mnemonic = map['mnemonic'],
        level = map['level'] ?? 1,
        syncId = map['syncId'] ?? '';

  static String _createSyncId() {
    Uuid uuid = const Uuid();
    return uuid.v4();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'def': def,
      'ex': ex,
      'mnemonic': mnemonic,
      'level': level,
      'syncId': syncId,
    };
  }

  @override
  String toString() {
    Map<String, dynamic> map = toMap();
    map['key'] = key;
    return map.toString();
  }
}
