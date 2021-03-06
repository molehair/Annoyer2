// Practice shows up when the user touches the practice notification.

import 'dart:math';

import 'package:annoyer/database/practice_instance.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';

class PracticePage extends StatelessWidget {
  PracticePage({
    Key? key,
    required this.inst,
  })  : _loader = _load(inst),
        super(key: key) {
    // remove instance after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PracticeInstance.delete(inst.id!);
    });
  }

  final PracticeInstance inst;
  final Future<List<Word>> _loader;

  /// Load the words to show
  /// RETURN
  /// 1. the loaded words if they're valid
  /// 2. empty list, otherwise
  static Future<List<Word>> _load(PracticeInstance inst) async {
    // load training words
    TrainingData? trainingData = await TrainingData.get(inst.trainingId);

    // Validation check.
    if (trainingData == null || !trainingData.isValid()) {
      //-- invalid --//
      return [];
    }

    // Retrieve the words to show
    // choose ((dailyIndex * numTrainingWordsPerAlarm) +0) % numTrainingWords,
    //        ((dailyIndex * numTrainingWordsPerAlarm) +1) % numTrainingWords,
    //        ((dailyIndex * numTrainingWordsPerAlarm) +2) % numTrainingWords,
    //        ... ,
    List<Word> words = [];
    for (int i = 0;
        i <
            min(
              Training.numTrainingWordsPerAlarm,
              trainingData.wordIds.length,
            );
        i++) {
      // compute the index
      int j = (inst.dailyIndex * Training.numTrainingWordsPerAlarm + i) %
          trainingData.wordIds.length;

      // get a word
      dynamic key = trainingData.wordIds[j];
      Word? word = await Word.get(key);

      // Check if the word wasn't deleted.
      if (word != null) {
        words.add(word);
      }
    }

    return words;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loader,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('SomethingWentWrong();');
        }

        // set body
        Widget body;
        int tabLength = 1;
        if (snapshot.connectionState == ConnectionState.done) {
          // read words
          List<Word> words = snapshot.data as List<Word>;

          // set tab length
          tabLength = words.length;

          if (words.isNotEmpty) {
            // If there is at least one word to show
            body = showWords(words);
          } else {
            // If there is no word to show because they're all deleted
            body = noWordToShow();
          }
        } else {
          // loading widget
          body = const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: tabLength,
          child: Scaffold(
            appBar: AppBar(title: Text(t.practice)),
            body: body,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [TabPageSelector()],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget showWords(List<Word> words) {
  return TabBarView(
    children: words
        .map(
          (word) => ListView(
            children: [
              ListTile(
                title: Center(
                  child: Text(
                    word.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        t.definition,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                      title: Text(word.def),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        t.example,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      dense: true,
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                      title: Text(word.ex),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: word.mnemonic != '' && word.mnemonic != null,
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          t.mnemonic,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        dense: true,
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(40, 0, 20, 0),
                        title: Text(word.mnemonic ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .toList(),
  );
}

Widget noWordToShow() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 80,
        ),
        Text(
          t.noWordToShow,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}
