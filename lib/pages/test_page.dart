import 'package:annoyer/database/question_ask_definition.dart';
import 'package:annoyer/database/question_ask_word.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:flutter/material.dart';

import 'widgets/ask_definition_widget.dart';
import 'widgets/ask_word_widget.dart';

class TestPage extends StatelessWidget {
  TestPage({
    Key? key,
    required this.inst,
  })  : _initialization = _load(inst),
        super(key: key);

  final TestInstance inst;
  final Future<List<Widget>> _initialization;

  /// return generate and return questions
  static Future<List<Widget>> _load(TestInstance inst) async {
    assert(inst.id != null);

    // Make questions
    List<Question> questions = [];
    TrainingData? trainingData = await TrainingData.get(inst.trainingId);
    if (trainingData != null && trainingData.isValid()) {
      //-- training data is valid --//
      // fetch questions
      questions = inst.questions;
    } else {
      //-- training data is invalid --//
      // remove them
      await TrainingData.delete(inst.trainingId);
    }

    // make views for each tab
    List<Widget> views = [];
    for (int i = 0; i < questions.length; i++) {
      Question question = questions[i];
      switch (question.type) {
        case QuestionType.askDefinition:
          views.add(AskDefinitionWidget(
            testInstKey: inst.id!,
            question: question as QuestionAskDefinition,
          ));
          break;
        case QuestionType.askWord:
          views.add(AskWordWidget(
            testInstKey: inst.id!,
            question: question as QuestionAskWord,
          ));
          break;
        default:
          views.add(const Text('unknown question type'));
      }
    }

    return views;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('SomethingWentWrong();');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Widget> views = snapshot.data!;
          if (views.isEmpty) {
            return _emptyPage(context);
          } else {
            return DefaultTabController(
              length: views.length,
              child: Scaffold(
                appBar: AppBar(title: Text(t.test)),
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
        return const Text('Loading...');
      },
    );
  }
}
