// Log system

import 'package:annoyer/database/database.dart';
import 'package:annoyer/database/log_item.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: SimplePrinter(printTime: true),
  output: MultiOutput([ConsoleOutput(), _DBLog()]),
);

class _DBLog extends LogOutput {
  @override
  void output(OutputEvent event) async {
    await Database.isar.writeTxn((isar) async {
      await Database.isar.logItems
          .putAll(event.lines.map((e) => LogItem(e)).toList());
    });
  }
}
