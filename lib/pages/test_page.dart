import 'dart:math';

import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:flutter/material.dart';

import 'widgets/ask_definition_widget.dart';
import 'widgets/ask_word_widget.dart';

class TestPage extends StatelessWidget {
  final int trainingId;
  final Future<Map<String, Object>> _initialization;

  TestPage({
    Key? key,
    required this.trainingId,
  })  : _initialization = _load(trainingId),
        super(key: key);

  /// generate and return question widgets
  static Future<Map<String, Object>> _load(int trainingId) async {
    // fetch training data
    TrainingData? trainingData = await TrainingData.get(trainingId);

    // make views for each tab
    List<Widget> views = [];
    int initIndex = 0;
    if (trainingData != null) {
      int n = trainingData.questions.length;
      initIndex = n;
      for (int i = 0; i < n; i++) {
        Question question = trainingData.questions[i];

        // update initial page index
        if (question.state == QuestionState.intertermined) {
          initIndex = min(initIndex, i);
        }

        // add a view
        switch (question.type) {
          case QuestionType.askDefinition:
            views.add(AskDefinitionWidget(
              trainingData: trainingData,
              questionIndex: i,
            ));
            break;
          case QuestionType.askWord:
            views.add(AskWordWidget(
              trainingData: trainingData,
              questionIndex: i,
            ));
            break;
          default:
            views.add(const Text('unknown question type'));
        }
      }
    }

    return {'initIndex': initIndex, 'views': views};
  }

  /// If there is no word to show...
  Widget _emptyPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.test)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80),
            Text(
              t.noWordToShow,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  static String getTitle(int weekday) {
    var weekdayString = [
      t.sunday,
      t.monday,
      t.tuesday,
      t.wednesday,
      t.thursday,
      t.friday,
      t.saturday,
    ][weekday % 7];
    return t.testTitle(weekdayFull: weekdayString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Object>>(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('SomethingWentWrong();');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          var res = snapshot.data!;
          int initIndex = res['initIndex']! as int;
          int n = (res['views']! as List).length;
          List<Widget> views = List<Widget>.generate(
              n, (index) => (res['views'] as List)[index]);
          if (n == 0) {
            return _emptyPage(context);
          } else {
            return DefaultTabController(
              length: n,
              initialIndex: initIndex,
              child: Scaffold(
                appBar: AppBar(title: Text(getTitle(trainingId))),
                body: TabBarView(children: views),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [TabPageSelector()],
                  ),
                ),
              ),
            );
          }
        }

        // loading
        return const CircularProgressIndicator();
      },
    );
  }
}
