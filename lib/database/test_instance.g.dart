// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_instance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetTestInstanceCollection on Isar {
  IsarCollection<TestInstance> get testInstances {
    return getCollection('TestInstance');
  }
}

final TestInstanceSchema = CollectionSchema(
  name: 'TestInstance',
  schema:
      '{"name":"TestInstance","idName":"id","properties":[{"name":"questions","type":"String"},{"name":"trainingId","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _TestInstanceNativeAdapter(),
  webAdapter: const _TestInstanceWebAdapter(),
  idName: 'id',
  propertyIds: {'questions': 0, 'trainingId': 1},
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

const _testInstance_QuestionsConverter = _QuestionsConverter();

class _TestInstanceWebAdapter extends IsarWebTypeAdapter<TestInstance> {
  const _TestInstanceWebAdapter();

  @override
  Object serialize(
      IsarCollection<TestInstance> collection, TestInstance object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'questions',
        _testInstance_QuestionsConverter.toIsar(object.questions));
    IsarNative.jsObjectSet(jsObj, 'trainingId', object.trainingId);
    return jsObj;
  }

  @override
  TestInstance deserialize(
      IsarCollection<TestInstance> collection, dynamic jsObj) {
    final object = TestInstance(
      id: IsarNative.jsObjectGet(jsObj, 'id'),
      questions: _testInstance_QuestionsConverter
          .fromIsar(IsarNative.jsObjectGet(jsObj, 'questions') ?? ''),
      trainingId: IsarNative.jsObjectGet(jsObj, 'trainingId') ??
          double.negativeInfinity,
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'questions':
        return (_testInstance_QuestionsConverter
            .fromIsar(IsarNative.jsObjectGet(jsObj, 'questions') ?? '')) as P;
      case 'trainingId':
        return (IsarNative.jsObjectGet(jsObj, 'trainingId') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, TestInstance object) {}
}

class _TestInstanceNativeAdapter extends IsarNativeTypeAdapter<TestInstance> {
  const _TestInstanceNativeAdapter();

  @override
  void serialize(
      IsarCollection<TestInstance> collection,
      IsarRawObject rawObj,
      TestInstance object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = _testInstance_QuestionsConverter.toIsar(object.questions);
    final _questions = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_questions.length) as int;
    final value1 = object.trainingId;
    final _trainingId = value1;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _questions);
    writer.writeLong(offsets[1], _trainingId);
  }

  @override
  TestInstance deserialize(IsarCollection<TestInstance> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = TestInstance(
      id: id,
      questions: _testInstance_QuestionsConverter
          .fromIsar(reader.readString(offsets[0])),
      trainingId: reader.readLong(offsets[1]),
    );
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (_testInstance_QuestionsConverter
            .fromIsar(reader.readString(offset))) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, TestInstance object) {}
}

extension TestInstanceQueryWhereSort
    on QueryBuilder<TestInstance, TestInstance, QWhere> {
  QueryBuilder<TestInstance, TestInstance, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension TestInstanceQueryWhere
    on QueryBuilder<TestInstance, TestInstance, QWhereClause> {
  QueryBuilder<TestInstance, TestInstance, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterWhereClause> idNotEqualTo(
      int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<TestInstance, TestInstance, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension TestInstanceQueryFilter
    on QueryBuilder<TestInstance, TestInstance, QFilterCondition> {
  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsEqualTo(
    List<Question> value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'questions',
      value: _testInstance_QuestionsConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsGreaterThan(
    List<Question> value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'questions',
      value: _testInstance_QuestionsConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsLessThan(
    List<Question> value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'questions',
      value: _testInstance_QuestionsConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsBetween(
    List<Question> lower,
    List<Question> upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'questions',
      lower: _testInstance_QuestionsConverter.toIsar(lower),
      includeLower: includeLower,
      upper: _testInstance_QuestionsConverter.toIsar(upper),
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsStartsWith(
    List<Question> value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'questions',
      value: _testInstance_QuestionsConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsEndsWith(
    List<Question> value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'questions',
      value: _testInstance_QuestionsConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsContains(List<Question> value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'questions',
      value: _testInstance_QuestionsConverter.toIsar(value),
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      questionsMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'questions',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      trainingIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'trainingId',
      value: value,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      trainingIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'trainingId',
      value: value,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      trainingIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'trainingId',
      value: value,
    ));
  }

  QueryBuilder<TestInstance, TestInstance, QAfterFilterCondition>
      trainingIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'trainingId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension TestInstanceQueryLinks
    on QueryBuilder<TestInstance, TestInstance, QFilterCondition> {}

extension TestInstanceQueryWhereSortBy
    on QueryBuilder<TestInstance, TestInstance, QSortBy> {
  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> sortByQuestions() {
    return addSortByInternal('questions', Sort.asc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> sortByQuestionsDesc() {
    return addSortByInternal('questions', Sort.desc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> sortByTrainingId() {
    return addSortByInternal('trainingId', Sort.asc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy>
      sortByTrainingIdDesc() {
    return addSortByInternal('trainingId', Sort.desc);
  }
}

extension TestInstanceQueryWhereSortThenBy
    on QueryBuilder<TestInstance, TestInstance, QSortThenBy> {
  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> thenByQuestions() {
    return addSortByInternal('questions', Sort.asc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> thenByQuestionsDesc() {
    return addSortByInternal('questions', Sort.desc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy> thenByTrainingId() {
    return addSortByInternal('trainingId', Sort.asc);
  }

  QueryBuilder<TestInstance, TestInstance, QAfterSortBy>
      thenByTrainingIdDesc() {
    return addSortByInternal('trainingId', Sort.desc);
  }
}

extension TestInstanceQueryWhereDistinct
    on QueryBuilder<TestInstance, TestInstance, QDistinct> {
  QueryBuilder<TestInstance, TestInstance, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<TestInstance, TestInstance, QDistinct> distinctByQuestions(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('questions', caseSensitive: caseSensitive);
  }

  QueryBuilder<TestInstance, TestInstance, QDistinct> distinctByTrainingId() {
    return addDistinctByInternal('trainingId');
  }
}

extension TestInstanceQueryProperty
    on QueryBuilder<TestInstance, TestInstance, QQueryProperty> {
  QueryBuilder<TestInstance, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<TestInstance, List<Question>, QQueryOperations>
      questionsProperty() {
    return addPropertyNameInternal('questions');
  }

  QueryBuilder<TestInstance, int, QQueryOperations> trainingIdProperty() {
    return addPropertyNameInternal('trainingId');
  }
}
