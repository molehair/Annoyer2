// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetTrainingDataCollection on Isar {
  IsarCollection<TrainingData> get trainingDatas {
    return getCollection('TrainingData');
  }
}

final TrainingDataSchema = CollectionSchema(
  name: 'TrainingData',
  schema:
      '{"name":"TrainingData","idName":"id","properties":[{"name":"expiration","type":"Long"},{"name":"wordIds","type":"LongList"}],"indexes":[],"links":[]}',
  nativeAdapter: const _TrainingDataNativeAdapter(),
  webAdapter: const _TrainingDataWebAdapter(),
  idName: 'id',
  propertyIds: {'expiration': 0, 'wordIds': 1},
  listProperties: {'wordIds'},
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

class _TrainingDataWebAdapter extends IsarWebTypeAdapter<TrainingData> {
  const _TrainingDataWebAdapter();

  @override
  Object serialize(
      IsarCollection<TrainingData> collection, TrainingData object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(
        jsObj, 'expiration', object.expiration.toUtc().millisecondsSinceEpoch);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'wordIds', object.wordIds);
    return jsObj;
  }

  @override
  TrainingData deserialize(
      IsarCollection<TrainingData> collection, dynamic jsObj) {
    final object = TrainingData(
      expiration: IsarNative.jsObjectGet(jsObj, 'expiration') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'expiration'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0),
      id: IsarNative.jsObjectGet(jsObj, 'id'),
      wordIds: (IsarNative.jsObjectGet(jsObj, 'wordIds') as List?)
              ?.map((e) => e ?? double.negativeInfinity)
              .toList()
              .cast<int>() ??
          [],
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'expiration':
        return (IsarNative.jsObjectGet(jsObj, 'expiration') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    IsarNative.jsObjectGet(jsObj, 'expiration'),
                    isUtc: true)
                .toLocal()
            : DateTime.fromMillisecondsSinceEpoch(0)) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'wordIds':
        return ((IsarNative.jsObjectGet(jsObj, 'wordIds') as List?)
                ?.map((e) => e ?? double.negativeInfinity)
                .toList()
                .cast<int>() ??
            []) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, TrainingData object) {}
}

class _TrainingDataNativeAdapter extends IsarNativeTypeAdapter<TrainingData> {
  const _TrainingDataNativeAdapter();

  @override
  void serialize(
      IsarCollection<TrainingData> collection,
      IsarRawObject rawObj,
      TrainingData object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.expiration;
    final _expiration = value0;
    final value1 = object.wordIds;
    dynamicSize += (value1.length) * 8;
    final _wordIds = value1;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeDateTime(offsets[0], _expiration);
    writer.writeLongList(offsets[1], _wordIds);
  }

  @override
  TrainingData deserialize(IsarCollection<TrainingData> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = TrainingData(
      expiration: reader.readDateTime(offsets[0]),
      id: id,
      wordIds: reader.readLongList(offsets[1]) ?? [],
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
        return (reader.readDateTime(offset)) as P;
      case 1:
        return (reader.readLongList(offset) ?? []) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, TrainingData object) {}
}

extension TrainingDataQueryWhereSort
    on QueryBuilder<TrainingData, TrainingData, QWhere> {
  QueryBuilder<TrainingData, TrainingData, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension TrainingDataQueryWhere
    on QueryBuilder<TrainingData, TrainingData, QWhereClause> {
  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterWhereClause> idBetween(
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

extension TrainingDataQueryFilter
    on QueryBuilder<TrainingData, TrainingData, QFilterCondition> {
  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      expirationEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'expiration',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      expirationGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'expiration',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      expirationLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'expiration',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      expirationBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'expiration',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      wordIdsAnyEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'wordIds',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      wordIdsAnyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'wordIds',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      wordIdsAnyLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'wordIds',
      value: value,
    ));
  }

  QueryBuilder<TrainingData, TrainingData, QAfterFilterCondition>
      wordIdsAnyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'wordIds',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension TrainingDataQueryLinks
    on QueryBuilder<TrainingData, TrainingData, QFilterCondition> {}

extension TrainingDataQueryWhereSortBy
    on QueryBuilder<TrainingData, TrainingData, QSortBy> {
  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByExpiration() {
    return addSortByInternal('expiration', Sort.asc);
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy>
      sortByExpirationDesc() {
    return addSortByInternal('expiration', Sort.desc);
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }
}

extension TrainingDataQueryWhereSortThenBy
    on QueryBuilder<TrainingData, TrainingData, QSortThenBy> {
  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByExpiration() {
    return addSortByInternal('expiration', Sort.asc);
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy>
      thenByExpirationDesc() {
    return addSortByInternal('expiration', Sort.desc);
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TrainingData, TrainingData, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }
}

extension TrainingDataQueryWhereDistinct
    on QueryBuilder<TrainingData, TrainingData, QDistinct> {
  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctByExpiration() {
    return addDistinctByInternal('expiration');
  }

  QueryBuilder<TrainingData, TrainingData, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }
}

extension TrainingDataQueryProperty
    on QueryBuilder<TrainingData, TrainingData, QQueryProperty> {
  QueryBuilder<TrainingData, DateTime, QQueryOperations> expirationProperty() {
    return addPropertyNameInternal('expiration');
  }

  QueryBuilder<TrainingData, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<TrainingData, List<int>, QQueryOperations> wordIdsProperty() {
    return addPropertyNameInternal('wordIds');
  }
}
