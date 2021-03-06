import 'package:annoyer/database/question_ask_definition.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/log.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';

class AskDefinitionWidget extends StatefulWidget {
  final int testInstKey;
  final QuestionAskDefinition question;

  const AskDefinitionWidget({
    Key? key,
    required this.testInstKey,
    required this.question,
  }) : super(key: key);

  @override
  State<AskDefinitionWidget> createState() => _AskDefinitionWidgetState();
}

class _AskDefinitionWidgetState extends State<AskDefinitionWidget>
    with AutomaticKeepAliveClientMixin {
  bool _viewMnemonic = false;
  bool _viewExample = false;

  void _grade(int? usersChoice) async {
    // grade
    if (usersChoice != null &&
        widget.question.choices[usersChoice].name ==
            widget.question.word.name) {
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
    TestInstance? inst = await TestInstance.get(widget.testInstKey);
    if (inst != null) {
      widget.question.usersChoice = usersChoice;
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

    // Set color for the target word depending on the correctness state
    Color? wordColor;
    if (widget.question.state == QuestionState.correct) {
      wordColor = Colors.green;
    } else if (widget.question.state == QuestionState.wrong) {
      wordColor = Colors.red;
    }

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
            widget.question.word.name,
            style: TextStyle(fontSize: 30, color: wordColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // choices
          Table(
            children: widget.question.choices.asMap().entries.map((e) {
              int index = e.key;
              Word word = e.value;

              QuestionState state = widget.question.state;
              int? usersChoice = widget.question.usersChoice;
              Word? usersChoiceWord = usersChoice != null
                  ? widget.question.choices[usersChoice]
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
                } else if (word.def == widget.question.word.def) {
                  // correct answer
                  leading =
                      const Icon(Icons.check_outlined, color: Colors.green);
                }
              }

              // enable?
              bool enabled = true;
              if (widget.question.state != QuestionState.intertermined) {
                // Disable candidates which is not the user's choice
                // nor correct answer after grading
                if ((usersChoiceWord == null ||
                        usersChoiceWord.def != word.def) &&
                    widget.question.word.def != word.def) {
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
                _viewExample ? widget.question.word.ex : t.viewExample,
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
