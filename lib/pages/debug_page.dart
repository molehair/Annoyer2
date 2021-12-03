import 'dart:convert';
import 'dart:math';

import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/training_system.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DebugPage extends StatelessWidget {
  DebugPage({Key? key}) : super(key: key);

  final TextEditingController _dailyIndexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('debug')),
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text('training'),
            dense: true,
          ),
          ListTile(
            title: TextFormField(
              decoration: const InputDecoration(labelText: 'dailyIndex'),
              controller: _dailyIndexController,
            ),
          ),
          ListTile(
            title: const Text('fire training notification'),
            onTap: () {
              int dailyIndex = 0;
              try {
                dailyIndex = int.parse(_dailyIndexController.text);
              } catch (e) {}

              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 100000 + dailyIndex,
                  channelKey: TrainingSystem.notificationChannel.channelKey!,
                  title: 'debug training $dailyIndex',
                  body: 'debug body',
                  payload: {
                    fieldDailyIndex: dailyIndex.toString(),
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('debugPrint trainingData'),
            onTap: () async {
              TrainingData? trainingData =
                  await TrainingSystem.loadTrainingWords();

              debugPrint('trainingData: $trainingData');
            },
          ),
          ListTile(
            title: const Text('delete trainingData'),
            onTap: () {
              TrainingSystem.removeTrainingWords();
            },
          ),
          const ListTile(
            title: Text('words'),
            dense: true,
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
