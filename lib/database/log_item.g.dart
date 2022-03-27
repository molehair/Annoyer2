// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetLogItemCollection on Isar {
  IsarCollection<LogItem> get logItems {
    return getCollection('LogItem');
  }
}

final LogItemSchema = CollectionSchema(
  name: 'LogItem',
  schema:
      '{"name":"LogItem","idName":"id","properties":[{"name":"log","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _LogItemNativeAdapter(),
  webAdapter: const _LogItemWebAdapter(),
  idName: 'id',
  propertyIds: {'log': 0},
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

class _LogItemWebAdapter extends IsarWebTypeAdapter<LogItem> {
  const _LogItemWebAdapter();

  @override
  Object serialize(IsarCollection<LogItem> collection, LogItem object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'log', object.log);
    return jsObj;
  }

  @override
  LogItem deserialize(IsarCollection<LogItem> collection, dynamic jsObj) {
    final object = LogItem(
      IsarNative.jsObjectGet(jsObj, 'log') ?? '',
    );
    object.id = IsarNative.jsObjectGet(jsObj, 'id');
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'log':
        return (IsarNative.jsObjectGet(jsObj, 'log') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, LogItem object) {}
}

class _LogItemNativeAdapter extends IsarNativeTypeAdapter<LogItem> {
  const _LogItemNativeAdapter();

  @override
  void serialize(IsarCollection<LogItem> collection, IsarRawObject rawObj,
      LogItem object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.log;
    final _log = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_log.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _log);
  }

  @override
  LogItem deserialize(IsarCollection<LogItem> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = LogItem(
      reader.readString(offsets[0]),
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, LogItem object) {}
}

extension LogItemQueryWhereSort on QueryBuilder<LogItem, LogItem, QWhere> {
  QueryBuilder<LogItem, LogItem, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension LogItemQueryWhere on QueryBuilder<LogItem, LogItem, QWhereClause> {
  QueryBuilder<LogItem, LogItem, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterWhereClause> idNotEqualTo(int? id) {
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

  QueryBuilder<LogItem, LogItem, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterWhereClause> idBetween(
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

extension LogItemQueryFilter
    on QueryBuilder<LogItem, LogItem, QFilterCondition> {
  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'log',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'log',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'log',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'log',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'log',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'log',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'log',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LogItem, LogItem, QAfterFilterCondition> logMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'log',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension LogItemQueryLinks
    on QueryBuilder<LogItem, LogItem, QFilterCondition> {}

extension LogItemQueryWhereSortBy on QueryBuilder<LogItem, LogItem, QSortBy> {
  QueryBuilder<LogItem, LogItem, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<LogItem, LogItem, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<LogItem, LogItem, QAfterSortBy> sortByLog() {
    return addSortByInternal('log', Sort.asc);
  }

  QueryBuilder<LogItem, LogItem, QAfterSortBy> sortByLogDesc() {
    return addSortByInternal('log', Sort.desc);
  }
}

extension LogItemQueryWhereSortThenBy
    on QueryBuilder<LogItem, LogItem, QSortThenBy> {
  QueryBuilder<LogItem, LogItem, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<LogItem, LogItem, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<LogItem, LogItem, QAfterSortBy> thenByLog() {
    return addSortByInternal('log', Sort.asc);
  }

  QueryBuilder<LogItem, LogItem, QAfterSortBy> thenByLogDesc() {
    return addSortByInternal('log', Sort.desc);
  }
}

extension LogItemQueryWhereDistinct
    on QueryBuilder<LogItem, LogItem, QDistinct> {
  QueryBuilder<LogItem, LogItem, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<LogItem, LogItem, QDistinct> distinctByLog(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('log', caseSensitive: caseSensitive);
  }
}

extension LogItemQueryProperty
    on QueryBuilder<LogItem, LogItem, QQueryProperty> {
  QueryBuilder<LogItem, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<LogItem, String, QQueryOperations> logProperty() {
    return addPropertyNameInternal('log');
  }
}
