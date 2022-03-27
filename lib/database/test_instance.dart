/// isar code gen: flutter pub run build_runner build

import 'dart:convert';

import 'package:annoyer/database/question.dart';
import 'package:isar/isar.dart';

import 'database.dart';
import 'question_ask_definition.dart';
import 'question_ask_word.dart';

part 'test_instance.g.dart';

/// A struct of test instances in training

@Collection()
class TestInstance {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//

  @Id()
  int? id;

  int trainingId;

  @_QuestionsConverter()
  List<Question> questions;

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  TestInstance({
    this.id,
    required this.trainingId,
    required this.questions,
  });

  TestInstance.fromMap(Map<String, Object?> map)
      : id = map['id'] as int?,
        trainingId = map['trainingId'] as int,
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
        });

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      'trainingId': trainingId,
      'questions': questions.map((e) => e.toMap()).toList(),
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  TestInstance.fromJson(String jsonString)
      : this.fromMap(jsonDecode(jsonString));

  String toJson() {
    return jsonEncode(toMap());
  }

  /// Get an item
  static Future<TestInstance?> get(int id) {
    return Database.isar.testInstances.get(id);
  }

  /// Get all items
  static Future<List<TestInstance>> getAll() {
    return Database.isar.testInstances.where().findAll();
  }

  /// Add an item
  static Future<void> add(TestInstance inst) async {
    inst.id = null;
    return Database.isar.writeTxn((isar) async {
      await Database.isar.testInstances.put(inst);
    });
  }

  /// Save an item with [inst.id]
  static Future<void> put(TestInstance inst) async {
    assert(inst.id != null);

    return Database.isar.writeTxn((isar) async {
      await Database.isar.testInstances.put(inst);
    });
  }

  /// Delete an item
  static Future<void> delete(int id) {
    return Database.isar.writeTxn((isar) async {
      await Database.isar.testInstances.delete(id);
    });
  }

  /// Delete items with [ids]
  static Future<void> deletes(List<int> ids) {
    return Database.isar.writeTxn((isar) async {
      await Database.isar.testInstances.deleteAll(ids);
    });
  }

  /// Delete all items
  static Future<void> deleteAll() async {
    await Database.isar.writeTxn((isar) async {
      await isar.testInstances.where().deleteAll();
    });
  }

  /// RETURN: the number of all items
  static Future<int> count() {
    return Database.isar.testInstances.where().count();
  }

  /// Get stream
  static Stream<void> getStream() {
    return Database.isar.testInstances.watchLazy();
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
