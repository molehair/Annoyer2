import 'dart:math';

import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/question.dart';
import 'package:annoyer/training_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum _Status {
  waiting,
  correct,
  wrong,
}

/// Must have at least four(preferrably 16) words in the dictionary
class AskDefinitionWidget extends StatelessWidget {
  AskDefinitionWidget({
    Key? key,
    required this.question,
  }) : super(key: key) {
    initialization = _selectCandidates();
  }

  final Question question;
  late final Future initialization;
  static const int _numCandidates = 4; // the number of candidates(choices)
  final List<Word> _candidates = [];

  /// prepare multiple choices
  Future<void> _selectCandidates() async {
    // add the correct answer to the candidate list
    _candidates.add(question.word);

    // fill the rest
    Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
    int numWords = box.keys.length;
    Random rng = Random();
    for (int i = 0; i < _numCandidates - 1;) {
      // choose a random word from dictionary
      int r = rng.nextInt(numWords);
      Word? word = box.getAt(r);

      // check validity(need this code?)
      if (word == null) {
        continue;
      }

      // add to the list only if no duplicate
      if (!_candidates.contains(word)) {
        _candidates.add(word);
        i++;
      }
    }

    // shuffle
    _candidates.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('SomethingWentWrong();');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // ordinary launch
          return _AskDefinitionWidgetMain(
            question: question,
            candidates: _candidates,
          );
        }

        return const Text('Loading...');
      },
    );
  }
}

class _AskDefinitionWidgetMain extends StatefulWidget {
  const _AskDefinitionWidgetMain({
    Key? key,
    required this.question,
    required this.candidates,
  }) : super(key: key);

  final Question question;
  final List<Word> candidates;

  @override
  State<_AskDefinitionWidgetMain> createState() =>
      _AskDefinitionWidgetMainState();
}

class _AskDefinitionWidgetMainState extends State<_AskDefinitionWidgetMain>
    with AutomaticKeepAliveClientMixin {
  _Status _status = _Status.waiting;
  Word? _choice;
  bool _viewMnemonic = false;
  bool _viewExample = false;

  void _changeStatus(_Status newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  void _grade(Word? choice) async {
    _choice = choice;
    if (choice == null || choice.def != widget.question.word.def) {
      await TrainingSystem.grade(widget.question.word, false);
      _changeStatus(_Status.wrong);
    } else {
      await TrainingSystem.grade(widget.question.word, false);
      _changeStatus(_Status.correct);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const SizedBox(height: 24),
          Text(
            widget.question.question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Text(
            widget.question.word.name,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Table(
            children: widget.candidates.map((Word word) {
              // leading
              Icon leading = const Icon(Icons.radio_button_unchecked_outlined);
              if (_status != _Status.waiting) {
                //-- after grading --//
                if (_status == _Status.wrong &&
                    _choice != null &&
                    _choice!.def == word.def) {
                  // wrong selection
                  leading = const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  );
                } else if (word.def == widget.question.word.def) {
                  // correct answer
                  leading = const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  );
                }
              }

              // enabled
              bool enabled = true;
              if (_status != _Status.waiting) {
                // disable candidates which is not the user's selection
                // nor correct answer after grading
                if ((_choice == null || _choice!.def != word.def) &&
                    widget.question.word.def != word.def) {
                  enabled = false;
                }
              }

              return TableRow(children: [
                Card(
                  child: ListTile(
                    leading: leading,
                    title: Text(word.def),
                    onTap: () => _grade(word),
                    enabled: enabled,
                  ),
                ),
              ]);
            }).toList(),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notes_outlined),
              title: Text(
                _viewExample
                    ? widget.question.word.ex
                    : AppLocalizations.of(context)!.viewExample,
                style: _viewExample
                    ? null
                    : const TextStyle(fontStyle: FontStyle.italic),
              ),
              onTap: () => setState(() {
                _viewExample = !_viewExample;
              }),
            ),
          ),
          Visibility(
            visible: widget.question.word.mnemonic != null &&
                widget.question.word.mnemonic != '',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(
                  _viewMnemonic
                      ? widget.question.word.mnemonic ?? ''
                      : AppLocalizations.of(context)!.viewMnemonic,
                  style: _viewMnemonic
                      ? null
                      : const TextStyle(fontStyle: FontStyle.italic),
                ),
                onTap: () => setState(() {
                  _viewMnemonic = !_viewMnemonic;
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: _status == _Status.waiting,
            child: TextButton(
              onPressed: () => _grade(null),
              child: Text(AppLocalizations.of(context)!.giveUp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
