// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_instance.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetPracticeInstanceCollection on Isar {
  IsarCollection<PracticeInstance> get practiceInstances {
    return getCollection('PracticeInstance');
  }
}

final PracticeInstanceSchema = CollectionSchema(
  name: 'PracticeInstance',
  schema:
      '{"name":"PracticeInstance","idName":"id","properties":[{"name":"dailyIndex","type":"Long"},{"name":"trainingId","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _PracticeInstanceNativeAdapter(),
  webAdapter: const _PracticeInstanceWebAdapter(),
  idName: 'id',
  propertyIds: {'dailyIndex': 0, 'trainingId': 1},
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

class _PracticeInstanceWebAdapter extends IsarWebTypeAdapter<PracticeInstance> {
  const _PracticeInstanceWebAdapter();

  @override
  Object serialize(
      IsarCollection<PracticeInstance> collection, PracticeInstance object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'dailyIndex', object.dailyIndex);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'trainingId', object.trainingId);
    return jsObj;
  }

  @override
  PracticeInstance deserialize(
      IsarCollection<PracticeInstance> collection, dynamic jsObj) {
    final object = PracticeInstance(
      dailyIndex: IsarNative.jsObjectGet(jsObj, 'dailyIndex') ??
          double.negativeInfinity,
      id: IsarNative.jsObjectGet(jsObj, 'id'),
      trainingId: IsarNative.jsObjectGet(jsObj, 'trainingId') ??
          double.negativeInfinity,
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'dailyIndex':
        return (IsarNative.jsObjectGet(jsObj, 'dailyIndex') ??
            double.negativeInfinity) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'trainingId':
        return (IsarNative.jsObjectGet(jsObj, 'trainingId') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, PracticeInstance object) {}
}

class _PracticeInstanceNativeAdapter
    extends IsarNativeTypeAdapter<PracticeInstance> {
  const _PracticeInstanceNativeAdapter();

  @override
  void serialize(
      IsarCollection<PracticeInstance> collection,
      IsarRawObject rawObj,
      PracticeInstance object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.dailyIndex;
    final _dailyIndex = value0;
    final value1 = object.trainingId;
    final _trainingId = value1;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeLong(offsets[0], _dailyIndex);
    writer.writeLong(offsets[1], _trainingId);
  }

  @override
  PracticeInstance deserialize(IsarCollection<PracticeInstance> collection,
      int id, IsarBinaryReader reader, List<int> offsets) {
    final object = PracticeInstance(
      dailyIndex: reader.readLong(offsets[0]),
      id: id,
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
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, PracticeInstance object) {}
}

extension PracticeInstanceQueryWhereSort
    on QueryBuilder<PracticeInstance, PracticeInstance, QWhere> {
  QueryBuilder<PracticeInstance, PracticeInstance, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension PracticeInstanceQueryWhere
    on QueryBuilder<PracticeInstance, PracticeInstance, QWhereClause> {
  QueryBuilder<PracticeInstance, PracticeInstance, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterWhereClause>
      idNotEqualTo(int? id) {
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

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterWhereClause>
      idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterWhereClause>
      idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterWhereClause> idBetween(
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

extension PracticeInstanceQueryFilter
    on QueryBuilder<PracticeInstance, PracticeInstance, QFilterCondition> {
  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      dailyIndexEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'dailyIndex',
      value: value,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      dailyIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'dailyIndex',
      value: value,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      dailyIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'dailyIndex',
      value: value,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      dailyIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dailyIndex',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
      trainingIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'trainingId',
      value: value,
    ));
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
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

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
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

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterFilterCondition>
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

extension PracticeInstanceQueryLinks
    on QueryBuilder<PracticeInstance, PracticeInstance, QFilterCondition> {}

extension PracticeInstanceQueryWhereSortBy
    on QueryBuilder<PracticeInstance, PracticeInstance, QSortBy> {
  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      sortByDailyIndex() {
    return addSortByInternal('dailyIndex', Sort.asc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      sortByDailyIndexDesc() {
    return addSortByInternal('dailyIndex', Sort.desc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      sortByTrainingId() {
    return addSortByInternal('trainingId', Sort.asc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      sortByTrainingIdDesc() {
    return addSortByInternal('trainingId', Sort.desc);
  }
}

extension PracticeInstanceQueryWhereSortThenBy
    on QueryBuilder<PracticeInstance, PracticeInstance, QSortThenBy> {
  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      thenByDailyIndex() {
    return addSortByInternal('dailyIndex', Sort.asc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      thenByDailyIndexDesc() {
    return addSortByInternal('dailyIndex', Sort.desc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      thenByTrainingId() {
    return addSortByInternal('trainingId', Sort.asc);
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QAfterSortBy>
      thenByTrainingIdDesc() {
    return addSortByInternal('trainingId', Sort.desc);
  }
}

extension PracticeInstanceQueryWhereDistinct
    on QueryBuilder<PracticeInstance, PracticeInstance, QDistinct> {
  QueryBuilder<PracticeInstance, PracticeInstance, QDistinct>
      distinctByDailyIndex() {
    return addDistinctByInternal('dailyIndex');
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<PracticeInstance, PracticeInstance, QDistinct>
      distinctByTrainingId() {
    return addDistinctByInternal('trainingId');
  }
}

extension PracticeInstanceQueryProperty
    on QueryBuilder<PracticeInstance, PracticeInstance, QQueryProperty> {
  QueryBuilder<PracticeInstance, int, QQueryOperations> dailyIndexProperty() {
    return addPropertyNameInternal('dailyIndex');
  }

  QueryBuilder<PracticeInstance, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<PracticeInstance, int, QQueryOperations> trainingIdProperty() {
    return addPropertyNameInternal('trainingId');
  }
}
