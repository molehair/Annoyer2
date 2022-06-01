// Log system

import 'package:annoyer/database/database.dart';
import 'package:annoyer/database/log_item.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var _consoleLogOutput = ConsoleOutput();
var _dbLogOutput = _DBLog();
var _releaseModeFilter = _ReleaseModeFilter();

Logger logger = Logger(
  printer: SimplePrinter(printTime: true),
  output: kDebugMode
      ? MultiOutput([_consoleLogOutput, _dbLogOutput])
      : _dbLogOutput,
  filter: kDebugMode ? null : _releaseModeFilter,
);

class _ReleaseModeFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level == Level.info ||
        event.level == Level.error ||
        event.level == Level.warning ||
        event.level == Level.wtf;
  }
}

class _DBLog extends LogOutput {
  @override
  void output(OutputEvent event) async {
    await Database.isar.writeTxn((isar) async {
      await Database.isar.logItems
          .putAll(event.lines.map((e) => LogItem(e)).toList());
    });
  }
}
