import 'package:uuid/uuid.dart';

import 'database/local_settings.dart';

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
}
