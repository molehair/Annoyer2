// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetWordCollection on Isar {
  IsarCollection<Word> get words {
    return getCollection('Word');
  }
}

final WordSchema = CollectionSchema(
  name: 'Word',
  schema:
      '{"name":"Word","idName":"id","properties":[{"name":"def","type":"String"},{"name":"ex","type":"String"},{"name":"level","type":"Long"},{"name":"mnemonic","type":"String"},{"name":"name","type":"String"},{"name":"syncId","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _WordNativeAdapter(),
  webAdapter: const _WordWebAdapter(),
  idName: 'id',
  propertyIds: {
    'def': 0,
    'ex': 1,
    'level': 2,
    'mnemonic': 3,
    'name': 4,
    'syncId': 5
  },
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

class _WordWebAdapter extends IsarWebTypeAdapter<Word> {
  const _WordWebAdapter();

  @override
  Object serialize(IsarCollection<Word> collection, Word object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'def', object.def);
    IsarNative.jsObjectSet(jsObj, 'ex', object.ex);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'level', object.level);
    IsarNative.jsObjectSet(jsObj, 'mnemonic', object.mnemonic);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'syncId', object.syncId);
    return jsObj;
  }

  @override
  Word deserialize(IsarCollection<Word> collection, dynamic jsObj) {
    final object = Word(
      def: IsarNative.jsObjectGet(jsObj, 'def') ?? '',
      ex: IsarNative.jsObjectGet(jsObj, 'ex') ?? '',
      id: IsarNative.jsObjectGet(jsObj, 'id'),
      level: IsarNative.jsObjectGet(jsObj, 'level') ?? double.negativeInfinity,
      mnemonic: IsarNative.jsObjectGet(jsObj, 'mnemonic'),
      name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
    );
    object.syncId = IsarNative.jsObjectGet(jsObj, 'syncId') ?? '';
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'def':
        return (IsarNative.jsObjectGet(jsObj, 'def') ?? '') as P;
      case 'ex':
        return (IsarNative.jsObjectGet(jsObj, 'ex') ?? '') as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'level':
        return (IsarNative.jsObjectGet(jsObj, 'level') ??
            double.negativeInfinity) as P;
      case 'mnemonic':
        return (IsarNative.jsObjectGet(jsObj, 'mnemonic')) as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      case 'syncId':
        return (IsarNative.jsObjectGet(jsObj, 'syncId') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Word object) {}
}

class _WordNativeAdapter extends IsarNativeTypeAdapter<Word> {
  const _WordNativeAdapter();

  @override
  void serialize(IsarCollection<Word> collection, IsarRawObject rawObj,
      Word object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.def;
    final _def = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_def.length) as int;
    final value1 = object.ex;
    final _ex = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_ex.length) as int;
    final value2 = object.level;
    final _level = value2;
    final value3 = object.mnemonic;
    IsarUint8List? _mnemonic;
    if (value3 != null) {
      _mnemonic = IsarBinaryWriter.utf8Encoder.convert(value3);
    }
    dynamicSize += (_mnemonic?.length ?? 0) as int;
    final value4 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value4);
    dynamicSize += (_name.length) as int;
    final value5 = object.syncId;
    final _syncId = IsarBinaryWriter.utf8Encoder.convert(value5);
    dynamicSize += (_syncId.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _def);
    writer.writeBytes(offsets[1], _ex);
    writer.writeLong(offsets[2], _level);
    writer.writeBytes(offsets[3], _mnemonic);
    writer.writeBytes(offsets[4], _name);
    writer.writeBytes(offsets[5], _syncId);
  }

  @override
  Word deserialize(IsarCollection<Word> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Word(
      def: reader.readString(offsets[0]),
      ex: reader.readString(offsets[1]),
      id: id,
      level: reader.readLong(offsets[2]),
      mnemonic: reader.readStringOrNull(offsets[3]),
      name: reader.readString(offsets[4]),
    );
    object.syncId = reader.readString(offsets[5]);
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
      case 1:
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      case 3:
        return (reader.readStringOrNull(offset)) as P;
      case 4:
        return (reader.readString(offset)) as P;
      case 5:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Word object) {}
}

extension WordQueryWhereSort on QueryBuilder<Word, Word, QWhere> {
  QueryBuilder<Word, Word, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension WordQueryWhere on QueryBuilder<Word, Word, QWhereClause> {
  QueryBuilder<Word, Word, QAfterWhereClause> idEqualTo(int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idNotEqualTo(int? id) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idBetween(
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

extension WordQueryFilter on QueryBuilder<Word, Word, QFilterCondition> {
  QueryBuilder<Word, Word, QAfterFilterCondition> defEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'def',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'def',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'def',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'def',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'def',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'def',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'def',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> defMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'def',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'ex',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'ex',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'ex',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'ex',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'ex',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'ex',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'ex',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> exMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'ex',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> levelEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'level',
      value: value,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'level',
      value: value,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> levelLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'level',
      value: value,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'level',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'mnemonic',
      value: null,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'mnemonic',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'mnemonic',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'mnemonic',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'mnemonic',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'mnemonic',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'mnemonic',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'mnemonic',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> mnemonicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'mnemonic',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'syncId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'syncId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'syncId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'syncId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'syncId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'syncId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'syncId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> syncIdMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'syncId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension WordQueryLinks on QueryBuilder<Word, Word, QFilterCondition> {}

extension WordQueryWhereSortBy on QueryBuilder<Word, Word, QSortBy> {
  QueryBuilder<Word, Word, QAfterSortBy> sortByDef() {
    return addSortByInternal('def', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByDefDesc() {
    return addSortByInternal('def', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByEx() {
    return addSortByInternal('ex', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByExDesc() {
    return addSortByInternal('ex', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByLevel() {
    return addSortByInternal('level', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByLevelDesc() {
    return addSortByInternal('level', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByMnemonic() {
    return addSortByInternal('mnemonic', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByMnemonicDesc() {
    return addSortByInternal('mnemonic', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortBySyncId() {
    return addSortByInternal('syncId', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortBySyncIdDesc() {
    return addSortByInternal('syncId', Sort.desc);
  }
}

extension WordQueryWhereSortThenBy on QueryBuilder<Word, Word, QSortThenBy> {
  QueryBuilder<Word, Word, QAfterSortBy> thenByDef() {
    return addSortByInternal('def', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByDefDesc() {
    return addSortByInternal('def', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByEx() {
    return addSortByInternal('ex', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByExDesc() {
    return addSortByInternal('ex', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByLevel() {
    return addSortByInternal('level', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByLevelDesc() {
    return addSortByInternal('level', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByMnemonic() {
    return addSortByInternal('mnemonic', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByMnemonicDesc() {
    return addSortByInternal('mnemonic', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenBySyncId() {
    return addSortByInternal('syncId', Sort.asc);
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenBySyncIdDesc() {
    return addSortByInternal('syncId', Sort.desc);
  }
}

extension WordQueryWhereDistinct on QueryBuilder<Word, Word, QDistinct> {
  QueryBuilder<Word, Word, QDistinct> distinctByDef(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('def', caseSensitive: caseSensitive);
  }

  QueryBuilder<Word, Word, QDistinct> distinctByEx(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('ex', caseSensitive: caseSensitive);
  }

  QueryBuilder<Word, Word, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Word, Word, QDistinct> distinctByLevel() {
    return addDistinctByInternal('level');
  }

  QueryBuilder<Word, Word, QDistinct> distinctByMnemonic(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('mnemonic', caseSensitive: caseSensitive);
  }

  QueryBuilder<Word, Word, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Word, Word, QDistinct> distinctBySyncId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('syncId', caseSensitive: caseSensitive);
  }
}

extension WordQueryProperty on QueryBuilder<Word, Word, QQueryProperty> {
  QueryBuilder<Word, String, QQueryOperations> defProperty() {
    return addPropertyNameInternal('def');
  }

  QueryBuilder<Word, String, QQueryOperations> exProperty() {
    return addPropertyNameInternal('ex');
  }

  QueryBuilder<Word, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Word, int, QQueryOperations> levelProperty() {
    return addPropertyNameInternal('level');
  }

  QueryBuilder<Word, String?, QQueryOperations> mnemonicProperty() {
    return addPropertyNameInternal('mnemonic');
  }

  QueryBuilder<Word, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Word, String, QQueryOperations> syncIdProperty() {
    return addPropertyNameInternal('syncId');
  }
}
