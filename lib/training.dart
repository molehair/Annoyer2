// training system

import 'dart:math';

import 'package:annoyer/background_worker.dart';
import 'package:annoyer/database/local_settings.dart';
import 'package:annoyer/database/training_instance.dart';
import 'package:annoyer/database/question_ask_definition.dart';
import 'package:annoyer/database/question_ask_word.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/notification_center.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

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

  /// min.
  /// The time interval between two consecutive alarms
  /// This is a rough estimation. It may vary depending on
  /// machine's background worker policy such as workmanager in Android.
  static const int notiInterval = 20;

  /// number of words a day for training
  static const int numTrainingWords = 16;

  /// number of repetitions per a word
  static const int numReps = 3;

  /// number of words per a notification
  static const int numTrainingWordsPerAlarm = 3;

  /// number of practice alarms a day
  static final int numPracticeAlarmsPerDay =
      (1.0 * numTrainingWords * numReps / numTrainingWordsPerAlarm).ceil();

  /// number of alarms a day
  static final int numAlarmsPerDay = numPracticeAlarmsPerDay + 1;

  /// min.
  /// The expected total time of single training session
  static final int totalTime = notiInterval * (numAlarmsPerDay - 1);

  /// min.
  /// The length of time to which check if there exists
  /// a beginning point of a training session from the current time
  ///
  /// Must be less than totalTime.
  /// Otherwise, more than one training sessions may occur from one beginning point.
  static final int _beginningTolerance = (totalTime / 2).floor();

  /// the lifespan of trainingData
  static const Duration _trainingDataEffectiveDuration = Duration(days: 2);

  /// task identifiers for background worker
  static const String _taskId = 'training';

  /// notification identifier for on-tap notification callbacks
  static const String _notiKey = _taskId;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  static initialization() async {
    // init only once
    if (_inited) {
      return;
    }

    // set task handlers
    BackgroundWorker.registerPeriodicTask(_taskId, onBackgroundCallback);

    // register on-tap notification callbacks
    NotificationCenter.setOnTapCallback(
        _notiKey, (data) => onNotificationTapped(data!));

    // set test instance clean-up handler
    TrainingInstance.getStream().listen(_cleanUpCompleteInstances);

    // mark as finished initialization
    _inited = true;
  }

  /// When user tapped a training notification
  static Future<void> onNotificationTapped(Map<String, Object?>? data) async {
    int trainingId = data!['trainingId'] as int;
    int trainingIndex = data['trainingIndex'] as int;

    // Get instance key
    int instKey = _computeTrainingInstanceId(trainingId, trainingIndex);

    // Set target page
    Widget targetPage;
    if (isPractice(trainingIndex)) {
      // Fetch the instance
      TrainingInstance? inst = await TrainingInstance.get(instKey);
      if (inst == null) {
        throw 'No practice/test instance found by key $instKey';
      }
      inst.id = instKey;

      targetPage = PracticePage(inst: inst);
    } else {
      targetPage = TestPage(trainingId: trainingId);
    }

    Navigator.of(Global.navigatorKey.currentContext!).push(
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  /// Create and return a list of daily words for training
  ///
  /// RETURN: null if the list cannot be generated.
  static Future<TrainingData?> createTrainingData() async {
    TrainingData? trainingData;

    try {
      // select the keys of words
      List<int> chosenIds = await _chooseRandomWords(numTrainingWords);

      // create questions
      List<Question> questions = await _createQuestions(chosenIds);

      // set expiration
      DateTime expiration = DateTime.now().add(_trainingDataEffectiveDuration);

      //-- consolidate everything --//
      if (chosenIds.isNotEmpty) {
        trainingData = TrainingData(
          expiration: expiration,
          wordIds: chosenIds,
          questions: questions,
        );
      }
    } on Exception catch (e) {
      Log.error('creatingTrainingData', exception: e);
    }

    return trainingData;
  }

  /// Grade
  static Future<void> grade(
    TrainingData trainingData,
    int questionIndex,
    bool correct,
  ) async {
    var question = trainingData.questions[questionIndex];
    var word = question.word;

    // Update the level of a word
    if (correct) {
      word.level++;
    } else {
      word.level = max(word.level - 1, 1);
    }
    await Word.put(word);

    // set question state
    question.state = correct ? QuestionState.correct : QuestionState.wrong;

    // update the training data
    await TrainingData.put(trainingData);
  }

  /// Make practice/test instances and show notifications if necessary
  /// Called by background worker.
  ///
  /// For each live training instance, read trainingIndex.
  /// If trainingIndex < numAlarmsPerDay, issue a practice instance and increment trainingIndex.
  /// Otherwise, issue a test instance.
  ///
  /// Also, start a new training session if necessary.
  static void onBackgroundCallback() async {
    Log.info('onBackgroundCallback');

    bool alarmEnabled = (await LocalSettings.getAlarmEnabled()) ?? false;

    if (alarmEnabled) {
      // for all live training data
      List<TrainingData> trainingDatas = await TrainingData.getAll();

      // append a new training if necessary
      int? startWeekday = await _findStartingWeekday();
      if (startWeekday != null) {
        // check duplicate
        if (trainingDatas.every((td) => td.id != startWeekday)) {
          // create training data
          TrainingData? trainingData = await createTrainingData();

          // failed to create?
          if (trainingData == null) {
            throw 'Unable to create training data';
          }

          // use startWeekday as training id
          trainingData.id = startWeekday;

          // save
          await TrainingData.put(trainingData);

          // refresh training data
          trainingDatas = await TrainingData.getAll();
        }
      }

      // process every live training
      DateTime now = DateTime.now();
      for (TrainingData td in trainingDatas) {
        // Is valid training data?
        if (td.expiration.isBefore(now)) {
          // eliminate it if invalid
          await TrainingData.delete(td.id!);
        } else {
          Log.info('Issuing a training instance');

          // issue a training instance
          final int trainingIndex = td.lastTrainingIndex + 1;
          if (trainingIndex < numAlarmsPerDay) {
            await _issueTrainingInstance(td.id!, trainingIndex);
            td.lastTrainingIndex = trainingIndex;
            await TrainingData.put(td);
          }
        }
      }
    }
  }

  /// Check if trainingIndex indicates a practice instance.
  /// False if it does a test instance.
  static bool isPractice(int trainingIndex) {
    return trainingIndex < numPracticeAlarmsPerDay;
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//

  /// clean up completed tests
  static _cleanUpCompleteInstances(_) async {
    var insts = await TrainingInstance.getAll();

    for (TrainingInstance inst in insts) {
      // fetch training data
      var td = await TrainingData.get(inst.trainingId);

      // skip if the training data is already removed
      if (td == null) {
        continue;
      }

      // check if the test is complete
      if (td.questions.every((e) => e.state != QuestionState.intertermined)) {
        // remove all instances
        var allInsts = await TrainingInstance.getAll();
        var targetInsts = allInsts.where((inst) => inst.trainingId == td.id);
        var targetInstIds = targetInsts.map((e) => e.id!);
        TrainingInstance.deletes(targetInstIds.toList());

        // Remove training data
        await TrainingData.delete(td.id!);
      }
    }
  }

  /// Check if a new training session must begin and return the weekday[0-6] of the beginning datetime
  /// If no session must be made, return null.
  ///
  /// If (current datetime) - (closest past beginning datetime of a training session) < _beginningTolerance
  /// then make a new training session.
  static Future<int?> _findStartingWeekday() async {
    List<bool>? alarmWeekdays = await LocalSettings.getAlarmWeekdays();
    int? alarmTimeHour = await LocalSettings.getAlarmTimeHour();
    int? alarmTimeMinute = await LocalSettings.getAlarmTimeMinute();

    if (alarmWeekdays != null &&
        alarmTimeHour != null &&
        alarmTimeMinute != null) {
      DateTime now = DateTime.now();
      DateTime dt = DateTime(
          now.year, now.month, now.day, alarmTimeHour, alarmTimeMinute);
      for (int i = 0; i < 7; i++) {
        if (dt.isBefore(now) &&
            dt.isAfter(now.subtract(Duration(minutes: _beginningTolerance))) &&
            alarmWeekdays[dt.weekday % 7]) {
          return dt.weekday % 7;
        }
      }
    }

    return null;
  }

  /// Choose random distinct [numWords] words from dictionary
  /// Return: List of keys
  ///
  /// If the dictionary has less than [numWords] words, then
  /// the list of all words is returned.
  static Future<List<int>> _chooseRandomWords(int numWords) async {
    // get the number of the entire words in the dictionary
    List<Word> words = await Word.getAll();
    List<int> ids = words.map((e) => e.id!).toList();
    int numDictWords = words.length;

    // select words
    // split into cases by the total number of words in dictionary
    if (numDictWords == 0) {
      //-- no word case --//
      // no training words
      return [];
    } else if (numDictWords <= numWords) {
      //-- the number of total words is no larger than [numWords] --//
      // put the entire words into the training
      return ids;
    } else {
      //-- the number of total words exceeds numWords --//
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
      return trainingDataIndicesSet.map((index) => ids[index]).toList();
    }
  }

  static Future<List<Question>> _createQuestions(List<int> wordIds) async {
    List<Question> questions = [];

    for (var i = 0; i < wordIds.length; i++) {
      var wordId = wordIds[i];
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

    return questions;
  }

  static Future<void> _issueTrainingInstance(
    int trainingId,
    int trainingIndex,
  ) async {
    int instId = _computeTrainingInstanceId(trainingId, trainingIndex);

    // notification
    final String title =
        isPractice(trainingIndex) ? t.practiceNotifier : t.testNotifier;
    var notificationId = await NotificationCenter.show(
      title: title,
      data: {'trainingId': trainingId, 'trainingIndex': trainingIndex},
      key: _notiKey,
    );

    // add an instance
    await TrainingInstance.put(
      TrainingInstance(
        id: instId,
        trainingIndex: trainingIndex,
        trainingId: trainingId,
        notificationId: notificationId,
      ),
    );

    Log.info(
        'Issued a training instance with trainingId $trainingId, trainingIndex $trainingIndex, notificationId $notificationId');
  }

  /// Compute the id for a training instance
  ///
  /// Note that 0 <= [trainingIndex] <= [numAlarmsPerDay]
  /// Thus, there exist [numAlarmsPerDay] + 1 instances at most for each [trainingId].
  static int _computeTrainingInstanceId(int trainingId, int trainingIndex) {
    return trainingId * (numAlarmsPerDay + 1) + trainingIndex;
  }
}
