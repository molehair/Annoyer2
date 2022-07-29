import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationCenter {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  /// Initialized this class?
  static bool _inited = false;

  // notification id (auto-incremented)
  static int _id = 0;

  static final Map<String, void Function(Map<String, Object?>?)> _callbacks =
      {};

  static late final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static Future<void> initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) => onTapNotification(payload!),
    );

    // mark as finished initialization
    _inited = true;
  }

  /// show a notification
  ///
  /// [key] : a key by which a callback function is called
  ///
  /// RETURN : notification Id on success
  static Future<int> show({
    String? title,
    String? body,
    Map<String, Object?>? data,
    String? key,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'annoyer',
      'annoyer',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // create payload
    String payload = jsonEncode({'key': key, 'data': data});

    // show!
    await flutterLocalNotificationsPlugin
        .show(_id, title, body, platformChannelSpecifics, payload: payload);

    // increment id
    _id++;

    // return the very used id
    return _id - 1;
  }

  /// cancel a live notification
  static Future<void> cancel(int id) {
    return flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Upon a notificaiton with [key] is tapped, [callback] is called.
  /// If [key] is already registered, the new [callback] will override the old one.
  static setOnTapCallback(
      String key, void Function(Map<String, Object?>?) callback) {
    _callbacks[key] = callback;
  }

  /// Stop listening to [key]
  static removeOnTapCallback(String key) {
    _callbacks.remove(key);
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}

void onTapNotification(String? payload) {
  if (payload != null) {
    // decode payload
    Map<String, Object?> payloadDecoded = jsonDecode(payload);
    String key = payloadDecoded['key'] as String;
    Map<String, Object?>? data =
        payloadDecoded['data'] as Map<String, Object?>?;

    // run callback
    if (NotificationCenter._callbacks.containsKey(key)) {
      NotificationCenter._callbacks[key]!.call(data);
    }
  }
}
