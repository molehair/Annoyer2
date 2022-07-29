import 'package:flutter_logs/flutter_logs.dart';

class Log {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  /// Initialized this class?
  static bool _inited = false;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static Future<void> initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    //Initialize Logging
    await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: ["device", "network", "errors"],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "MyLogs",
      logsExportDirectoryName: "MyLogs/Exported",
      debugFileOperations: true,
      isDebuggable: true,
    );

    // mark as finished initialization
    _inited = true;
  }

  static Future<void> info(String msg, {String? tag, String? subTag}) {
    return FlutterLogs.logInfo(tag ?? '', subTag ?? '', msg);
  }

  static Future<void> warn(String msg, {String? tag, String? subTag}) {
    return FlutterLogs.logWarn(tag ?? '', subTag ?? '', msg);
  }

  static Future<void> error(
    String msg, {
    Exception? exception,
    String? tag,
    String? subTag,
  }) {
    return FlutterLogs.logThis(
      tag: tag ?? '',
      subTag: subTag ?? '',
      logMessage: msg,
      exception: exception,
      level: LogLevel.ERROR,
    );
  }

  /// Erase all logs
  static Future<void> clear() {
    return FlutterLogs.clearLogs();
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
