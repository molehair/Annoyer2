// The (local) notification system

import 'dart:convert';

import 'package:annoyer/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static final Map<String, Function(Map<String, dynamic>)> _callbacks = {};

  static const AndroidInitializationSettings _initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final MacOSInitializationSettings initializationSettingsMacOS =
  //     MacOSInitializationSettings();
  static const InitializationSettings initializationSettings =
      InitializationSettings(
    android: _initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
    // macOS: initializationSettingsMacOS,
  );

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static NotificationAppLaunchDetails? notificationAppLaunchDetails;

  static Future<void> initialization() async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    return flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      notificationAppLaunchDetails = value;
    });
  }

  // Enroll a callback function tied with a key.
  // On duplicated key, it will overwrite.
  static void enrollCallback({
    required String key,
    required Widget? Function(Map<String, dynamic>) callback,
  }) {
    NotificationManager._callbacks[key] = callback;
  }

  // called when the user taps a notification
  static Widget? onSelectNotification(String? payload) {
    debugPrint('onSelectNotification PAYLOAD: $payload');

    // parse payload on demand
    if (payload != null) {
      Map<String, dynamic> data = jsonDecode(payload);
      debugPrint(data.toString());

      // Is there a correspondent callback?
      if (data.containsKey('key') && _callbacks.containsKey(data['key'])) {
        // run the callback
        debugPrint('NotificationManager callback: ${data["key"]}');
        Widget? widget = _callbacks[data['key']]!(data);
        debugPrint('notification callback returned: $widget');

        // Did the callback returned an widget?
        if (widget != null) {
          // push the widget
          Global.navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (context) => widget));
          return widget;
        }
      }
    }
  }
}
