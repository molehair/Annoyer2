import 'package:annoyer/main.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundWorker {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  /// Initialized this class?
  static bool _inited = false;

  /// the interval between the times of two consecutive background worker executions in min
  /// Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  static const _interval = Duration(minutes: 20);

  /// task to callback function
  static final Map<String, Function()> _tasks = {};

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static Future<void> initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    // workmanager
    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask(
      'workmanager',
      'workmanager',
      frequency: _interval,
    );

    // mark as finished initialization
    _inited = true;
  }

  /// [callback] is called at every 20 mins.
  /// If [taskId] is already registered, the new [callback] will override the old one.
  static void registerPeriodicTask(String taskId, Function() callback) {
    _tasks[taskId] = callback;
  }

  /// Make a stop on [taskId]
  static void cancelPeriodicTask(String taskId) {
    _tasks.remove(taskId);
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}

void callbackDispatcher() {
  Workmanager().executeTask((taskId, inputData) async {
    // init in the background
    await initialization();

    // call the callbacks
    for (var task in BackgroundWorker._tasks.values) {
      task.call();
    }

    return true;
  });
}
