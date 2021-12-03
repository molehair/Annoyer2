// training system
// It makes use of notification IDs ranged from 0 to (numAlarmsPerDay*7).

import 'dart:math';

import 'package:annoyer/database/word.dart';
import 'package:annoyer/pages/test_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';

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
  static final NotificationChannel notificationChannel = NotificationChannel(
    channelKey: 'training',
    channelName: 'Training',
    channelDescription: 'Notification channel for training',
    // defaultColor: Color(0xFF9D50DD),
    // ledColor: Colors.white,
  );

  /// Must be called after notification manager is initialized.
  static initialization() async {
    // listen to tapping a notification
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      debugPrint('listen: payload=${receivedNotification.payload}');
      if (receivedNotification.channelKey == notificationChannel.channelKey) {
        _onSelectNotification(receivedNotification.payload);
      }
    });

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
        if (trainingData.expiration.isBefore(DateTime.now()) ||
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

    // Set the practice and test alarms
    // the last one is the only test alarm
    final List<Future> futures = [];
    final String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    int hour = time.hour;
    int minute = time.minute;
    for (int dailyIndex = 0; dailyIndex < numAlarmsPerDay; dailyIndex++) {
      // compute notification id
      int id = _computeNotificationId(weekday, dailyIndex);

      // schedule the alarm
      futures.add(AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: notificationChannel.channelKey!,
          title: title,
          body: (dailyIndex + 1 < numAlarmsPerDay) ? practiceBody : testBody,
          payload: {
            fieldDailyIndex: dailyIndex.toString(),
          },
          groupKey: _getGroupKey(weekday),
          // notificationLayout: NotificationLayout.BigPicture,
          // bigPicture: 'asset://assets/images/melted-clock.png',
        ),
        schedule: NotificationCalendar(
          weekday: weekday == 0 ? 7 : weekday, // change 0(=Sun) to 7
          hour: hour,
          minute: minute,
          second: 0,
          timeZone: localTimeZone,
          repeats: true,
        ),
      ));

      // iterate the datetime (+notiInterval minutes on (minute,hour,weekday))
      // considering overflows
      minute += notiInterval;
      hour += (minute / 60).floor();
      weekday = (weekday + (hour / 24).floor()) % 7;
      hour = hour % 24;
      minute = minute % 60;
    }

    await Future.wait(futures);
  }

  /// cancel alarms on the given weekday
  static Future<void> cancelAlarm(int weekday) async {
    return AwesomeNotifications()
        .cancelSchedulesByGroupKey(_getGroupKey(weekday));
  }

  /// Compute the notification id
  static int _computeNotificationId(int weekday, int dailyIndex) {
    return weekday * numAlarmsPerDay + dailyIndex;
  }

  /// Get the group key for scheduling
  static String _getGroupKey(int weekday) {
    return '${notificationChannel.channelKey}_$weekday';
  }

  /// when the user taps the notification
  static void _onSelectNotification(Map<String, String>? payload) {
    // last alarm?
    if (payload != null) {
      String? dailyIndexString = payload[fieldDailyIndex];
      if (dailyIndexString != null) {
        int dailyIndex = int.parse(dailyIndexString);

        BuildContext context = Global.navigatorKey.currentContext!;
        if (dailyIndex == numAlarmsPerDay - 1) {
          //-- last alarm on a day --//
          debugPrint('Creating DailyTest instance..');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TestPage()));
        } else {
          //-- non-last alarm on a day --//
          debugPrint('Creating Practice instance..');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PracticePage(
              dailyIndex: dailyIndex,
            ),
          ));
        }
      }
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
