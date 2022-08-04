import 'package:annoyer/database/local_settings.dart';
import 'package:annoyer/database/predefined_word.dart';
import 'package:annoyer/database/question_ask_word.dart';
import 'package:annoyer/database/training_instance.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final TextEditingController _trainingIndexController =
      TextEditingController();
  final TextEditingController _trainingIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _trainingIndexController.text = '0';
    _trainingIdController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('debug')),
      body: ListView(
        children: <Widget>[
          const Divider(),
          TextButton(
            child: const Text('clear predefined words'),
            onPressed: () async {
              LocalSettings.setPredefinedWordsVersion(0);
              await PredefinedWord.deleteAll();
              debugPrint('removed all predefined words');
            },
          ),
          const Divider(),
          const ListTile(title: Text('training'), dense: true),
          TextButton(
            child: const Text('Reschedule workmanager'),
            onPressed: () async {
              await Workmanager().cancelAll();
              await Workmanager().registerPeriodicTask(
                'workmanager',
                'workmanager',
                frequency: const Duration(minutes: 20),
              );
            },
          ),
          TextButton(
            child: const Text('Run [onBackgroundCallback]'),
            onPressed: () async {
              Training.onBackgroundCallback();
            },
          ),
          TextButton(
            child: const Text('delete all training instances'),
            onPressed: () async {
              await TrainingInstance.deleteAll();
              debugPrint('Removed all practice instances.');
            },
          ),
          TextButton(
            child: const Text('view all trainingData'),
            onPressed: () async {
              var tds = await TrainingData.getAll();
              for (var td in tds) {
                debugPrint(td.toString());
              }
              debugPrint('Total ${tds.length}');
            },
          ),
          TextButton(
            child: const Text('delete all trainingData'),
            onPressed: () async {
              TrainingData.deleteAll([0, 1, 2, 3, 4, 5, 6]);
              debugPrint('Deleted all training data');
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
          const Divider(),
          TextButton(
            child: const Text('check blankify correctness'),
            onPressed: () async {
              for (var testSet in blankifyTestSet) {
                var blankified = QuestionAskWord.blankify(
                    testSet['ex']!, testSet['term']!,
                    blank: debugBlank);
                if (blankified != testSet['correctAnswer']!) {
                  debugPrint('Test failed');
                  debugPrint(testSet['ex']);
                  debugPrint(testSet['term']);
                  debugPrint(testSet['correctAnswer']);
                  debugPrint(blankified);
                  return;
                }
              }
              debugPrint('All tests have passed');
            },
          ),
        ],
      ),
    );
  }
}

const debugBlank = '__';
var blankifyTestSet = [
  {
    'term': 'prop',
    'ex': 'She propped her chin in the palm of her right hand.',
    'correctAnswer':
        'She ' + debugBlank + ' her chin in the palm of her right hand.',
  },
  {
    'term': 'drop by',
    'ex': 'Send an email before dropping by a professor.',
    'correctAnswer': 'Send an email before ' +
        debugBlank +
        ' ' +
        debugBlank +
        ' a professor.',
  },
  {
    'term': 'trip over',
    'ex':
        'The place was filled with sleeping people. I tripped over perfect strangers on my way to the door.',
    'correctAnswer': 'The place was filled with sleeping people. I ' +
        debugBlank +
        ' ' +
        debugBlank +
        ' perfect strangers on my way to the door.',
  },
  {
    'term': 'lug',
    'ex':
        "I'm exhausted after lugging these suitcases all the way across the city.",
    'correctAnswer': "I'm exhausted after " +
        debugBlank +
        " these suitcases all the way across the city.",
  },
  {
    'term': 'at all cost',
    'ex': "Please, save my husband at all costs-I can't live without him!",
    'correctAnswer': "Please, save my husband " +
        debugBlank +
        " " +
        debugBlank +
        " " +
        debugBlank +
        "-I can't live without him!",
  },
  {
    'term': 'plop down',
    'ex': 'He plopped himself down in the chair.',
    'correctAnswer':
        'He ' + debugBlank + ' himself ' + debugBlank + ' in the chair.',
  },
  {
    'term': 'aaaa',
    'ex': 'He plopped himself down in the chair.',
    'correctAnswer': 'He plopped himself down in the chair.',
  },
  {
    'term': 'aa bb',
    'ex': 'He plopped himself down in the chair.',
    'correctAnswer': 'He plopped himself down in the chair.',
  },
];
