import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/question.dart';
import 'package:annoyer/training_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/ask_definition_widget.dart';
import 'widgets/ask_word_widget.dart';

/// the required minimum number of words in dictionary
///
/// This is needed because at least four selections from dictionary must be
/// available in multiple choice questions.
/// If there are other method to get selections such as fetching from
/// pre-defined definitions or examples, then consider remove this limit.
const int _minNumWords = 4;

class TestPage extends StatelessWidget {
  TestPage({Key? key})
      : loader = _load(),
        super(key: key);

  final Future loader;

  /// return generate and return questions
  static Future _load() async {
    final List<Question> questions = [];

    // load training words
    TrainingData? trainingData = await TrainingSystem.loadTrainingWords();

    // Validation check
    Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
    if (trainingData != null &&
            DateTime.now().isBefore(trainingData.expiration) && // expiration
            box.keys.length >= _minNumWords // minimum number of words
        ) {
      //-- valid --//
      // create questions
      Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
      for (int i = 0; i < trainingData.wordKeys.length; i++) {
        // get a word
        dynamic key = trainingData.wordKeys[i];
        Word? word = box.get(key);
        if (word != null) {
          //-- make a question --//
          questions.add(Question.random(word));
        }
      }
    } else {
      //-- invalid --//
      // remove them
      await TrainingSystem.removeTrainingWords();
    }

    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loader,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('SomethingWentWrong();');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _TestPageMain(
            questions: snapshot.data as List<Question>,
          );
        }

        return const Text('Loading...');
      },
    );
  }
}

class _TestPageMain extends StatefulWidget {
  const _TestPageMain({
    Key? key,
    required this.questions,
  }) : super(key: key);

  final List<Question> questions;

  @override
  __TestPageMainState createState() => __TestPageMainState();
}

class __TestPageMainState extends State<_TestPageMain> {
  final List<Widget> _views = [];

  @override
  void initState() {
    super.initState();

    // make views for each tab
    for (int i = 0; i < widget.questions.length; i++) {
      Question question = widget.questions[i];
      switch (question.type) {
        case QuestionType.askDefinition:
          _views.add(AskDefinitionWidget(question: question));
          break;
        case QuestionType.askWord:
          _views.add(AskWordWidget(question: question));
          break;
        default:
          _views.add(const Text('unknown question type'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return _emptyPage(context);
    } else {
      return DefaultTabController(
        length: _views.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.test),
          ),
          body: TabBarView(
            children: _views,
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
    }
  }

  /// If there is no word to show...
  Widget _emptyPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.test),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
            ),
            Text(
              AppLocalizations.of(context)!.noWordToShow,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
