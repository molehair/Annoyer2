import 'package:annoyer/database/question_ask_word.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AskWordWidget extends StatefulWidget {
  final TrainingData trainingData;
  final int questionIndex;
  final QuestionAskWord _question;

  AskWordWidget({
    Key? key,
    required this.trainingData,
    required this.questionIndex,
  })  : _question = trainingData.questions[questionIndex] as QuestionAskWord,
        super(key: key);

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
    if (answer != null && answer == widget._question.word.name) {
      //-- correct --//
      // set question state
      widget._question.state = QuestionState.correct;

      // update training data
      // As this takes long time with firestore, do asynchronously
      Training.grade(widget.trainingData, widget.questionIndex, true);
    } else {
      //-- wrong --//
      // set question state
      widget._question.state = QuestionState.wrong;

      // update training data
      // As this takes long time with firestore, do asynchronously
      Training.grade(widget.trainingData, widget.questionIndex, false);
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
            widget._question.blankfiedEx,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),

          // answer field
          Visibility(
            visible: widget._question.state == QuestionState.intertermined,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                // enabled: widget._question.state == QuestionState.intertermined,
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
              hideOnEmpty: true,
              hideOnError: true,
              keepSuggestionsOnLoading: false,
            ),
          ),
          const SizedBox(height: 24),

          // wrong
          Visibility(
            visible: widget._question.state == QuestionState.wrong,
            child: Card(
              child: ListTile(
                leading: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  widget._question.usersAnswer ?? '',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // correct answer
          Visibility(
            visible: widget._question.state != QuestionState.intertermined,
            child: Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                title: Text(
                  widget._question.word.name,
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
                _viewDef ? widget._question.word.def : t.viewDefinition,
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
            visible: widget._question.word.mnemonic != null &&
                widget._question.word.mnemonic != '',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb_outline),
                title: Text(
                  _viewMnemonic
                      ? widget._question.word.mnemonic ?? ''
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
            visible: widget._question.state == QuestionState.intertermined,
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
