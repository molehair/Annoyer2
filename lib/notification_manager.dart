import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationManager {
  static Future<void> initialization() async {
    // init!
    // 'resource://drawable/res_app_icon',
    await AwesomeNotifications().initialize(null, [], debug: kDebugMode);
  }
}
