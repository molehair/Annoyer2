import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/question.dart';
import 'package:annoyer/training_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

enum _Status {
  waiting,
  correct,
  wrong,
}

class AskDefinitionWidget extends StatefulWidget {
  const AskDefinitionWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  State<AskDefinitionWidget> createState() => AskDefinitionWidgetState();
}

class AskDefinitionWidgetState extends State<AskDefinitionWidget>
    with AutomaticKeepAliveClientMixin {
  _Status _status = _Status.waiting;
  Word? _choice;

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
            widget.question.word.name,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: _status == _Status.waiting,
            child: Row(
              children: [
                Flexible(
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
                          Dictionary.defIndex.search(pattern);

                      // fetch definitions
                      final List<Word> words = [];
                      final Box<Word> box =
                          await Hive.openBox(Dictionary.boxName);
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
                        title: Text(suggestion.def),
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
                  visible: widget.question.word.mnemonic != null &&
                      widget.question.word.mnemonic != '',
                  child: JustTheTooltip(
                    child: const Icon(Icons.lightbulb_outline),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.question.word.mnemonic ?? ''),
                    ),
                    triggerMode: TooltipTriggerMode.tap,
                    preferredDirection: AxisDirection.up,
                  ),
                ),
              ],
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
                  _choice != null ? _choice!.def : '',
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
                  widget.question.word.def,
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _status != _Status.waiting,
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.notes_outlined),
                title: Text(
                  widget.question.word.ex,
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _status != _Status.waiting &&
                widget.question.word.mnemonic != null &&
                widget.question.word.mnemonic != '',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(
                  widget.question.word.mnemonic ?? '',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
