import 'package:annoyer/database/question_ask_definition.dart';
import 'package:annoyer/database/training_data.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';

class AskDefinitionWidget extends StatefulWidget {
  final TrainingData trainingData;
  final int questionIndex;
  final QuestionAskDefinition _question;

  AskDefinitionWidget({
    Key? key,
    required this.trainingData,
    required this.questionIndex,
  })  : _question =
            trainingData.questions[questionIndex] as QuestionAskDefinition,
        super(key: key);

  @override
  State<AskDefinitionWidget> createState() => _AskDefinitionWidgetState();
}

class _AskDefinitionWidgetState extends State<AskDefinitionWidget>
    with AutomaticKeepAliveClientMixin {
  bool _viewMnemonic = false;
  bool _viewExample = false;

  void _grade(int? usersChoice) async {
    widget._question.usersChoice = usersChoice;

    // grade
    if (usersChoice != null &&
        widget._question.choices[usersChoice].name ==
            widget._question.word.name) {
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
            t.askDefinition,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // word
          Text(
            widget._question.word.name,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // choices
          Table(
            children: widget._question.choices.asMap().entries.map((e) {
              int index = e.key;
              Word word = e.value;

              QuestionState state = widget._question.state;
              int? usersChoice = widget._question.usersChoice;
              Word? usersChoiceWord = usersChoice != null
                  ? widget._question.choices[usersChoice]
                  : null;

              // leading
              Icon leading = const Icon(Icons.radio_button_unchecked_outlined);
              if (state != QuestionState.intertermined) {
                //-- after grading --//
                if (state == QuestionState.wrong &&
                    usersChoiceWord != null &&
                    usersChoiceWord.def == word.def) {
                  // wrong choice
                  leading = const Icon(Icons.close_outlined, color: Colors.red);
                } else if (word.def == widget._question.word.def) {
                  // correct answer
                  leading =
                      const Icon(Icons.check_outlined, color: Colors.green);
                }
              }

              // enable?
              bool enabled = true;
              if (widget._question.state != QuestionState.intertermined) {
                // Disable candidates which is not the user's choice
                // nor correct answer after grading
                if ((usersChoiceWord == null ||
                        usersChoiceWord.def != word.def) &&
                    widget._question.word.def != word.def) {
                  enabled = false;
                }
              }

              return TableRow(children: [
                Card(
                  child: ListTile(
                    leading: leading,
                    title: Text(word.def),
                    onTap: () => _grade(index),
                    enabled: enabled,
                  ),
                ),
              ]);
            }).toList(),
          ),
          const SizedBox(height: 24),

          // example
          Card(
            child: ListTile(
              leading: const Icon(Icons.notes_outlined),
              title: Text(
                _viewExample ? widget._question.word.ex : t.viewExample,
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

          // correct icon
          Visibility(
            visible: widget._question.state == QuestionState.correct,
            child: const Icon(
              Icons.emoji_emotions_outlined,
              size: 64,
              color: Colors.green,
            ),
          ),

          // incorrect icon
          Visibility(
            visible: widget._question.state == QuestionState.wrong,
            child: const Icon(
              Icons.sentiment_dissatisfied_outlined,
              size: 64,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
