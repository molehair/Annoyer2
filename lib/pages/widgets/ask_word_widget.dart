import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/question.dart';
import 'package:annoyer/training_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum _Status {
  waiting,
  correct,
  wrong,
}

class AskWordWidget extends StatefulWidget {
  const AskWordWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  _AskWordWidgetState createState() => _AskWordWidgetState();
}

class _AskWordWidgetState extends State<AskWordWidget>
    with AutomaticKeepAliveClientMixin {
  _Status _status = _Status.waiting;
  Word? _choice;
  bool _viewMnemonic = false;
  bool _viewDef = false;

  void _changeStatus(_Status newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  void _grade(Word? choice) async {
    _choice = choice;
    if (choice == null || choice.name != widget.question.word.name) {
      await TrainingSystem.grade(widget.question.word, false);
      _changeStatus(_Status.wrong);
    } else {
      await TrainingSystem.grade(widget.question.word, true);
      _changeStatus(_Status.correct);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          Text(
            widget.question.blankfiedEx,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: _status == _Status.waiting,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                enabled: _status == _Status.waiting,
                // autofocus: true,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.italic),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        // color: Colors.red,
                        // color: Theme.of(context).errorColor,
                        ),
                  ),
                  prefixIcon: Icon(Icons.short_text_outlined),
                ),
                // controller: _answerController,
              ),
              suggestionsCallback: (pattern) async {
                // search definitions from the index
                final Set<int> suggestionKeys =
                    Dictionary.nameIndex.search(pattern);

                // fetch definitions
                final List<Word> words = [];
                final Box<Word> box = await Hive.openBox(Dictionary.boxName);
                for (int key in suggestionKeys) {
                  Word? word = box.get(key);
                  if (word != null) {
                    words.add(word);
                  }
                }

                return words;
              },
              itemBuilder: (context, Word suggestion) {
                return ListTile(
                  // leading: Icon(Icons.shopping_cart),
                  title: Text(suggestion.name),
                  // subtitle: Text('\$${suggestion['price']}'),
                );
              },
              onSuggestionSelected: _grade,
              loadingBuilder: (context) => ListTile(
                title: Text(AppLocalizations.of(context)!.loading),
              ),
              noItemsFoundBuilder: (context) => ListTile(
                title: Text(
                  AppLocalizations.of(context)!.notFound,
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
              // errorBuilder: (BuildContext context, Object? error) => Text(
              //   '$error AAA',
              //   style: TextStyle(color: Theme.of(context).errorColor),
              // ),
            ),
          ),
          Visibility(
            visible: _status == _Status.wrong,
            child: Card(
              child: ListTile(
                leading: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  _choice != null ? _choice!.name : '',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _status != _Status.waiting,
            child: Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                title: Text(
                  widget.question.word.name,
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.short_text_outlined),
              title: Text(
                _viewDef
                    ? widget.question.word.def
                    : AppLocalizations.of(context)!.viewDefinition,
                style: _viewDef
                    ? null
                    : const TextStyle(fontStyle: FontStyle.italic),
              ),
              onTap: () => setState(() {
                _viewDef = !_viewDef;
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
