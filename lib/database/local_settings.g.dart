// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetLocalSettingsCollection on Isar {
  IsarCollection<LocalSettings> get localSettingss {
    return getCollection('LocalSettings');
  }
}

final LocalSettingsSchema = CollectionSchema(
  name: 'LocalSettings',
  schema:
      '{"name":"LocalSettings","idName":"id","properties":[{"name":"value","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _LocalSettingsNativeAdapter(),
  webAdapter: const _LocalSettingsWebAdapter(),
  idName: 'id',
  propertyIds: {'value': 0},
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

class _LocalSettingsWebAdapter extends IsarWebTypeAdapter<LocalSettings> {
  const _LocalSettingsWebAdapter();

  @override
  Object serialize(
      IsarCollection<LocalSettings> collection, LocalSettings object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'value', object.value);
    return jsObj;
  }

  @override
  LocalSettings deserialize(
      IsarCollection<LocalSettings> collection, dynamic jsObj) {
    final object = LocalSettings(
      IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
      IsarNative.jsObjectGet(jsObj, 'value') ?? '',
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'value':
        return (IsarNative.jsObjectGet(jsObj, 'value') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, LocalSettings object) {}
}

class _LocalSettingsNativeAdapter extends IsarNativeTypeAdapter<LocalSettings> {
  const _LocalSettingsNativeAdapter();

  @override
  void serialize(
      IsarCollection<LocalSettings> collection,
      IsarRawObject rawObj,
      LocalSettings object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.value;
    final _value = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_value.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _value);
  }

  @override
  LocalSettings deserialize(IsarCollection<LocalSettings> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = LocalSettings(
      id,
      reader.readString(offsets[0]),
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
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, LocalSettings object) {}
}

extension LocalSettingsQueryWhereSort
    on QueryBuilder<LocalSettings, LocalSettings, QWhere> {
  QueryBuilder<LocalSettings, LocalSettings, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension LocalSettingsQueryWhere
    on QueryBuilder<LocalSettings, LocalSettings, QWhereClause> {
  QueryBuilder<LocalSettings, LocalSettings, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterWhereClause> idNotEqualTo(
      int id) {
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

  QueryBuilder<LocalSettings, LocalSettings, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
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

extension LocalSettingsQueryFilter
    on QueryBuilder<LocalSettings, LocalSettings, QFilterCondition> {
  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'value',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension LocalSettingsQueryLinks
    on QueryBuilder<LocalSettings, LocalSettings, QFilterCondition> {}

extension LocalSettingsQueryWhereSortBy
    on QueryBuilder<LocalSettings, LocalSettings, QSortBy> {
  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension LocalSettingsQueryWhereSortThenBy
    on QueryBuilder<LocalSettings, LocalSettings, QSortThenBy> {
  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<LocalSettings, LocalSettings, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension LocalSettingsQueryWhereDistinct
    on QueryBuilder<LocalSettings, LocalSettings, QDistinct> {
  QueryBuilder<LocalSettings, LocalSettings, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<LocalSettings, LocalSettings, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('value', caseSensitive: caseSensitive);
  }
}

extension LocalSettingsQueryProperty
    on QueryBuilder<LocalSettings, LocalSettings, QQueryProperty> {
  QueryBuilder<LocalSettings, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<LocalSettings, String, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
