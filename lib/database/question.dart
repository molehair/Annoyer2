import 'dart:convert';

import 'word.dart';

enum QuestionType { askDefinition, askWord }

// whether the answer was correct, wrong or indetermined
enum QuestionState { intertermined, correct, wrong }

class Question {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  final int index; // the index among all questions in a test
  final QuestionType type;
  final Word word;
  QuestionState state;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  Question(this.index, this.word, this.type)
      : state = QuestionState.intertermined;

  Question.fromMap(Map<String, Object?> map)
      : index = map['index'] as int,
        type = QuestionType.values[map['type'] as int],
        word = Word.fromMap(map['word'] as Map<String, Object?>),
        state = QuestionState.values[map['state'] as int];

  Map<String, Object?> toMap() {
    return {
      'index': index,
      'type': type.index,
      'word': word.toMap(),
      'state': state.index,
    };
  }

  Question.fromJson(String jsonString) : this.fromMap(jsonDecode(jsonString));
  String toJson() {
    return jsonEncode(toMap());
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
