import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationManager {
  static Future<void> initialization() async {
    // init!
    await AwesomeNotifications().initialize(
      'resource://drawable/launcher_icon',
      [],
      debug: kDebugMode,
    );
  }
}
