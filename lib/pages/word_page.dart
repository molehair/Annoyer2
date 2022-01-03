// Adding and updating a word

import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _formKey = GlobalKey<FormState>();

class WordPage extends StatelessWidget {
  final bool createMode; // true for adding, while false for updating a word
  final int? storeKey;
  Word? word;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _defController = TextEditingController();
  final TextEditingController _exController = TextEditingController();
  final TextEditingController _mnemonicController = TextEditingController();

  WordPage({
    Key? key,
    required this.createMode,
    this.storeKey,
    this.word,
  }) : super(key: key);

  /// true if successfully inserted or updated
  Future<bool> set(BuildContext context) async {
    bool retval = false;

    // Is the form valid?
    if (_formKey.currentState!.validate()) {
      //-- valid --//
      try {
        Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);

        if (word == null) {
          // create a word instance
          word = Word(
            name: _nameController.text,
            def: _defController.text,
            ex: _exController.text,
            mnemonic: _mnemonicController.text,
            level: 1,
          );

          // insert
          await box.add(word!);
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
          await box.put(word!.key, word!);
        }

        //-- success --//
        // close the current page
        Navigator.of(context).pop();

        // show success
        Global.showSuccess();

        retval = true;
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }
    return retval;
  }

  void delete(BuildContext context) async {
    try {
      if (word!.key != null) {
        Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);
        box.delete(word!.key);

        //-- success --//
        // close the current page
        Navigator.of(context).pop();

        // show success
        Global.showSuccess();
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _title = createMode
        ? AppLocalizations.of(context)!.newWord
        : AppLocalizations.of(context)!.updateWord;
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
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.title_outlined,
                    size: 32,
                  ),
                  labelText: AppLocalizations.of(context)!.wordOrIdiom + '*',
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }
                  return null;
                },
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.short_text_outlined,
                    size: 32,
                  ),
                  labelText: AppLocalizations.of(context)!.definition + '*',
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }
                  return null;
                },
                controller: _defController,
                maxLines: null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.notes_outlined,
                    size: 32,
                  ),
                  labelText: AppLocalizations.of(context)!.example + '*',
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }
                  return null;
                },
                controller: _exController,
                maxLines: null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    size: 32,
                  ),
                  labelText: AppLocalizations.of(context)!.mnemonic,
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                controller: _mnemonicController,
                maxLines: null,
                textInputAction: TextInputAction.none,
              ),
              const SizedBox(height: 24),
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
