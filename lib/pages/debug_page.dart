import 'dart:convert';
import 'dart:math';

import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/training_system.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

class DebugPage extends StatelessWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('debug')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('manual practice'),
            onTap: () {
              Random rng = Random();
              TrainingSystem.setSingleAlarm(
                id: 10000 + rng.nextInt(10000),
                scheduledDate:
                    tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
                title: 'manual practice',
                payload: jsonEncode(
                  {
                    fieldKey: 'training',
                    fieldDailyIndex: rng.nextInt(10000),
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('manual test'),
            onTap: () {
              Random rng = Random();
              TrainingSystem.setSingleAlarm(
                id: 10000 + rng.nextInt(10000),
                scheduledDate:
                    tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
                title: 'manual test',
                payload: jsonEncode(
                  {
                    fieldKey: 'training',
                    fieldDailyIndex: numAlarmsPerDay,
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('delete trainingData'),
            onTap: () {
              TrainingSystem.removeTrainingWords();
            },
          ),
          ListTile(
            title: const Text('add bulk words'),
            onTap: () async {
              Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
              List<Word> words = [];
              for (int i = 0; i < 17; i++) {
                Word word = Word(name: 'word$i', def: 'def$i', ex: 'ex$i');
                if (i % 2 == 0) {
                  word.mnemonic = 'mnemonic$i';
                }
                words.add(word);
              }
              await box.addAll(words);
            },
          ),
          ListTile(
            title: const Text('delete all words'),
            onTap: () async {
              Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
              await box.deleteAll(box.keys);
            },
          ),
          ListTile(
            title: const Text('index test'),
            onTap: () async {
              Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
              Set<int> result = Dictionary.defIndex.search('def');
              for (int key in result) {
                Word? word = box.get(key);
                debugPrint('$key: ${word!.def}');
              }
            },
          ),
          ListTile(
            title: const Text('view dictionary'),
            onTap: () async {
              Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
              for (dynamic key in box.keys) {
                Word word = box.get(key)!;
                debugPrint('key($key): $word');
              }
            },
          ),
        ],
      ),
    );
  }
}
