// Adding and updating a word

import 'package:annoyer/database/predefined_word.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

final _formKey = GlobalKey<FormState>();

/// If a word instance is not given, it will ADD to db.
/// If a word instance is given, it will OVERWRITE/DELETE to db.
class WordPage extends StatelessWidget {
  final Word? word;

  // true for adding, while false for updating/deleting a word
  late final bool createMode;

  WordPage({
    Key? key,
    this.word,
  })  : createMode = word == null,
        super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _defController = TextEditingController();
  final TextEditingController _exController = TextEditingController();
  final TextEditingController _mnemonicController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _defFocusNode = FocusNode();
  final FocusNode _exFocusNode = FocusNode();
  final FocusNode _mnemonicFocusNode = FocusNode();

  PredefinedWord? _suggestion;

  /// true if successfully inserted or updated
  Future<bool> set(BuildContext context) async {
    bool retval = false;

    // Is the form valid?
    if (_formKey.currentState!.validate()) {
      //-- valid --//
      try {
        if (createMode) {
          // create a new instance
          var word = Word(
            name: _nameController.text,
            def: _defController.text,
            ex: _exController.text,
            mnemonic: _mnemonicController.text,
            level: 1,
          );

          // add to the db
          await Word.add(word);
        } else {
          // reset level only if the word or definition has been changed
          if (word!.name != _nameController.text ||
              word!.def != _defController.text) {
            word!.level = 1;
          }

          // modify the word
          word!.name = _nameController.text;
          word!.def = _defController.text;
          word!.ex = _exController.text;
          word!.mnemonic = _mnemonicController.text;

          // update
          await Word.put(word!);
        }

        //-- success --//
        // close the current page
        Navigator.of(context).pop();

        // show success
        Global.showSuccess();

        retval = true;
      } on Exception catch (e) {
        Log.error('set in WordPage', exception: e);
      }
    }
    return retval;
  }

  void delete(BuildContext context) async {
    try {
      await Word.delete(word!.id!);

      //-- success --//
      // close the current page
      Navigator.of(context).pop();

      // show success
      Global.showSuccess();
    } on Exception catch (e) {
      Log.error('delete in WordPage', exception: e);
    }
  }

  /// RETURN null if `value` is not empty,
  ///        'required field' message otherwise.
  String? _nonEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return t.requiredField;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _title = createMode ? t.newWord : t.updateWord;
    _nameController.text = createMode ? '' : word!.name;
    _defController.text = createMode ? '' : word!.def;
    _exController.text = createMode ? '' : word!.ex;
    _mnemonicController.text = createMode ? '' : (word!.mnemonic ?? '');

    // FloatingActionButtons
    List<Widget> buttons = [
      FloatingActionButton(
        onPressed: () => set(context),
        child: const Icon(Icons.check),
        heroTag: null,
      ),
    ];
    if (!createMode) {
      // add `delete` button
      buttons.insert(
        0,
        FloatingActionButton(
          onPressed: () => delete(context),
          child: const Icon(Icons.delete),
          heroTag: null,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // word name
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.title_outlined, size: 32),
                    labelText: t.wordOrIdiom + '*',
                    suffix: GestureDetector(
                      onTap: () {
                        _nameController.clear();
                        _suggestion = null;
                      },
                      child: Icon(
                        Icons.backspace_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  controller: _nameController,
                  autofocus: word == null,
                  focusNode: _nameFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) =>
                      _suggestion = null, // user gave up suggestion
                ),
                validator: _nonEmptyValidator,
                suggestionsCallback: (pattern) async {
                  // search definitions from the index
                  var suggestionIds =
                      PredefinedWord.nameIndex.search(pattern.trim());

                  List<PredefinedWord> prefixMatch = [];
                  List<PredefinedWord> included = [];
                  var allPredefinedWords = await PredefinedWord.getAll();
                  for (var word in allPredefinedWords) {
                    if (suggestionIds.contains(word.id)) {
                      if (word.name.startsWith(pattern)) {
                        prefixMatch.add(word);
                      } else {
                        included.add(word);
                      }
                    }
                  }

                  // words that start with [pattern] appear first
                  return prefixMatch + included;
                },
                itemBuilder: (context, PredefinedWord suggestion) {
                  return ListTile(title: Text(suggestion.name));
                },
                onSuggestionSelected: (PredefinedWord selection) {
                  _suggestion = selection;
                  _nameController.text = selection.name;
                  _defFocusNode.requestFocus();
                },
                loadingBuilder: (context) => const ListTile(
                  title: Center(child: CircularProgressIndicator()),
                ),
                hideOnEmpty: true,
                hideOnError: true,
                keepSuggestionsOnLoading: false,
              ),
              const SizedBox(height: 24),

              // def
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.short_text_outlined, size: 32),
                    labelText: t.definition + '*',
                    suffix: GestureDetector(
                      onTap: () => _defController.clear(),
                      child: Icon(
                        Icons.backspace_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  controller: _defController,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  focusNode: _defFocusNode,
                ),
                validator: _nonEmptyValidator,
                suggestionsCallback: (pattern) {
                  if (pattern == '' && _suggestion != null) {
                    return <String>[_suggestion!.def];
                  } else {
                    return <String>[];
                  }
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                onSuggestionSelected: (String selection) {
                  _defController.text = selection;
                  _exFocusNode.requestFocus();
                },
                loadingBuilder: (context) => const ListTile(
                  title: Center(child: CircularProgressIndicator()),
                ),
                hideOnEmpty: true,
                hideOnError: true,
                keepSuggestionsOnLoading: false,
              ),
              const SizedBox(height: 24),

              // ex
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.notes_outlined,
                      size: 32,
                    ),
                    labelText: t.example + '*',
                    suffix: GestureDetector(
                      onTap: () => _exController.clear(),
                      child: Icon(
                        Icons.backspace_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  controller: _exController,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  focusNode: _exFocusNode,
                ),
                validator: _nonEmptyValidator,
                suggestionsCallback: (pattern) {
                  if (pattern == '' && _suggestion != null) {
                    return _suggestion!.examples;
                  } else {
                    return <String>[];
                  }
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(title: Text(' ' + suggestion));
                },
                onSuggestionSelected: (String selection) {
                  _exController.text = selection;
                  _mnemonicFocusNode.requestFocus();
                },
                loadingBuilder: (context) => const ListTile(
                  title: Center(child: CircularProgressIndicator()),
                ),
                hideOnEmpty: true,
                hideOnError: true,
                keepSuggestionsOnLoading: false,
              ),
              const SizedBox(height: 24),

              // mnemonic
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    size: 32,
                  ),
                  suffix: GestureDetector(
                    onTap: () => _mnemonicController.clear(),
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: t.mnemonic,
                ),
                controller: _mnemonicController,
                maxLines: null,
                textInputAction: TextInputAction.none,
                focusNode: _mnemonicFocusNode,
              ),
              const SizedBox(height: 24),

              // buttons
              Row(
                children: buttons,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
