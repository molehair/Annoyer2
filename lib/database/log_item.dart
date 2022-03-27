// Log item struct

/// isar code gen: flutter pub run build_runner build

import 'package:isar/isar.dart';

import 'database.dart';

part 'log_item.g.dart';

@Collection()
class LogItem {
  @Id()
  int? id;

  String log;

  LogItem(this.log);

  /// Get all items
  static Future<List<LogItem>> getAll() {
    return Database.isar.logItems.where().findAll();
  }

  /// Delete all items
  static Future<void> deleteAll() async {
    await Database.isar.writeTxn((isar) async {
      await isar.logItems.where().deleteAll();
    });
  }
}
