import 'package:annoyer/database/question_ask_word.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/log.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AskWordWidget extends StatefulWidget {
  final int testInstKey;
  final QuestionAskWord question;

  const AskWordWidget({
    Key? key,
    required this.testInstKey,
    required this.question,
  }) : super(key: key);

  @override
  _AskWordWidgetState createState() => _AskWordWidgetState();
}

class _AskWordWidgetState extends State<AskWordWidget>
    with AutomaticKeepAliveClientMixin {
  bool _viewMnemonic = false;
  bool _viewDef = false;

  void _grade(Word? chosen) async {
    String? answer = chosen?.name;

    // grade
    if (answer != null && answer == widget.question.word.name) {
      //-- correct --//
      // set question state
      widget.question.state = QuestionState.correct;

      // update word level
      // As this takes long time with firestore, do asynchronously
      Training.grade(widget.question.word, true);
    } else {
      //-- wrong --//
      // set question state
      widget.question.state = QuestionState.wrong;

      // update word level
      // As this takes long time with firestore, do asynchronously
      Training.grade(widget.question.word, false);
    }

    // update to db
    widget.question.usersAnswer = answer;
    TestInstance? inst = await TestInstance.get(widget.testInstKey);
    if (inst != null) {
      inst.questions[widget.question.index] = widget.question;
      await TestInstance.put(inst);
    } else {
      logger.e('Unable to get test instance with key ${widget.testInstKey}.');
    }

    // update the current page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const SizedBox(height: 24),

          // title
          Text(
            t.askWord,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),

          // word
          Text(
            widget.question.blankfiedEx,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),

          // answer field
          Visibility(
            visible: widget.question.state == QuestionState.intertermined,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                // enabled: widget.question.state == QuestionState.intertermined,
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
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                // controller: _answerController,
              ),
              suggestionsCallback: (pattern) async {
                // search definitions from the index
                final Set<int> suggestionIds =
                    Word.nameIndex.search(pattern.trim());

                // fetch definitions
                final List<Word> words = [];
                for (int id in suggestionIds) {
                  Word? word = await Word.get(id);
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
              loadingBuilder: (context) => const ListTile(
                title: Center(child: CircularProgressIndicator()),
              ),
              noItemsFoundBuilder: (context) => ListTile(
                title: Text(
                  t.notFound,
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
              // errorBuilder: (BuildContext context, Object? error) => Text(
              //   '$error AAA',
              //   style: TextStyle(color: Theme.of(context).errorColor),
              // ),
            ),
          ),
          const SizedBox(height: 24),

          // wrong
          Visibility(
            visible: widget.question.state == QuestionState.wrong,
            child: Card(
              child: ListTile(
                leading: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  widget.question.usersAnswer ?? '',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // correct answer
          Visibility(
            visible: widget.question.state != QuestionState.intertermined,
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
          const SizedBox(height: 24),

          // view definition
          Card(
            child: ListTile(
              leading: const Icon(Icons.short_text_outlined),
              title: Text(
                _viewDef ? widget.question.word.def : t.viewDefinition,
                style: _viewDef
                    ? null
                    : const TextStyle(fontStyle: FontStyle.italic),
              ),
              onTap: () => setState(() {
                _viewDef = !_viewDef;
              }),
            ),
          ),
          const SizedBox(height: 24),

          // view mnemonic
          Visibility(
            visible: widget.question.word.mnemonic != null &&
                widget.question.word.mnemonic != '',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(
                  _viewMnemonic
                      ? widget.question.word.mnemonic ?? ''
                      : t.viewMnemonic,
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

          // give up button
          Visibility(
            visible: widget.question.state == QuestionState.intertermined,
            child: TextButton(
              onPressed: () => _grade(null),
              child: Text(t.giveUp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
