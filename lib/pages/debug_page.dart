import 'package:annoyer/browser.dart';
import 'package:annoyer/database/local_settings.dart';
import 'package:annoyer/database/log_item.dart';
import 'package:annoyer/database/practice_instance.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final TextEditingController _dailyIndexController = TextEditingController();
  final TextEditingController _trainingIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dailyIndexController.text = '0';
    _trainingIdController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('debug')),
      body: ListView(
        children: <Widget>[
          TextButton(
            child: const Text('view logs'),
            onPressed: () async {
              List<LogItem> logs = await LogItem.getAll();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                          body: ListView(
                            children: logs
                                .map((e) => ListTile(title: Text(e.log)))
                                .toList(),
                          ),
                        )),
              );
            },
          ),
          TextButton(
            child: const Text('delete logs'),
            onPressed: () async {
              await LogItem.deleteAll();
              debugPrint('deleted');
            },
          ),
          const Divider(),
          TextButton(
            child: const Text('test1'),
            onPressed: () async {
              var insts = await PracticeInstance.getAll();
              debugPrint(insts.length.toString());
            },
          ),
          TextButton(
            child: const Text('test2'),
            onPressed: () async {},
          ),
          TextButton(
            child: const Text('temp'),
            onPressed: () async {
              // send token to the server
              var res = await Browser.get("/test1", queryParameters: {
                "deviceId": await LocalSettings.getDeviceId(),
                "dailyIndex": _dailyIndexController.text,
              });
            },
          ),
          const Divider(),
          const ListTile(title: Text('training'), dense: true),
          ListTile(
            title: TextFormField(
              decoration: const InputDecoration(labelText: 'dailyIndex'),
              controller: _dailyIndexController,
            ),
          ),
          ListTile(
            title: TextFormField(
              decoration: const InputDecoration(labelText: 'trainingId'),
              controller: _trainingIdController,
            ),
          ),
          TextButton(
            child: const Text('Run [onTest]'),
            onPressed: () async {
              int trainingId = int.parse(_trainingIdController.text);
              Training.onTest({
                'trainingId': trainingId,
              });
            },
          ),
          TextButton(
            child: const Text('delete all practice instances'),
            onPressed: () async {
              await PracticeInstance.deleteAll();
              debugPrint('Removed all practice instances.');
            },
          ),
          TextButton(
            child: const Text('delete all test instances'),
            onPressed: () async {
              await TestInstance.deleteAll();
              debugPrint('Removed all test instances.');
            },
          ),
          TextButton(
            child: const Text('view trainingData'),
            onPressed: () async {
              int trainingId = int.parse(_trainingIdController.text);
              TrainingData? trainingData = await TrainingData.get(trainingId);
              debugPrint(trainingData.toString());
            },
          ),
          TextButton(
            child: const Text('delete trainingData'),
            onPressed: () async {
              int trainingId = int.parse(_trainingIdController.text);
              TrainingData.delete(trainingId);
              debugPrint('Deleted training data $trainingId');
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('words'),
            dense: true,
          ),
          ListTile(
            title: const Text('add bulk words'),
            onTap: () async {
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

              await Word.addAll(words);

              debugPrint('Added bulk words');
            },
          ),
          ListTile(
            title: const Text('drop all words'),
            onTap: () async {
              await Word.deleteAll();
              debugPrint('deleted all words');
            },
          ),
        ],
      ),
    );
  }
}
