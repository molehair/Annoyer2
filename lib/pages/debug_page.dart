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
              List<Word> words = [
                Word(
                  name: 'brainwash into',
                  def:
                      "to condition one’s mind into believing information by repeatedly telling them something or using manipulation",
                  ex: "Using hypnosis, the magician was able to brainwash the audience member into believing that he was a chicken.",
                ),
                Word(
                  name: 'attorney',
                  def:
                      "a person appointed to act for another in business or legal matters(frequently, lawyer)",
                  ex: "If you’re ever arrested, refuse to answer questions and ask to speak to an attorney.",
                ),
                Word(
                  name: 'enclave',
                  def:
                      "a portion of territory surrounded by a larger territory whose inhabitants are culturally or ethnically distinct.",
                  ex: "As the teen explored the immigrant enclave, he felt as though he was in another nation.",
                ),
                Word(
                  name: 'turn the tables on',
                  def: 'to change or reverse something dramatically',
                  ex: 'Wow, they really turned the tables on their opponents after the intermission.',
                ),
                Word(
                  name: 'read between the lines',
                  def:
                      'look for or discover a meaning that is hidden or implied rather than explicitly stated.',
                  ex: "After listening to what she said, if you read between the lines, you can begin to see what she really means. Don't believe every thing you read literally. Learn to read between the lines.",
                ),
                Word(
                  name: 'laid-back',
                  def: 'relaxed and easy-going',
                  ex: "Angie wished to give up her busy, New York City lifestyle for laid-back beach life.",
                ),
                Word(
                  name: 'knock off',
                  def:
                      'to cause something to fall off of a surface by striking or colliding with it, either intentionally or unintentionally',
                  ex: "Please don't dance so close to the table, you'll knock off those papers.",
                ),
                Word(
                  name: "Don't get me wrong",
                  def: "Don't misinterpret what I'm saying as criticism",
                  ex: "I mean, don't get me wrong. Joanie's my best friend, but she can be kind of a pain sometimes.",
                ),
              ];

              await box.addAll(words);
            },
          ),
          ListTile(
            title: const Text('add bulk words 2'),
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
