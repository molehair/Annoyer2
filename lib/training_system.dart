// training system
// It makes use of notification IDs ranged from 0 to (numAlarmsPerDay*7).

import 'dart:convert';
import 'dart:math';

import 'package:annoyer/database/word.dart';
import 'package:annoyer/pages/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:collection/collection.dart';

import '../notification_manager.dart';
import 'database/dictionary.dart';
import 'database/training_data.dart';
import 'pages/practice_page.dart';
import '../global.dart';

// configurations
const int totalTime =
    8 * 60; // min. The time duration from the 1st practice to the test
const int numTrainingWords = 16; // number of words a day for training
const int numReps = 3; // number of repetitions per a word
const int numTrainingWordsPerAlarm = 3; // number of words per a notification
final int numPracticeAlarmsPerDay =
    (1.0 * numTrainingWords * numReps / numTrainingWordsPerAlarm).ceil();
final int notiInterval = (totalTime / numPracticeAlarmsPerDay)
    .floor(); // min. The time interval between two consecutive alarms
final int numAlarmsPerDay = numPracticeAlarmsPerDay + 1;
final int notificationIdBound =
    numAlarmsPerDay * 7; // notificaiton id is in [0,numAlarmsPerDay * 7)

// constants
const fieldKey = 'key'; // for notification system
const fieldDailyIndex = 'dailyIndex';

class TrainingSystem {
  // notification constants
  static const String _notificationKey = 'training';

  static initialization() async {
    await NotificationManager.initialization();

    // enroll notification callback
    NotificationManager.enrollCallback(
      key: _notificationKey,
      callback: _onSelectNotification,
    );

    // enroll training data callback
    Box<TrainingData> box =
        await Hive.openBox<TrainingData>(TrainingData.boxName);
    _onTrainingDataChange(box.watch());
  }

  // callback when there's a change on training data
  static _onTrainingDataChange(Stream<BoxEvent> stream) async {
    await for (final BoxEvent event in stream) {
      // destory training data instance if training data is empty or invalid
      if (!event.deleted) {
        TrainingData trainingData = event.value;

        // check if it's not valid
        if (DateTime.now().isBefore(trainingData.expiration) ||
            trainingData.wordKeys.isEmpty) {
          // remove training data
          Box<TrainingData> box =
              await Hive.openBox<TrainingData>(TrainingData.boxName);
          box.delete(TrainingData.key);
        }
      }
    }
  }

  /// Turn on the practice and test alarms for a weekday(weekly)
  ///
  /// time: the time when the first alarm rings
  /// weekday: one of (Sun=0, Mon=1, ... , Sat=6)
  static Future<void> setAlarm(
    TimeOfDay time,
    int weekday,
  ) async {
    final BuildContext context = Global.navigatorKey.currentContext!;
    final String title = AppLocalizations.of(context)!.annoyer;
    final String practiceBody = AppLocalizations.of(context)!.practiceNotifier;
    final String testBody = AppLocalizations.of(context)!.testNotifier;

    // set the first alarm datetime
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime first = tz.TZDateTime.local(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Set the practice and test alarms
    // the last one is the only test alarm
    final List<Future> futures = [];
    for (int dailyIndex = 0; dailyIndex < numAlarmsPerDay; dailyIndex++) {
      // compute notification id
      int id = _computeNotificationId(weekday, dailyIndex);

      // compute datetime
      tz.TZDateTime scheduledDate =
          first.add(Duration(minutes: notiInterval * dailyIndex));
      if (scheduledDate.isBefore(now)) {
        // If the alarm time already passed, then start from the next week
        scheduledDate.add(const Duration(days: 7));
      }

      futures.add(setSingleAlarm(
        id: id,
        scheduledDate: scheduledDate,
        body: (dailyIndex + 1 < numAlarmsPerDay) ? practiceBody : testBody,
        title: title,
        payload: jsonEncode({
          fieldKey: _notificationKey,
          fieldDailyIndex: dailyIndex,
        }),
      ));
    }

    await Future.wait(futures);
  }

  static Future<void> setSingleAlarm({
    required int id,
    required tz.TZDateTime scheduledDate,
    String? title,
    String? body,
    String? payload,
  }) async {
    // notification handlers
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'Training alarm',
      channelDescription: 'The alarm for daily training',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        NotificationManager.flutterLocalNotificationsPlugin;

    debugPrint(scheduledDate.toString());
    return flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  /// cancel alarms on the given weekday
  static Future<void> cancelAlarm(int weekday) async {
    List<Future<void>> futures = [];
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        NotificationManager.flutterLocalNotificationsPlugin;
    for (int dailyIndex = 0; dailyIndex < numAlarmsPerDay; dailyIndex++) {
      int id = _computeNotificationId(weekday, dailyIndex);
      futures.add(flutterLocalNotificationsPlugin.cancel(id));
    }
    await Future.wait(futures);
  }

  /// Compute the notification id
  static int _computeNotificationId(int weekday, int dailyIndex) {
    return weekday * numAlarmsPerDay + dailyIndex;
  }

  /// when the user taps the notification
  static Widget? _onSelectNotification(final Map<String, dynamic> data) {
    debugPrint('onSelectNOtification in training: $data');

    // last alarm?
    if (data[fieldDailyIndex] == numAlarmsPerDay) {
      debugPrint('Creating DailyTest instance..');
      return TestPage();
    } else {
      debugPrint('Creating Practice instance..');
      return PracticePage(dailyIndex: data[fieldDailyIndex]);
    }
  }

  /// Create and return a list of daily words for training
  ///
  /// Return null if the list cannot be generated.
  static Future<TrainingData?> createTrainingData() async {
    TrainingData? trainingData;

    try {
      //-- select the keys of words --//
      List<dynamic>? wordKeys;

      // get the number of the entire words in the dictionary
      Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
      List keys = box.keys.toList();
      int numDictWords = keys.length;

      // select words
      // split into cases by the total number of words in dictionary
      if (numDictWords == 0) {
        //-- no word case --//
        // no training words
      } else if (numDictWords <= numTrainingWords) {
        //-- the number of total words is no larger than numTrainingWords --//
        // put the entire words into the training
        wordKeys = keys.toList();
      } else {
        //-- the number of total words exceeds numTrainingWords --//
        // compute accumulated weights for words
        final List<double> accumulatedWeight = List.filled(numDictWords, 0.0);
        double prevWeight = 0.0;
        for (int i = 0; i < numDictWords; i++) {
          Word word = box.get(keys[i])!;
          double weight = 1.0 / word.level;
          accumulatedWeight[i] = prevWeight + weight;
          prevWeight = accumulatedWeight[i];
        }

        // Select random (numTrainingWords)-word
        final double weightSum = accumulatedWeight[numDictWords - 1];
        final Random rng = Random();
        final Set<int> trainingDataIndicesSet = {};
        while (trainingDataIndicesSet.length != numTrainingWords) {
          // pick a random number in [0,weightSum)
          double r = rng.nextDouble() * weightSum;

          // select the corresponding word
          int index = lowerBound(accumulatedWeight, r);

          // add to the pool
          trainingDataIndicesSet.add(index);
        }
        wordKeys = trainingDataIndicesSet.map((index) => keys[index]).toList();
      }

      //-- Set the expiration --//
      DateTime expiration = DateTime.now().add(const Duration(days: 1));

      //-- consolidate everything --//
      if (wordKeys != null) {
        trainingData = TrainingData(expiration: expiration, wordKeys: wordKeys);
        debugPrint('created daily words');
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    return trainingData;
  }

  /// Save the daily words to the local storage.
  static Future<void> saveTrainingWords(TrainingData trainingData) async {
    Box<TrainingData> box =
        await Hive.openBox<TrainingData>(TrainingData.boxName);
    return box.put(TrainingData.key, trainingData);
  }

  /// Load the daily words from the local storage.
  ///
  /// Return null if there's no stored list found.
  static Future<TrainingData?> loadTrainingWords() async {
    Box<TrainingData> box =
        await Hive.openBox<TrainingData>(TrainingData.boxName);
    return box.get(TrainingData.key);
  }

  /// Remove daily words.
  static Future<void> removeTrainingWords() async {
    Box<TrainingData> box =
        await Hive.openBox<TrainingData>(TrainingData.boxName);
    return box.delete(TrainingData.key);
  }

  /// Pop the word out from the training data and update the level
  static Future<void> grade(Word word, bool correct) async {
    TrainingData? trainingData = await loadTrainingWords();
    if (trainingData != null &&
        DateTime.now().isBefore(trainingData.expiration)) {
      // find the word
      int i;
      for (i = 0; i < trainingData.wordKeys.length; i++) {
        if (trainingData.wordKeys[i] == word.key) {
          break;
        }
      }

      if (i < trainingData.wordKeys.length) {
        //-- found the word --//
        // eliminate it
        trainingData.wordKeys.removeAt(i);
        await saveTrainingWords(trainingData);

        // update level
        if (correct) {
          word.level++;
        } else {
          word.level = max(word.level - 1, 1);
        }
        Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
        box.put(word.key, word);
        debugPrint('new level of ${word.name}: ${word.level}');
      }
    }
  }
}
