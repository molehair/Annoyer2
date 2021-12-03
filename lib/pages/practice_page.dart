// Practice shows up when the user touches the practice notification.

import 'dart:math';

import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/training_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PracticePage extends StatelessWidget {
  PracticePage({Key? key, required this.dailyIndex})
      : _loader = _load(dailyIndex),
        super(key: key);

  final int dailyIndex;
  final Future<List<Word>> _loader;

  /// select the words to show and return them as a list
  static Future<List<Word>> _load(int dailyIndex) async {
    final List<Word> words = [];

    // load training words
    TrainingData? trainingData = await TrainingSystem.loadTrainingWords();

    // Validation check.
    if (trainingData == null ||
        trainingData.expiration.isBefore(DateTime.now())) {
      //-- invalid --//
      // make one
      trainingData = await TrainingSystem.createTrainingData();

      // save if successfully made
      if (trainingData != null) {
        await TrainingSystem.saveTrainingWords(trainingData);
      }
    }

    if (trainingData != null) {
      // Retrieve the words to show
      // choose ((dailyIndex * numTrainingWordsPerAlarm) +0) % numTrainingWords,
      //        ((dailyIndex * numTrainingWordsPerAlarm) +1) % numTrainingWords,
      //        ((dailyIndex * numTrainingWordsPerAlarm) +2) % numTrainingWords,
      //        ... ,
      Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
      for (int i = 0;
          i < min(numTrainingWordsPerAlarm, trainingData.wordKeys.length);
          i++) {
        // compute the index
        int j = (dailyIndex * numTrainingWordsPerAlarm + i) %
            trainingData.wordKeys.length;

        // get a word
        dynamic key = trainingData.wordKeys[j];
        Word? word = box.get(key);

        // Check if the word wasn't deleted.
        if (word != null) {
          words.add(word);
        }
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

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // make views for each tab
          final List<Word> words = snapshot.data as List<Word>;

          if (words.isNotEmpty) {
            // If there is at least one word to show
            return DefaultTabController(
              length: words.length,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.practice),
                ),
                body: TabBarView(
                  // controller: _tabController,
                  children: words
                      .map(
                        (word) => ListView(
                          children: [
                            ListTile(
                              title: Center(
                                child: Text(
                                  word.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!.definition,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    dense: true,
                                  ),
                                  ListTile(
                                    contentPadding:
                                        const EdgeInsets.only(left: 40),
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
                                      AppLocalizations.of(context)!.example,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    dense: true,
                                  ),
                                  ListTile(
                                    contentPadding:
                                        const EdgeInsets.only(left: 40),
                                    title: Text(word.ex),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  word.mnemonic != '' && word.mnemonic != null,
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        AppLocalizations.of(context)!.mnemonic,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      dense: true,
                                    ),
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.only(left: 40),
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
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [TabPageSelector()],
                  ),
                ),
              ),
            );
          } else {
            // If there is no word to show because they're all deleted
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.practice),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                    ),
                    Text(
                      AppLocalizations.of(context)!.noWordToShow,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return const Text('Loading...');
      },
    );
  }
}
