// A struct for containing training data

/// isar code gen: flutter pub run build_runner build

import 'dart:convert';

import 'package:isar/isar.dart';

import 'database.dart';
import 'question.dart';
import 'question_ask_definition.dart';
import 'question_ask_word.dart';

part 'training_data.g.dart';

@Collection()
class TrainingData {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  @Id()
  int? id;

  /// list of words to use
  List<int> wordIds;

  /// only valid before this datetime
  DateTime expiration;

  /// list of questions for the test
  @_QuestionsConverter()
  List<Question> questions;

  /// the previously issued training index
  int lastTrainingIndex = -1;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  TrainingData({
    this.id,
    required this.wordIds,
    required this.expiration,
    required this.questions,
  });

  TrainingData.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        wordIds = List.castFrom(map['wordIds'] as List),
        expiration = map['expiration'] as DateTime,
        questions =
            List<Question>.generate((map['questions'] as List).length, (i) {
          var qMap = (map['questions'] as List)[i];
          Question q = Question.fromMap(qMap);
          switch (q.type) {
            case QuestionType.askDefinition:
              q = QuestionAskDefinition.fromMap(qMap);
              break;
            case QuestionType.askWord:
              q = QuestionAskWord.fromMap(qMap);
              break;
            default:
              throw 'Unknown question type during _load()';
          }
          return q;
        }),
        lastTrainingIndex = map['lastTrainingIndex'] as int;

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'wordIds': wordIds,
      'expiration': expiration,
      'questions': questions.map((e) => e.toMap()).toList(),
      'lastTrainingIndex': lastTrainingIndex,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  TrainingData.fromJson(String jsonString)
      : this.fromMap(jsonDecode(
          jsonString,
          reviver: (key, value) => key == 'expiration'
              ? DateTime.fromMicrosecondsSinceEpoch(value as int)
              : value,
        ));

  String toJson() {
    return jsonEncode(
      toMap(),
      toEncodable: (item) =>
          item is DateTime ? item.microsecondsSinceEpoch : item,
    );
  }

  /// Get an item
  static Future<TrainingData?> get(int id) {
    return Database.isar.trainingDatas.get(id);
  }

  /// Get all items
  static Future<List<TrainingData>> getAll() {
    return Database.isar.trainingDatas.where().findAll();
  }

  /// Add an item
  static Future<void> add(TrainingData trainingData) {
    trainingData.id = null;
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.put(trainingData);
    });
  }

  /// Save an item with id
  static Future<void> put(TrainingData trainingData) {
    assert(trainingData.id != null);
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.put(trainingData);
    });
  }

  /// Delete an item
  static Future<void> delete(int id) async {
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.delete(id);
    });
  }

  /// Delete all items with [ids]
  static Future<void> deleteAll(List<int> ids) async {
    return Database.isar.writeTxn((isar) async {
      await Database.isar.trainingDatas.deleteAll(ids);
    });
  }

  /// Get stream
  static Stream<void> getStream() {
    return Database.isar.trainingDatas.watchLazy();
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//
}

class _QuestionsConverter extends TypeConverter<List<Question>, String> {
  // Converters need to have an empty const constructor
  const _QuestionsConverter();

  @override
  List<Question> fromIsar(String jsonString) {
    List rawList = List.castFrom(jsonDecode(jsonString));

    // questions before figuring out question types
    List<Question> questionsUnknown =
        rawList.map((e) => Question.fromMap(e)).toList();

    // create questions
    List<Question> questions = [];
    for (var i = 0; i < rawList.length; i++) {
      var type = questionsUnknown[i].type;
      if (type == QuestionType.askDefinition) {
        questions.add(QuestionAskDefinition.fromMap(rawList[i]));
      }
      if (type == QuestionType.askWord) {
        questions.add(QuestionAskWord.fromMap(rawList[i]));
      }
    }

    return questions;
  }

  @override
  String toIsar(List<Question> questions) {
    return jsonEncode(questions.map((e) => e.toMap()).toList());
  }
}
