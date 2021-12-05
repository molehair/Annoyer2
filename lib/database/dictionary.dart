// A box for containing all words

import 'package:hive_flutter/hive_flutter.dart';

import 'index.dart';
import 'word.dart';

class Dictionary {
  static const String boxName = 'dictionary';

  // indexes
  // use `key`(type: int) in a box as value of index
  static final Index<int> nameIndex = Index<int>(fullTextMode: true);
  static final Index<int> defIndex = Index<int>();

  static Future<void> initialization() async {
    Box<Word> box = await Hive.openBox<Word>(Dictionary.boxName);

    // build indexes
    for (int key in box.keys) {
      Dictionary.nameIndex.add(box.get(key)!.name, key);
      Dictionary.defIndex.add(box.get(key)!.def, key);
    }

    // enroll callbacks
    _onDictionaryChange(box.watch());
  }

  // callback when there's a change on dictionary
  static _onDictionaryChange(Stream<BoxEvent> stream) async {
    await for (final BoxEvent event in stream) {
      // manage indexes
      if (event.deleted) {
        Dictionary.nameIndex.removeByValue(event.key);
        Dictionary.defIndex.removeByValue(event.key);
      } else {
        Dictionary.nameIndex.removeByValue(event.key);
        Dictionary.defIndex.removeByValue(event.key);
        Dictionary.nameIndex.add(event.value.name, event.key);
        Dictionary.defIndex.add(event.value.def, event.key);
      }
    }
  }
}
