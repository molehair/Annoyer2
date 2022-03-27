import 'dart:convert';
import 'dart:math';

import 'question.dart';
import 'word.dart';

class QuestionAskDefinition extends Question {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//
  final List<Word> choices;
  int? usersChoice; // the index chosen by user among `choices`

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  /// the number of candidates(choices)
  static const int _numCandidates = 4;

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  QuestionAskDefinition(
    int index,
    Word word,
    QuestionType type,
    this.choices,
  ) : super(index, word, type);

  /// prepare multiple choices
  static Future<List<Word>> createChoices(Word correctAnswer) async {
    final List<Word> choices = [];

    // add the correct answer to the candidate list
    choices.add(correctAnswer);

    // count the total available definitions
    final List<Word> words = await Word.getAll();
    Set<String> pool = Set<String>.from(words.map((e) => e.def));
    int numAvailableDefs = pool.length;

    // fill the rest
    Random rng = Random();
    for (int i = 1; i < min(numAvailableDefs, _numCandidates);) {
      // choose a random word from dictionary
      int r = rng.nextInt(words.length);

      // add to the list only if no duplicate
      if (choices.every((e) => e.def != words[r].def)) {
        choices.add(words[r]);
        i++;
      }
    }

    // shuffle
    choices.shuffle();

    return choices;
  }

  @override
  QuestionAskDefinition.fromMap(Map<String, Object?> map)
      : usersChoice = map['usersChoice'] as int?,
        choices = List.generate(
          (map['choices'] as List).length,
          (i) => Word.fromMap((map['choices'] as List)[i]),
        ),
        super.fromMap(map);

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = super.toMap();
    if (usersChoice != null) {
      map['usersChoice'] = usersChoice;
    }
    map['choices'] = choices.map((e) => e.toMap()).toList();
    return map;
  }

  @override
  QuestionAskDefinition.fromJson(String jsonString)
      : this.fromMap(jsonDecode(jsonString));

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}
