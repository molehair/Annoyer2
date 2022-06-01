// training system

import 'dart:math';

import 'package:annoyer/background_worker.dart';
import 'package:annoyer/database/practice_instance.dart';
import 'package:annoyer/database/question_ask_definition.dart';
import 'package:annoyer/database/question_ask_word.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/notification_center.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'browser.dart';
import 'database/training_data.dart';
import 'log.dart';
import 'pages/practice_page.dart';
import '../global.dart';
import 'pages/test_page.dart';

class Training {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  static bool _inited = false;

  /// min. The time duration from the 1st practice to the test
  static const int totalTime = 8 * 60;

  /// number of words a day for training
  static const int numTrainingWords = 16;

  /// number of repetitions per a word
  static const int numReps = 3;

  /// number of words per a notification
  static const int numTrainingWordsPerAlarm = 3;

  /// number of practice alarms a day
  static final int numPracticeAlarmsPerDay =
      (1.0 * numTrainingWords * numReps / numTrainingWordsPerAlarm).ceil();

  /// min. The time interval between two consecutive alarms
  static final int notiInterval = (totalTime / numPracticeAlarmsPerDay).floor();
  // TODO: move these configuration settings to the server

  /// number of alarms a day
  static final int numAlarmsPerDay = numPracticeAlarmsPerDay + 1;

  // through which a newly generated training data is valid
  static const Duration _trainingDataEffectiveDuration = Duration(days: 2);

  // task identifiers for background worker
  // REQUIRE: must match those on the server
  static const String _taskPractice = 'practice';
  static const String _taskTest = 'test';

  // notification identifiers for on-tap notification callbacks
  static const String _notiKeyPractice = _taskPractice;
  static const String _notiKeyTest = _taskTest;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    // set task handlers
    BackgroundWorker.setTaskCallback(_taskPractice, onPractice);
    BackgroundWorker.setTaskCallback(_taskTest, onTest);

    // register on-tap notification callbacks
    NotificationCenter.setOnTapCallback(
        _notiKeyPractice, (data) => onPracticeTapped(data!));
    NotificationCenter.setOnTapCallback(
        _notiKeyTest, (data) => onTestTapped(data!));

    // set test instance clean-up handler
    TestInstance.getStream().listen(_onTestInstanceChange);

    // mark as finished initialization
    _inited = true;
  }

  /// Practice handler
  static Future<void> onPractice(Map<String, Object?>? data) async {
    logger.d('onPractice: $data');

    assert(data!['trainingId'] != null);
    assert(data!['dailyIndex'] != null);

    int dailyIndex = int.parse(data!['dailyIndex'] as String);
    int trainingId = int.parse(data['trainingId'] as String);
    int instId = _computePracticeInstanceId(trainingId, dailyIndex);

    // has training data?
    TrainingData? trainingData = await TrainingData.get(trainingId);
    if (trainingData == null) {
      // create training data
      trainingData = await Training.createTrainingData(
        DateTime.now().add(_trainingDataEffectiveDuration),
      );

      // failed to create?
      if (trainingData == null) {
        throw 'Unable to create training data';
      }

      // set training key
      trainingData.id = trainingId;

      // save
      await TrainingData.put(trainingData);
    }

    // add an instance
    await PracticeInstance.put(
      PracticeInstance(
        id: instId,
        dailyIndex: dailyIndex,
        trainingId: trainingId,
      ),
    );

    // notification
    await NotificationCenter.show(
      title: t.practiceNotifier,
      data: {'trainingId': trainingId, 'dailyIndex': dailyIndex},
      key: _notiKeyPractice,
    );
  }

  /// Test handler
  static Future<void> onTest(Map<String, Object?>? data) async {
    logger.d('onTest: $data');
    assert(data!['trainingId'] != null);

    int trainingId = int.parse(data!['trainingId'] as String);
    int instKey = _computeTestInstanceId(trainingId);

    // has training data?
    TrainingData? trainingData = await TrainingData.get(trainingId);
    if (trainingData == null) {
      throw 'No training data found';
    }

    // create questions
    List<Question> questions = [];
    for (var i = 0; i < trainingData.wordIds.length; i++) {
      var wordId = trainingData.wordIds[i];
      Word? word = await Word.get(wordId);

      // word is not deleted?
      if (word != null) {
        // determine question type
        var type =
            QuestionType.values[Random().nextInt(QuestionType.values.length)];

        // create a question and add it to the list
        if (type == QuestionType.askDefinition) {
          List<Word> choices = await QuestionAskDefinition.createChoices(word);
          questions.add(QuestionAskDefinition(i, word, type, choices));
        } else if (type == QuestionType.askWord) {
          questions.add(QuestionAskWord(i, word, type));
        }
      }
    }

    // add an instance
    await TestInstance.put(
      TestInstance(
        id: instKey,
        trainingId: trainingId,
        questions: questions,
      ),
    );

    // notification
    await NotificationCenter.show(
      title: t.testNotifier,
      data: {'trainingId': trainingId},
      key: _notiKeyTest,
    );

    logger.i('Added test instance $instKey');
  }

  static void onPracticeTapped(Map<String, Object?> data) async {
    logger.d('onPracticeTapped: $data');
    assert(data['trainingId'] != null);
    assert(data['dailyIndex'] != null);

    // Get instance key
    int trainingId = data['trainingId'] as int;
    int dailyIndex = data['dailyIndex'] as int;
    int instKey = _computePracticeInstanceId(trainingId, dailyIndex);

    // Fetch the instance
    PracticeInstance? inst = await PracticeInstance.get(instKey);
    if (inst == null) {
      throw 'No practice instance found by key $instKey';
    }

    // Popup practice page
    Navigator.of(Global.navigatorKey.currentContext!).push(
      MaterialPageRoute(builder: (context) => PracticePage(inst: inst)),
    );
  }

  static void onTestTapped(Map<String, Object?> data) async {
    logger.d('onTestTapped: $data');
    assert(data['trainingId'] != null);

    // Get instance key
    int trainingId = data['trainingId'] as int;
    int instKey = _computeTestInstanceId(trainingId);

    // Fetch the instance
    TestInstance? inst = await TestInstance.get(instKey);
    if (inst == null) {
      throw 'No test instance found by key $instKey';
    }
    inst.id = instKey;

    // Popup test page
    Navigator.of(Global.navigatorKey.currentContext!).push(
      MaterialPageRoute(builder: (context) => TestPage(inst: inst)),
    );
  }

  /// Create and return a list of daily words for training
  ///
  /// RETURN: null if the list cannot be generated.
  static Future<TrainingData?> createTrainingData(DateTime expiration) async {
    TrainingData? trainingData;

    try {
      //-- select the keys of words --//
      List<int>? chosenIds;

      // get the number of the entire words in the dictionary
      List<Word> words = await Word.getAll();
      List<int> ids = words.map((e) => e.id!).toList();
      int numDictWords = words.length;

      // select words
      // split into cases by the total number of words in dictionary
      if (numDictWords == 0) {
        //-- no word case --//
        // no training words
      } else if (numDictWords <= numTrainingWords) {
        //-- the number of total words is no larger than numTrainingWords --//
        // put the entire words into the training
        chosenIds = ids;
      } else {
        //-- the number of total words exceeds numTrainingWords --//
        // compute accumulated weights for words
        final List<double> accumulatedWeight = List.filled(numDictWords, 0.0);
        double prevWeight = 0.0;
        for (int i = 0; i < numDictWords; i++) {
          double weight = 1.0 / words[i].level;
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
        chosenIds = trainingDataIndicesSet.map((index) => ids[index]).toList();
      }

      //-- consolidate everything --//
      if (chosenIds != null) {
        trainingData = TrainingData(
          expiration: expiration,
          wordIds: chosenIds,
        );
      }
    } on Exception catch (e) {
      logger.e('creatingTrainingData', e);
    }

    return trainingData;
  }

  /// Update the level of a word
  static Future<void> grade(Word word, bool correct) async {
    if (correct) {
      word.level++;
    } else {
      word.level = max(word.level - 1, 1);
    }
    return Word.put(word);
  }

  /// Set the training of a specific weekday
  /// [weekday] : 0-Sun, ... , 6-Sat
  static Future<void> setTraining(
    String deviceId,
    TimeOfDay time,
    List<bool> weekdays,
  ) async {
    assert(weekdays.length == 7);

    try {
      // convert to UTC time
      Map<String, Object> utc = _localToUTC(time, weekdays);
      TimeOfDay utcAlarmTime = utc["utcAlarmTime"] as TimeOfDay;
      List<bool> utcAlarmWeekdays = utc["utcAlarmWeekdays"] as List<bool>;

      // convert to schedule string
      String schedule = _createScheduleString(utcAlarmTime, utcAlarmWeekdays);

      // Set packet body
      Map<String, String> body = {"deviceId": deviceId, "schedule": schedule};

      // update alarms
      var res = await Browser.post('/setTraining', body: body);

      // log
      if (res.statusCode == 200) {
        logger.i("/setTraining: set training schedule");
      } else if (res.statusCode < 400) {
        logger.i("/setTraining: statusCode ${res.statusCode}");
      } else {
        logger.e("/setTraining: statusCode ${res.statusCode}");
        throw "/setTraining: statusCode ${res.statusCode}";
      }
    } catch (e) {
      logger.e('setTraining', e);
      Global.showFailure();
    }
  }

  /// Cancel training
  static Future<void> cancelTraining(String deviceId) async {
    try {
      // Set packet body
      Map<String, String> body = {"deviceId": deviceId};

      // update alarms
      var res = await Browser.post('/setTraining', body: body);

      // log
      if (res.statusCode == 200) {
        logger.i("/setTraining: canceled training schedule");
      } else if (res.statusCode < 400) {
        logger.i("/setTraining: statusCode ${res.statusCode}");
      } else {
        logger.e("/setTraining: statusCode ${res.statusCode}");
        throw "/setTraining: statusCode ${res.statusCode}";
      }
    } catch (e) {
      logger.e('cancelTraining', e);
      Global.showFailure();
    }
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//

  /// Compute the id for a practice instance
  static int _computePracticeInstanceId(int trainingId, int dailyIndex) {
    return trainingId * 256 + dailyIndex;
  }

  /// Compute the id for a practice instance
  static int _computeTestInstanceId(int trainingId) {
    return trainingId;
  }

  /// clean up when a test is completed
  static _onTestInstanceChange(_) async {
    var testInsts = await TestInstance.getAll();

    for (TestInstance testInst in testInsts) {
      // check if the instance is complete
      if (testInst.questions
          .every((e) => e.state != QuestionState.intertermined)) {
        // remove all practice instances using the training data
        var pracInsts = await PracticeInstance.getAll();
        var accompaniedPracInsts = pracInsts
            .where((pracInst) => pracInst.trainingId == testInst.trainingId);
        var accompaniedPracInstIds = accompaniedPracInsts.map((e) => e.id!);
        PracticeInstance.deletes(accompaniedPracInstIds.toList());

        // Remove completed test instance and training data
        await TestInstance.delete(testInst.id!);
        await TrainingData.delete(testInst.trainingId);
      }
    }
  }

  /// Create and return a new alarmTime and alarmWeekdays,
  /// chaging timezone to UTC
  ///
  /// RETURN: [newAlarmTime, newAlarmWeekdays]
  static Map<String, Object> _localToUTC(
      TimeOfDay alarmTime, List<bool> alarmWeekdays) {
    TimeOfDay utcAlarmTime;
    List<bool> utcAlarmWeekdays = List<bool>.from(alarmWeekdays);

    // Get timezone offset in minute
    int timeZoneOffset = DateTime.now().timeZoneOffset.inMinutes;

    // Check if weekdays must be adjusted
    int alarmTimeInMinute = alarmTime.hour * 60 + alarmTime.minute;
    if (alarmTimeInMinute < timeZoneOffset) {
      //-- weekdays should be adjusted by 1 --//
      int diffComplement = alarmTimeInMinute - timeZoneOffset + 24 * 60;
      utcAlarmTime = TimeOfDay(
        hour: (diffComplement / 60).floor(),
        minute: diffComplement % 60,
      );

      // rotate left the weekdays by 1
      for (int i = 0; i < 7; i++) {
        utcAlarmWeekdays[i] = alarmWeekdays[(i + 1) % 7];
      }
    } else {
      //-- no weekday adjustment is necessary --//
      utcAlarmTime = TimeOfDay(
        hour: ((alarmTimeInMinute - timeZoneOffset) / 60).floor(),
        minute: (alarmTimeInMinute - timeZoneOffset) % 60,
      );
    }

    return {
      "utcAlarmTime": utcAlarmTime,
      "utcAlarmWeekdays": utcAlarmWeekdays,
    };
  }

  /// Construct server-acceptable schedule string
  /// See `annoyer2-server/training.go` for detail
  static String _createScheduleString(
      TimeOfDay alarmTime, List<bool> alarmWeekdays) {
    String hh = alarmTime.hour.toString().padLeft(2, '0');
    String mm = alarmTime.minute.toString().padLeft(2, '0');
    String w7 = alarmWeekdays.map((e) => (e ? '1' : '0')).join();
    return '$hh$mm$w7';
  }
}
