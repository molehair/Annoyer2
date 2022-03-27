import 'package:annoyer/log.dart';
import 'package:annoyer/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class BackgroundWorker {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  /// Initialized this class?
  static bool _inited = false;

  /// task to callback function
  static final Map<String, Function(Map<String, dynamic>?)> _tasks = {};

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static Future<void> initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    // register push handlers
    FirebaseMessaging.onMessage.listen(_foregroundHandler);
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // mark as finished initialization
    _inited = true;
  }

  /// Upon [task] takes place, [callback] is called.
  /// If [task] is already registered, the new [callback] will override the old one.
  static void setTaskCallback(
      String task, Function(Map<String, dynamic>?) callback) {
    _tasks[task] = callback;
  }

  /// Stop listening to [task]
  static removeTaskCallback(String task) {
    _tasks.remove(task);
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}

// callback for push notification in foreground
void _foregroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;

  // call the callback
  String task = data['task'];
  if (BackgroundWorker._tasks.containsKey(task)) {
    try {
      await Future.sync(() => BackgroundWorker._tasks[task]!.call(data));
    } catch (e) {
      logger.e(e, e);
    }
  } else {
    logger.w('Unknown task: $task');
  }
}

// callback for push notification in background
Future<void> _backgroundHandler(RemoteMessage message) async {
  // init app
  await initialization();

  // run as foreground
  _foregroundHandler(message);
}
