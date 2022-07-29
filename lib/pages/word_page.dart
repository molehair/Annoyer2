// Adding and updating a word

import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/log.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class WordPage extends StatelessWidget {
  final bool createMode; // true for adding, while false for updating a word
  Word? word;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _defController = TextEditingController();
  final TextEditingController _exController = TextEditingController();
  final TextEditingController _mnemonicController = TextEditingController();

  WordPage({
    Key? key,
    required this.createMode,
    this.word,
  }) : super(key: key);

  /// true if successfully inserted or updated
  Future<bool> set(BuildContext context) async {
    bool retval = false;

    // Is the form valid?
    if (_formKey.currentState!.validate()) {
      //-- valid --//
      try {
        if (word == null) {
          // create a word instance
          word = Word(
            name: _nameController.text,
            def: _defController.text,
            ex: _exController.text,
            mnemonic: _mnemonicController.text,
            level: 1,
          );

          // add to the db
          await Word.add(word!);
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
              TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.title_outlined,
                    size: 32,
                  ),
                  labelText: t.wordOrIdiom + '*',
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                validator: _nonEmptyValidator,
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
                  labelText: t.definition + '*',
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                validator: _nonEmptyValidator,
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
                  labelText: t.example + '*',
                  // border: const OutlineInputBorder(borderSide: BorderSide()),
                ),
                validator: _nonEmptyValidator,
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
                  labelText: t.mnemonic,
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
