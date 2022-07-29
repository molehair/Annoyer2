import 'package:annoyer/browser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

import 'database/local_settings.dart';
import 'log.dart';

class Sync {
  static bool _inited = false;

  static initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    // TODO: uncomment below lines when _generateUserCode() was done
    // create the user code if it doesn't exist
    // String? userCode = await Settings.get(Settings.userCode);
    // if (userCode == null) {
    //   userCode = _generateUserCode();
    //   await Settings.set(Settings.userCode, userCode);
    // }

    // create deviceId if it doesn't exist
    String? deviceId = await LocalSettings.getDeviceId();
    if (deviceId == null) {
      deviceId = _generateDeviceId();
      await LocalSettings.setDeviceId(deviceId);
    }

    // On the change of fcmToken
    // https://firebase.flutter.dev/docs/messaging/server-integration#saving-tokens
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);

    // update fcmToken
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      Log.error("Sync: unable to fetch fcm token");
    } else {
      _onTokenRefresh(token);
    }

    // mark as finished initialization
    _inited = true;
  }

  /// Generate a random user code
  static String _generateUserCode() {
    // TODO: replace with a paraphrase or sentence which is
    //        1. not that difficult to type,
    //        2. universally unique, and
    //        3. not easily guessable
    return const Uuid().v4();
  }

  /// Generate a deviceId
  static String _generateDeviceId() {
    // must be universally unique
    return const Uuid().v4();
  }

  static void _onTokenRefresh(String token) async {
    // load deviceId
    String? deviceId = await LocalSettings.getDeviceId();
    if (deviceId == null) {
      Log.error('Sync: Empty device Id');
      return;
    }

    // send token to the server
    var res = await Browser.post("/refreshToken", body: {
      "token": token,
      "deviceId": deviceId,
    });

    // log
    if (res.statusCode == 200) {
      Log.info("Refreshed token");
    } else if (res.statusCode < 400) {
      Log.info("/refreshToken: statusCode ${res.statusCode}");
    } else {
      Log.error("/refreshToken: statusCode ${res.statusCode}");
    }
  }
}
