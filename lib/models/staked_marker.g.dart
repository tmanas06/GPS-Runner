// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staked_marker.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStakedMarkerLocalCollection on Isar {
  IsarCollection<StakedMarkerLocal> get stakedMarkerLocals => this.collection();
}

const StakedMarkerLocalSchema = CollectionSchema(
  name: r'StakedMarkerLocal',
  id: 933802594361291513,
  properties: {
    r'accumulatedYieldETH': PropertySchema(
      id: 0,
      name: r'accumulatedYieldETH',
      type: IsarType.double,
    ),
    r'canUnstake': PropertySchema(
      id: 1,
      name: r'canUnstake',
      type: IsarType.bool,
    ),
    r'cityHash': PropertySchema(
      id: 2,
      name: r'cityHash',
      type: IsarType.string,
    ),
    r'cityName': PropertySchema(
      id: 3,
      name: r'cityName',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'landmarkHash': PropertySchema(
      id: 5,
      name: r'landmarkHash',
      type: IsarType.string,
    ),
    r'landmarkName': PropertySchema(
      id: 6,
      name: r'landmarkName',
      type: IsarType.string,
    ),
    r'lastClaimTime': PropertySchema(
      id: 7,
      name: r'lastClaimTime',
      type: IsarType.dateTime,
    ),
    r'markerId': PropertySchema(
      id: 8,
      name: r'markerId',
      type: IsarType.long,
    ),
    r'stakedAt': PropertySchema(
      id: 9,
      name: r'stakedAt',
      type: IsarType.dateTime,
    ),
    r'txHash': PropertySchema(
      id: 10,
      name: r'txHash',
      type: IsarType.string,
    )
  },
  estimateSize: _stakedMarkerLocalEstimateSize,
  serialize: _stakedMarkerLocalSerialize,
  deserialize: _stakedMarkerLocalDeserialize,
  deserializeProp: _stakedMarkerLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'markerId': IndexSchema(
      id: -5246057519705477846,
      name: r'markerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'markerId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'landmarkHash': IndexSchema(
      id: -1753668327985093436,
      name: r'landmarkHash',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'landmarkHash',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'stakedAt': IndexSchema(
      id: 5558191609904715747,
      name: r'stakedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'stakedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isSynced': IndexSchema(
      id: -39763503327887510,
      name: r'isSynced',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSynced',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _stakedMarkerLocalGetId,
  getLinks: _stakedMarkerLocalGetLinks,
  attach: _stakedMarkerLocalAttach,
  version: '3.1.0+1',
);

int _stakedMarkerLocalEstimateSize(
  StakedMarkerLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cityHash.length * 3;
  bytesCount += 3 + object.cityName.length * 3;
  bytesCount += 3 + object.landmarkHash.length * 3;
  bytesCount += 3 + object.landmarkName.length * 3;
  bytesCount += 3 + object.txHash.length * 3;
  return bytesCount;
}

void _stakedMarkerLocalSerialize(
  StakedMarkerLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accumulatedYieldETH);
  writer.writeBool(offsets[1], object.canUnstake);
  writer.writeString(offsets[2], object.cityHash);
  writer.writeString(offsets[3], object.cityName);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeString(offsets[5], object.landmarkHash);
  writer.writeString(offsets[6], object.landmarkName);
  writer.writeDateTime(offsets[7], object.lastClaimTime);
  writer.writeLong(offsets[8], object.markerId);
  writer.writeDateTime(offsets[9], object.stakedAt);
  writer.writeString(offsets[10], object.txHash);
}

StakedMarkerLocal _stakedMarkerLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StakedMarkerLocal();
  object.accumulatedYieldETH = reader.readDouble(offsets[0]);
  object.cityHash = reader.readString(offsets[2]);
  object.cityName = reader.readString(offsets[3]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[4]);
  object.landmarkHash = reader.readString(offsets[5]);
  object.landmarkName = reader.readString(offsets[6]);
  object.lastClaimTime = reader.readDateTime(offsets[7]);
  object.markerId = reader.readLong(offsets[8]);
  object.stakedAt = reader.readDateTime(offsets[9]);
  object.txHash = reader.readString(offsets[10]);
  return object;
}

P _stakedMarkerLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stakedMarkerLocalGetId(StakedMarkerLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stakedMarkerLocalGetLinks(
    StakedMarkerLocal object) {
  return [];
}

void _stakedMarkerLocalAttach(
    IsarCollection<dynamic> col, Id id, StakedMarkerLocal object) {
  object.id = id;
}

extension StakedMarkerLocalQueryWhereSort
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QWhere> {
  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhere>
      anyMarkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'markerId'),
      );
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhere>
      anyStakedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'stakedAt'),
      );
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhere>
      anyIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSynced'),
      );
    });
  }
}

extension StakedMarkerLocalQueryWhere
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QWhereClause> {
  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      markerIdEqualTo(int markerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'markerId',
        value: [markerId],
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      markerIdNotEqualTo(int markerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'markerId',
              lower: [],
              upper: [markerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'markerId',
              lower: [markerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'markerId',
              lower: [markerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'markerId',
              lower: [],
              upper: [markerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      markerIdGreaterThan(
    int markerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'markerId',
        lower: [markerId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      markerIdLessThan(
    int markerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'markerId',
        lower: [],
        upper: [markerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      markerIdBetween(
    int lowerMarkerId,
    int upperMarkerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'markerId',
        lower: [lowerMarkerId],
        includeLower: includeLower,
        upper: [upperMarkerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      landmarkHashEqualTo(String landmarkHash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'landmarkHash',
        value: [landmarkHash],
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      landmarkHashNotEqualTo(String landmarkHash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'landmarkHash',
              lower: [],
              upper: [landmarkHash],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'landmarkHash',
              lower: [landmarkHash],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'landmarkHash',
              lower: [landmarkHash],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'landmarkHash',
              lower: [],
              upper: [landmarkHash],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      stakedAtEqualTo(DateTime stakedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'stakedAt',
        value: [stakedAt],
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      stakedAtNotEqualTo(DateTime stakedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stakedAt',
              lower: [],
              upper: [stakedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stakedAt',
              lower: [stakedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stakedAt',
              lower: [stakedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stakedAt',
              lower: [],
              upper: [stakedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      stakedAtGreaterThan(
    DateTime stakedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stakedAt',
        lower: [stakedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      stakedAtLessThan(
    DateTime stakedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stakedAt',
        lower: [],
        upper: [stakedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      stakedAtBetween(
    DateTime lowerStakedAt,
    DateTime upperStakedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'stakedAt',
        lower: [lowerStakedAt],
        includeLower: includeLower,
        upper: [upperStakedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      isSyncedEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSynced',
        value: [isSynced],
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterWhereClause>
      isSyncedNotEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StakedMarkerLocalQueryFilter
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QFilterCondition> {
  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      accumulatedYieldETHEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accumulatedYieldETH',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      accumulatedYieldETHGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accumulatedYieldETH',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      accumulatedYieldETHLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accumulatedYieldETH',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      accumulatedYieldETHBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accumulatedYieldETH',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      canUnstakeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'canUnstake',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cityHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityHash',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityHash',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityName',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      cityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityName',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'landmarkHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'landmarkHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkHash',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'landmarkHash',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'landmarkName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'landmarkName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      landmarkNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      lastClaimTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastClaimTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      lastClaimTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastClaimTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      lastClaimTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastClaimTime',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      lastClaimTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastClaimTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      markerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markerId',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      markerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'markerId',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      markerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'markerId',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      markerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'markerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      stakedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stakedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      stakedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stakedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      stakedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stakedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      stakedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stakedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'txHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'txHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: '',
      ));
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterFilterCondition>
      txHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'txHash',
        value: '',
      ));
    });
  }
}

extension StakedMarkerLocalQueryObject
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QFilterCondition> {}

extension StakedMarkerLocalQueryLinks
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QFilterCondition> {}

extension StakedMarkerLocalQuerySortBy
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QSortBy> {
  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByAccumulatedYieldETH() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedYieldETH', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByAccumulatedYieldETHDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedYieldETH', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByCanUnstake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canUnstake', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByCanUnstakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canUnstake', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByCityHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByCityHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByCityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByCityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByLandmarkHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByLandmarkHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByLastClaimTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastClaimTime', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByLastClaimTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastClaimTime', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByMarkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerId', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByMarkerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerId', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByStakedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedAt', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByStakedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedAt', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      sortByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension StakedMarkerLocalQuerySortThenBy
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QSortThenBy> {
  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByAccumulatedYieldETH() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedYieldETH', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByAccumulatedYieldETHDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedYieldETH', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByCanUnstake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canUnstake', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByCanUnstakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'canUnstake', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByCityHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByCityHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByCityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByCityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByLandmarkHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByLandmarkHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByLastClaimTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastClaimTime', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByLastClaimTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastClaimTime', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByMarkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerId', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByMarkerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerId', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByStakedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedAt', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByStakedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedAt', Sort.desc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QAfterSortBy>
      thenByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension StakedMarkerLocalQueryWhereDistinct
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct> {
  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByAccumulatedYieldETH() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accumulatedYieldETH');
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByCanUnstake() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'canUnstake');
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByCityHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByCityName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByLandmarkHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarkHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByLandmarkName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarkName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByLastClaimTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastClaimTime');
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByMarkerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markerId');
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByStakedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stakedAt');
    });
  }

  QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QDistinct>
      distinctByTxHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txHash', caseSensitive: caseSensitive);
    });
  }
}

extension StakedMarkerLocalQueryProperty
    on QueryBuilder<StakedMarkerLocal, StakedMarkerLocal, QQueryProperty> {
  QueryBuilder<StakedMarkerLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StakedMarkerLocal, double, QQueryOperations>
      accumulatedYieldETHProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accumulatedYieldETH');
    });
  }

  QueryBuilder<StakedMarkerLocal, bool, QQueryOperations> canUnstakeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'canUnstake');
    });
  }

  QueryBuilder<StakedMarkerLocal, String, QQueryOperations> cityHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityHash');
    });
  }

  QueryBuilder<StakedMarkerLocal, String, QQueryOperations> cityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityName');
    });
  }

  QueryBuilder<StakedMarkerLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<StakedMarkerLocal, String, QQueryOperations>
      landmarkHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarkHash');
    });
  }

  QueryBuilder<StakedMarkerLocal, String, QQueryOperations>
      landmarkNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarkName');
    });
  }

  QueryBuilder<StakedMarkerLocal, DateTime, QQueryOperations>
      lastClaimTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastClaimTime');
    });
  }

  QueryBuilder<StakedMarkerLocal, int, QQueryOperations> markerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markerId');
    });
  }

  QueryBuilder<StakedMarkerLocal, DateTime, QQueryOperations>
      stakedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stakedAt');
    });
  }

  QueryBuilder<StakedMarkerLocal, String, QQueryOperations> txHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txHash');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetYieldTokenLocalCollection on Isar {
  IsarCollection<YieldTokenLocal> get yieldTokenLocals => this.collection();
}

const YieldTokenLocalSchema = CollectionSchema(
  name: r'YieldTokenLocal',
  id: -9208765621581599516,
  properties: {
    r'balance': PropertySchema(
      id: 0,
      name: r'balance',
      type: IsarType.double,
    ),
    r'cityHash': PropertySchema(
      id: 1,
      name: r'cityHash',
      type: IsarType.string,
    ),
    r'cityName': PropertySchema(
      id: 2,
      name: r'cityName',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 3,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'landmarkHash': PropertySchema(
      id: 4,
      name: r'landmarkHash',
      type: IsarType.string,
    ),
    r'landmarkName': PropertySchema(
      id: 5,
      name: r'landmarkName',
      type: IsarType.string,
    ),
    r'mintTxHash': PropertySchema(
      id: 6,
      name: r'mintTxHash',
      type: IsarType.string,
    ),
    r'mintedAt': PropertySchema(
      id: 7,
      name: r'mintedAt',
      type: IsarType.dateTime,
    ),
    r'pendingYield': PropertySchema(
      id: 8,
      name: r'pendingYield',
      type: IsarType.double,
    ),
    r'tokenId': PropertySchema(
      id: 9,
      name: r'tokenId',
      type: IsarType.string,
    )
  },
  estimateSize: _yieldTokenLocalEstimateSize,
  serialize: _yieldTokenLocalSerialize,
  deserialize: _yieldTokenLocalDeserialize,
  deserializeProp: _yieldTokenLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'tokenId': IndexSchema(
      id: 1854704487618306269,
      name: r'tokenId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tokenId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'mintedAt': IndexSchema(
      id: -5312522475856027567,
      name: r'mintedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mintedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _yieldTokenLocalGetId,
  getLinks: _yieldTokenLocalGetLinks,
  attach: _yieldTokenLocalAttach,
  version: '3.1.0+1',
);

int _yieldTokenLocalEstimateSize(
  YieldTokenLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cityHash.length * 3;
  bytesCount += 3 + object.cityName.length * 3;
  bytesCount += 3 + object.landmarkHash.length * 3;
  bytesCount += 3 + object.landmarkName.length * 3;
  bytesCount += 3 + object.mintTxHash.length * 3;
  bytesCount += 3 + object.tokenId.length * 3;
  return bytesCount;
}

void _yieldTokenLocalSerialize(
  YieldTokenLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.balance);
  writer.writeString(offsets[1], object.cityHash);
  writer.writeString(offsets[2], object.cityName);
  writer.writeBool(offsets[3], object.isSynced);
  writer.writeString(offsets[4], object.landmarkHash);
  writer.writeString(offsets[5], object.landmarkName);
  writer.writeString(offsets[6], object.mintTxHash);
  writer.writeDateTime(offsets[7], object.mintedAt);
  writer.writeDouble(offsets[8], object.pendingYield);
  writer.writeString(offsets[9], object.tokenId);
}

YieldTokenLocal _yieldTokenLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = YieldTokenLocal();
  object.balance = reader.readDouble(offsets[0]);
  object.cityHash = reader.readString(offsets[1]);
  object.cityName = reader.readString(offsets[2]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[3]);
  object.landmarkHash = reader.readString(offsets[4]);
  object.landmarkName = reader.readString(offsets[5]);
  object.mintTxHash = reader.readString(offsets[6]);
  object.mintedAt = reader.readDateTime(offsets[7]);
  object.pendingYield = reader.readDouble(offsets[8]);
  object.tokenId = reader.readString(offsets[9]);
  return object;
}

P _yieldTokenLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _yieldTokenLocalGetId(YieldTokenLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _yieldTokenLocalGetLinks(YieldTokenLocal object) {
  return [];
}

void _yieldTokenLocalAttach(
    IsarCollection<dynamic> col, Id id, YieldTokenLocal object) {
  object.id = id;
}

extension YieldTokenLocalQueryWhereSort
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QWhere> {
  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhere> anyMintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mintedAt'),
      );
    });
  }
}

extension YieldTokenLocalQueryWhere
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QWhereClause> {
  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      tokenIdEqualTo(String tokenId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tokenId',
        value: [tokenId],
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      tokenIdNotEqualTo(String tokenId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenId',
              lower: [],
              upper: [tokenId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenId',
              lower: [tokenId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenId',
              lower: [tokenId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenId',
              lower: [],
              upper: [tokenId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      mintedAtEqualTo(DateTime mintedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mintedAt',
        value: [mintedAt],
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      mintedAtNotEqualTo(DateTime mintedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintedAt',
              lower: [],
              upper: [mintedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintedAt',
              lower: [mintedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintedAt',
              lower: [mintedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintedAt',
              lower: [],
              upper: [mintedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      mintedAtGreaterThan(
    DateTime mintedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mintedAt',
        lower: [mintedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      mintedAtLessThan(
    DateTime mintedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mintedAt',
        lower: [],
        upper: [mintedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterWhereClause>
      mintedAtBetween(
    DateTime lowerMintedAt,
    DateTime upperMintedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mintedAt',
        lower: [lowerMintedAt],
        includeLower: includeLower,
        upper: [upperMintedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension YieldTokenLocalQueryFilter
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QFilterCondition> {
  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      balanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      balanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      balanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      balanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cityHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityName',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      cityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityName',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'landmarkHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'landmarkHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'landmarkHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'landmarkHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'landmarkName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'landmarkName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      landmarkNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintTxHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mintTxHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mintTxHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mintTxHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mintTxHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mintTxHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintTxHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintTxHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintTxHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintTxHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintTxHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mintedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mintedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      mintedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mintedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      pendingYieldEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      pendingYieldGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pendingYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      pendingYieldLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pendingYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      pendingYieldBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pendingYield',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tokenId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tokenId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tokenId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tokenId',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterFilterCondition>
      tokenIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tokenId',
        value: '',
      ));
    });
  }
}

extension YieldTokenLocalQueryObject
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QFilterCondition> {}

extension YieldTokenLocalQueryLinks
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QFilterCondition> {}

extension YieldTokenLocalQuerySortBy
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QSortBy> {
  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByCityHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByCityHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByCityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByCityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByLandmarkHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByLandmarkHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByMintTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintTxHash', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByMintTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintTxHash', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByMintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintedAt', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByMintedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintedAt', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByPendingYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingYield', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByPendingYieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingYield', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy> sortByTokenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenId', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      sortByTokenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenId', Sort.desc);
    });
  }
}

extension YieldTokenLocalQuerySortThenBy
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QSortThenBy> {
  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByCityHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByCityHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityHash', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByCityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByCityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityName', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByLandmarkHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByLandmarkHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkHash', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByMintTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintTxHash', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByMintTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintTxHash', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByMintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintedAt', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByMintedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintedAt', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByPendingYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingYield', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByPendingYieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingYield', Sort.desc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy> thenByTokenId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenId', Sort.asc);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QAfterSortBy>
      thenByTokenIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenId', Sort.desc);
    });
  }
}

extension YieldTokenLocalQueryWhereDistinct
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct> {
  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct> distinctByCityHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct> distinctByCityName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByLandmarkHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarkHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByLandmarkName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarkName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByMintTxHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintTxHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByMintedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintedAt');
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct>
      distinctByPendingYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingYield');
    });
  }

  QueryBuilder<YieldTokenLocal, YieldTokenLocal, QDistinct> distinctByTokenId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tokenId', caseSensitive: caseSensitive);
    });
  }
}

extension YieldTokenLocalQueryProperty
    on QueryBuilder<YieldTokenLocal, YieldTokenLocal, QQueryProperty> {
  QueryBuilder<YieldTokenLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<YieldTokenLocal, double, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<YieldTokenLocal, String, QQueryOperations> cityHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityHash');
    });
  }

  QueryBuilder<YieldTokenLocal, String, QQueryOperations> cityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityName');
    });
  }

  QueryBuilder<YieldTokenLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<YieldTokenLocal, String, QQueryOperations>
      landmarkHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarkHash');
    });
  }

  QueryBuilder<YieldTokenLocal, String, QQueryOperations>
      landmarkNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarkName');
    });
  }

  QueryBuilder<YieldTokenLocal, String, QQueryOperations> mintTxHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintTxHash');
    });
  }

  QueryBuilder<YieldTokenLocal, DateTime, QQueryOperations> mintedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintedAt');
    });
  }

  QueryBuilder<YieldTokenLocal, double, QQueryOperations>
      pendingYieldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingYield');
    });
  }

  QueryBuilder<YieldTokenLocal, String, QQueryOperations> tokenIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRUNBalanceLocalCollection on Isar {
  IsarCollection<RUNBalanceLocal> get rUNBalanceLocals => this.collection();
}

const RUNBalanceLocalSchema = CollectionSchema(
  name: r'RUNBalanceLocal',
  id: -5858908553783452701,
  properties: {
    r'balance': PropertySchema(
      id: 0,
      name: r'balance',
      type: IsarType.double,
    ),
    r'boostExpiresAt': PropertySchema(
      id: 1,
      name: r'boostExpiresAt',
      type: IsarType.dateTime,
    ),
    r'boostMultiplier': PropertySchema(
      id: 2,
      name: r'boostMultiplier',
      type: IsarType.long,
    ),
    r'effectiveMultiplier': PropertySchema(
      id: 3,
      name: r'effectiveMultiplier',
      type: IsarType.double,
    ),
    r'hasActiveBoost': PropertySchema(
      id: 4,
      name: r'hasActiveBoost',
      type: IsarType.bool,
    ),
    r'lastUpdated': PropertySchema(
      id: 5,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'pendingLPYield': PropertySchema(
      id: 6,
      name: r'pendingLPYield',
      type: IsarType.double,
    ),
    r'stakedBalance': PropertySchema(
      id: 7,
      name: r'stakedBalance',
      type: IsarType.double,
    ),
    r'totalBurned': PropertySchema(
      id: 8,
      name: r'totalBurned',
      type: IsarType.double,
    ),
    r'totalEarned': PropertySchema(
      id: 9,
      name: r'totalEarned',
      type: IsarType.double,
    )
  },
  estimateSize: _rUNBalanceLocalEstimateSize,
  serialize: _rUNBalanceLocalSerialize,
  deserialize: _rUNBalanceLocalDeserialize,
  deserializeProp: _rUNBalanceLocalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _rUNBalanceLocalGetId,
  getLinks: _rUNBalanceLocalGetLinks,
  attach: _rUNBalanceLocalAttach,
  version: '3.1.0+1',
);

int _rUNBalanceLocalEstimateSize(
  RUNBalanceLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _rUNBalanceLocalSerialize(
  RUNBalanceLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.balance);
  writer.writeDateTime(offsets[1], object.boostExpiresAt);
  writer.writeLong(offsets[2], object.boostMultiplier);
  writer.writeDouble(offsets[3], object.effectiveMultiplier);
  writer.writeBool(offsets[4], object.hasActiveBoost);
  writer.writeDateTime(offsets[5], object.lastUpdated);
  writer.writeDouble(offsets[6], object.pendingLPYield);
  writer.writeDouble(offsets[7], object.stakedBalance);
  writer.writeDouble(offsets[8], object.totalBurned);
  writer.writeDouble(offsets[9], object.totalEarned);
}

RUNBalanceLocal _rUNBalanceLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RUNBalanceLocal();
  object.balance = reader.readDouble(offsets[0]);
  object.boostExpiresAt = reader.readDateTimeOrNull(offsets[1]);
  object.boostMultiplier = reader.readLong(offsets[2]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[5]);
  object.pendingLPYield = reader.readDouble(offsets[6]);
  object.stakedBalance = reader.readDouble(offsets[7]);
  object.totalBurned = reader.readDouble(offsets[8]);
  object.totalEarned = reader.readDouble(offsets[9]);
  return object;
}

P _rUNBalanceLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _rUNBalanceLocalGetId(RUNBalanceLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rUNBalanceLocalGetLinks(RUNBalanceLocal object) {
  return [];
}

void _rUNBalanceLocalAttach(
    IsarCollection<dynamic> col, Id id, RUNBalanceLocal object) {
  object.id = id;
}

extension RUNBalanceLocalQueryWhereSort
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QWhere> {
  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RUNBalanceLocalQueryWhere
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QWhereClause> {
  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RUNBalanceLocalQueryFilter
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QFilterCondition> {
  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      balanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      balanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      balanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      balanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostExpiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boostExpiresAt',
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostExpiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boostExpiresAt',
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostExpiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boostExpiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostExpiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boostExpiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostExpiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boostExpiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostExpiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boostExpiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostMultiplierEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boostMultiplier',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostMultiplierGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'boostMultiplier',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostMultiplierLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'boostMultiplier',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      boostMultiplierBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'boostMultiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      effectiveMultiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'effectiveMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      effectiveMultiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'effectiveMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      effectiveMultiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'effectiveMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      effectiveMultiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'effectiveMultiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      hasActiveBoostEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasActiveBoost',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      pendingLPYieldEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingLPYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      pendingLPYieldGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pendingLPYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      pendingLPYieldLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pendingLPYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      pendingLPYieldBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pendingLPYield',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      stakedBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stakedBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      stakedBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stakedBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      stakedBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stakedBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      stakedBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stakedBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalBurnedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBurned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalBurnedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBurned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalBurnedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBurned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalBurnedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBurned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalEarnedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalEarned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalEarnedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalEarned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalEarnedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalEarned',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterFilterCondition>
      totalEarnedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalEarned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension RUNBalanceLocalQueryObject
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QFilterCondition> {}

extension RUNBalanceLocalQueryLinks
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QFilterCondition> {}

extension RUNBalanceLocalQuerySortBy
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QSortBy> {
  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByBoostExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostExpiresAt', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByBoostExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostExpiresAt', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByBoostMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostMultiplier', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByBoostMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostMultiplier', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByEffectiveMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveMultiplier', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByEffectiveMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveMultiplier', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByHasActiveBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasActiveBoost', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByHasActiveBoostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasActiveBoost', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByPendingLPYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLPYield', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByPendingLPYieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLPYield', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByStakedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedBalance', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByStakedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedBalance', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByTotalBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBurned', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByTotalBurnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBurned', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByTotalEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEarned', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      sortByTotalEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEarned', Sort.desc);
    });
  }
}

extension RUNBalanceLocalQuerySortThenBy
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QSortThenBy> {
  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByBoostExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostExpiresAt', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByBoostExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostExpiresAt', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByBoostMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostMultiplier', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByBoostMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boostMultiplier', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByEffectiveMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveMultiplier', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByEffectiveMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'effectiveMultiplier', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByHasActiveBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasActiveBoost', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByHasActiveBoostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasActiveBoost', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByPendingLPYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLPYield', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByPendingLPYieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLPYield', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByStakedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedBalance', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByStakedBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stakedBalance', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByTotalBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBurned', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByTotalBurnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBurned', Sort.desc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByTotalEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEarned', Sort.asc);
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QAfterSortBy>
      thenByTotalEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEarned', Sort.desc);
    });
  }
}

extension RUNBalanceLocalQueryWhereDistinct
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct> {
  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByBoostExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'boostExpiresAt');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByBoostMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'boostMultiplier');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByEffectiveMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'effectiveMultiplier');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByHasActiveBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasActiveBoost');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByPendingLPYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingLPYield');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByStakedBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stakedBalance');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByTotalBurned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBurned');
    });
  }

  QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QDistinct>
      distinctByTotalEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalEarned');
    });
  }
}

extension RUNBalanceLocalQueryProperty
    on QueryBuilder<RUNBalanceLocal, RUNBalanceLocal, QQueryProperty> {
  QueryBuilder<RUNBalanceLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RUNBalanceLocal, double, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<RUNBalanceLocal, DateTime?, QQueryOperations>
      boostExpiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'boostExpiresAt');
    });
  }

  QueryBuilder<RUNBalanceLocal, int, QQueryOperations>
      boostMultiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'boostMultiplier');
    });
  }

  QueryBuilder<RUNBalanceLocal, double, QQueryOperations>
      effectiveMultiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'effectiveMultiplier');
    });
  }

  QueryBuilder<RUNBalanceLocal, bool, QQueryOperations>
      hasActiveBoostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasActiveBoost');
    });
  }

  QueryBuilder<RUNBalanceLocal, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<RUNBalanceLocal, double, QQueryOperations>
      pendingLPYieldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingLPYield');
    });
  }

  QueryBuilder<RUNBalanceLocal, double, QQueryOperations>
      stakedBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stakedBalance');
    });
  }

  QueryBuilder<RUNBalanceLocal, double, QQueryOperations>
      totalBurnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBurned');
    });
  }

  QueryBuilder<RUNBalanceLocal, double, QQueryOperations>
      totalEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalEarned');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGovernanceVoteLocalCollection on Isar {
  IsarCollection<GovernanceVoteLocal> get governanceVoteLocals =>
      this.collection();
}

const GovernanceVoteLocalSchema = CollectionSchema(
  name: r'GovernanceVoteLocal',
  id: 3686673013063115883,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 1,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'proposalId': PropertySchema(
      id: 2,
      name: r'proposalId',
      type: IsarType.long,
    ),
    r'proposalType': PropertySchema(
      id: 3,
      name: r'proposalType',
      type: IsarType.string,
    ),
    r'txHash': PropertySchema(
      id: 4,
      name: r'txHash',
      type: IsarType.string,
    ),
    r'voteWeight': PropertySchema(
      id: 5,
      name: r'voteWeight',
      type: IsarType.double,
    ),
    r'votedAt': PropertySchema(
      id: 6,
      name: r'votedAt',
      type: IsarType.dateTime,
    ),
    r'votedFor': PropertySchema(
      id: 7,
      name: r'votedFor',
      type: IsarType.bool,
    )
  },
  estimateSize: _governanceVoteLocalEstimateSize,
  serialize: _governanceVoteLocalSerialize,
  deserialize: _governanceVoteLocalDeserialize,
  deserializeProp: _governanceVoteLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'proposalId': IndexSchema(
      id: -3329764516456808925,
      name: r'proposalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'proposalId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'votedFor': IndexSchema(
      id: -4377632460662646582,
      name: r'votedFor',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'votedFor',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isSynced': IndexSchema(
      id: -39763503327887510,
      name: r'isSynced',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSynced',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _governanceVoteLocalGetId,
  getLinks: _governanceVoteLocalGetLinks,
  attach: _governanceVoteLocalAttach,
  version: '3.1.0+1',
);

int _governanceVoteLocalEstimateSize(
  GovernanceVoteLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.proposalType.length * 3;
  bytesCount += 3 + object.txHash.length * 3;
  return bytesCount;
}

void _governanceVoteLocalSerialize(
  GovernanceVoteLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeBool(offsets[1], object.isSynced);
  writer.writeLong(offsets[2], object.proposalId);
  writer.writeString(offsets[3], object.proposalType);
  writer.writeString(offsets[4], object.txHash);
  writer.writeDouble(offsets[5], object.voteWeight);
  writer.writeDateTime(offsets[6], object.votedAt);
  writer.writeBool(offsets[7], object.votedFor);
}

GovernanceVoteLocal _governanceVoteLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GovernanceVoteLocal();
  object.description = reader.readString(offsets[0]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[1]);
  object.proposalId = reader.readLong(offsets[2]);
  object.proposalType = reader.readString(offsets[3]);
  object.txHash = reader.readString(offsets[4]);
  object.voteWeight = reader.readDouble(offsets[5]);
  object.votedAt = reader.readDateTime(offsets[6]);
  object.votedFor = reader.readBool(offsets[7]);
  return object;
}

P _governanceVoteLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _governanceVoteLocalGetId(GovernanceVoteLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _governanceVoteLocalGetLinks(
    GovernanceVoteLocal object) {
  return [];
}

void _governanceVoteLocalAttach(
    IsarCollection<dynamic> col, Id id, GovernanceVoteLocal object) {
  object.id = id;
}

extension GovernanceVoteLocalQueryWhereSort
    on QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QWhere> {
  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhere>
      anyProposalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'proposalId'),
      );
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhere>
      anyVotedFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'votedFor'),
      );
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhere>
      anyIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSynced'),
      );
    });
  }
}

extension GovernanceVoteLocalQueryWhere
    on QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QWhereClause> {
  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      proposalIdEqualTo(int proposalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'proposalId',
        value: [proposalId],
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      proposalIdNotEqualTo(int proposalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proposalId',
              lower: [],
              upper: [proposalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proposalId',
              lower: [proposalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proposalId',
              lower: [proposalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proposalId',
              lower: [],
              upper: [proposalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      proposalIdGreaterThan(
    int proposalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'proposalId',
        lower: [proposalId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      proposalIdLessThan(
    int proposalId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'proposalId',
        lower: [],
        upper: [proposalId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      proposalIdBetween(
    int lowerProposalId,
    int upperProposalId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'proposalId',
        lower: [lowerProposalId],
        includeLower: includeLower,
        upper: [upperProposalId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      votedForEqualTo(bool votedFor) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'votedFor',
        value: [votedFor],
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      votedForNotEqualTo(bool votedFor) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'votedFor',
              lower: [],
              upper: [votedFor],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'votedFor',
              lower: [votedFor],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'votedFor',
              lower: [votedFor],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'votedFor',
              lower: [],
              upper: [votedFor],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      isSyncedEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSynced',
        value: [isSynced],
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterWhereClause>
      isSyncedNotEqualTo(bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GovernanceVoteLocalQueryFilter on QueryBuilder<GovernanceVoteLocal,
    GovernanceVoteLocal, QFilterCondition> {
  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proposalId',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proposalId',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proposalId',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proposalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proposalType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proposalType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proposalType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proposalType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proposalType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proposalType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proposalType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proposalType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proposalType',
        value: '',
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      proposalTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proposalType',
        value: '',
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'txHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'txHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: '',
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      txHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'txHash',
        value: '',
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      voteWeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voteWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      voteWeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voteWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      voteWeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voteWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      voteWeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voteWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      votedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'votedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      votedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'votedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      votedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'votedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      votedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'votedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterFilterCondition>
      votedForEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'votedFor',
        value: value,
      ));
    });
  }
}

extension GovernanceVoteLocalQueryObject on QueryBuilder<GovernanceVoteLocal,
    GovernanceVoteLocal, QFilterCondition> {}

extension GovernanceVoteLocalQueryLinks on QueryBuilder<GovernanceVoteLocal,
    GovernanceVoteLocal, QFilterCondition> {}

extension GovernanceVoteLocalQuerySortBy
    on QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QSortBy> {
  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByProposalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalId', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByProposalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalId', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByProposalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalType', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByProposalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalType', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByVoteWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteWeight', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByVoteWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteWeight', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByVotedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedAt', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByVotedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedAt', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByVotedFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedFor', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      sortByVotedForDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedFor', Sort.desc);
    });
  }
}

extension GovernanceVoteLocalQuerySortThenBy
    on QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QSortThenBy> {
  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByProposalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalId', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByProposalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalId', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByProposalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalType', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByProposalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proposalType', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByVoteWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteWeight', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByVoteWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteWeight', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByVotedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedAt', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByVotedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedAt', Sort.desc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByVotedFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedFor', Sort.asc);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QAfterSortBy>
      thenByVotedForDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votedFor', Sort.desc);
    });
  }
}

extension GovernanceVoteLocalQueryWhereDistinct
    on QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct> {
  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByProposalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proposalId');
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByProposalType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proposalType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByTxHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByVoteWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteWeight');
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByVotedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'votedAt');
    });
  }

  QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QDistinct>
      distinctByVotedFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'votedFor');
    });
  }
}

extension GovernanceVoteLocalQueryProperty
    on QueryBuilder<GovernanceVoteLocal, GovernanceVoteLocal, QQueryProperty> {
  QueryBuilder<GovernanceVoteLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GovernanceVoteLocal, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<GovernanceVoteLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<GovernanceVoteLocal, int, QQueryOperations>
      proposalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proposalId');
    });
  }

  QueryBuilder<GovernanceVoteLocal, String, QQueryOperations>
      proposalTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proposalType');
    });
  }

  QueryBuilder<GovernanceVoteLocal, String, QQueryOperations> txHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txHash');
    });
  }

  QueryBuilder<GovernanceVoteLocal, double, QQueryOperations>
      voteWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteWeight');
    });
  }

  QueryBuilder<GovernanceVoteLocal, DateTime, QQueryOperations>
      votedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'votedAt');
    });
  }

  QueryBuilder<GovernanceVoteLocal, bool, QQueryOperations> votedForProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'votedFor');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetYieldClaimLocalCollection on Isar {
  IsarCollection<YieldClaimLocal> get yieldClaimLocals => this.collection();
}

const YieldClaimLocalSchema = CollectionSchema(
  name: r'YieldClaimLocal',
  id: 915304919138545448,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'claimType': PropertySchema(
      id: 1,
      name: r'claimType',
      type: IsarType.string,
    ),
    r'claimedAt': PropertySchema(
      id: 2,
      name: r'claimedAt',
      type: IsarType.dateTime,
    ),
    r'currency': PropertySchema(
      id: 3,
      name: r'currency',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'sourceId': PropertySchema(
      id: 5,
      name: r'sourceId',
      type: IsarType.string,
    ),
    r'txHash': PropertySchema(
      id: 6,
      name: r'txHash',
      type: IsarType.string,
    )
  },
  estimateSize: _yieldClaimLocalEstimateSize,
  serialize: _yieldClaimLocalSerialize,
  deserialize: _yieldClaimLocalDeserialize,
  deserializeProp: _yieldClaimLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'claimType': IndexSchema(
      id: -2903361940423334030,
      name: r'claimType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'claimType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'claimedAt': IndexSchema(
      id: 3602182620203233795,
      name: r'claimedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'claimedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _yieldClaimLocalGetId,
  getLinks: _yieldClaimLocalGetLinks,
  attach: _yieldClaimLocalAttach,
  version: '3.1.0+1',
);

int _yieldClaimLocalEstimateSize(
  YieldClaimLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.claimType.length * 3;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.sourceId.length * 3;
  bytesCount += 3 + object.txHash.length * 3;
  return bytesCount;
}

void _yieldClaimLocalSerialize(
  YieldClaimLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.claimType);
  writer.writeDateTime(offsets[2], object.claimedAt);
  writer.writeString(offsets[3], object.currency);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeString(offsets[5], object.sourceId);
  writer.writeString(offsets[6], object.txHash);
}

YieldClaimLocal _yieldClaimLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = YieldClaimLocal();
  object.amount = reader.readDouble(offsets[0]);
  object.claimType = reader.readString(offsets[1]);
  object.claimedAt = reader.readDateTime(offsets[2]);
  object.currency = reader.readString(offsets[3]);
  object.id = id;
  object.isSynced = reader.readBool(offsets[4]);
  object.sourceId = reader.readString(offsets[5]);
  object.txHash = reader.readString(offsets[6]);
  return object;
}

P _yieldClaimLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _yieldClaimLocalGetId(YieldClaimLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _yieldClaimLocalGetLinks(YieldClaimLocal object) {
  return [];
}

void _yieldClaimLocalAttach(
    IsarCollection<dynamic> col, Id id, YieldClaimLocal object) {
  object.id = id;
}

extension YieldClaimLocalQueryWhereSort
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QWhere> {
  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhere> anyClaimedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'claimedAt'),
      );
    });
  }
}

extension YieldClaimLocalQueryWhere
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QWhereClause> {
  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimTypeEqualTo(String claimType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'claimType',
        value: [claimType],
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimTypeNotEqualTo(String claimType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimType',
              lower: [],
              upper: [claimType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimType',
              lower: [claimType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimType',
              lower: [claimType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimType',
              lower: [],
              upper: [claimType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimedAtEqualTo(DateTime claimedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'claimedAt',
        value: [claimedAt],
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimedAtNotEqualTo(DateTime claimedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimedAt',
              lower: [],
              upper: [claimedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimedAt',
              lower: [claimedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimedAt',
              lower: [claimedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'claimedAt',
              lower: [],
              upper: [claimedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimedAtGreaterThan(
    DateTime claimedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'claimedAt',
        lower: [claimedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimedAtLessThan(
    DateTime claimedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'claimedAt',
        lower: [],
        upper: [claimedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterWhereClause>
      claimedAtBetween(
    DateTime lowerClaimedAt,
    DateTime upperClaimedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'claimedAt',
        lower: [lowerClaimedAt],
        includeLower: includeLower,
        upper: [upperClaimedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension YieldClaimLocalQueryFilter
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QFilterCondition> {
  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'claimType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'claimType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'claimType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'claimType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'claimType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'claimType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'claimType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'claimType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'claimType',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'claimType',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'claimedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'claimedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'claimedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      claimedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'claimedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      sourceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'txHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'txHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: '',
      ));
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterFilterCondition>
      txHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'txHash',
        value: '',
      ));
    });
  }
}

extension YieldClaimLocalQueryObject
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QFilterCondition> {}

extension YieldClaimLocalQueryLinks
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QFilterCondition> {}

extension YieldClaimLocalQuerySortBy
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QSortBy> {
  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByClaimType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimType', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByClaimTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimType', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByClaimedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedAt', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByClaimedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedAt', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy> sortByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      sortByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension YieldClaimLocalQuerySortThenBy
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QSortThenBy> {
  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByClaimType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimType', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByClaimTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimType', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByClaimedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedAt', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByClaimedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedAt', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy> thenByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QAfterSortBy>
      thenByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension YieldClaimLocalQueryWhereDistinct
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct> {
  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct> distinctByClaimType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'claimType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct>
      distinctByClaimedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'claimedAt');
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct> distinctBySourceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YieldClaimLocal, YieldClaimLocal, QDistinct> distinctByTxHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txHash', caseSensitive: caseSensitive);
    });
  }
}

extension YieldClaimLocalQueryProperty
    on QueryBuilder<YieldClaimLocal, YieldClaimLocal, QQueryProperty> {
  QueryBuilder<YieldClaimLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<YieldClaimLocal, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<YieldClaimLocal, String, QQueryOperations> claimTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'claimType');
    });
  }

  QueryBuilder<YieldClaimLocal, DateTime, QQueryOperations>
      claimedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'claimedAt');
    });
  }

  QueryBuilder<YieldClaimLocal, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<YieldClaimLocal, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<YieldClaimLocal, String, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<YieldClaimLocal, String, QQueryOperations> txHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txHash');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameCoinBalanceCollection on Isar {
  IsarCollection<GameCoinBalance> get gameCoinBalances => this.collection();
}

const GameCoinBalanceSchema = CollectionSchema(
  name: r'GameCoinBalance',
  id: 5401218705338515997,
  properties: {
    r'balance': PropertySchema(
      id: 0,
      name: r'balance',
      type: IsarType.double,
    ),
    r'chainName': PropertySchema(
      id: 1,
      name: r'chainName',
      type: IsarType.string,
    ),
    r'coinSymbol': PropertySchema(
      id: 2,
      name: r'coinSymbol',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 3,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'pendingClaim': PropertySchema(
      id: 4,
      name: r'pendingClaim',
      type: IsarType.double,
    )
  },
  estimateSize: _gameCoinBalanceEstimateSize,
  serialize: _gameCoinBalanceSerialize,
  deserialize: _gameCoinBalanceDeserialize,
  deserializeProp: _gameCoinBalanceDeserializeProp,
  idName: r'id',
  indexes: {
    r'coinSymbol': IndexSchema(
      id: 2313391437312092075,
      name: r'coinSymbol',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'coinSymbol',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _gameCoinBalanceGetId,
  getLinks: _gameCoinBalanceGetLinks,
  attach: _gameCoinBalanceAttach,
  version: '3.1.0+1',
);

int _gameCoinBalanceEstimateSize(
  GameCoinBalance object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chainName.length * 3;
  bytesCount += 3 + object.coinSymbol.length * 3;
  return bytesCount;
}

void _gameCoinBalanceSerialize(
  GameCoinBalance object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.balance);
  writer.writeString(offsets[1], object.chainName);
  writer.writeString(offsets[2], object.coinSymbol);
  writer.writeDateTime(offsets[3], object.lastUpdated);
  writer.writeDouble(offsets[4], object.pendingClaim);
}

GameCoinBalance _gameCoinBalanceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameCoinBalance();
  object.balance = reader.readDouble(offsets[0]);
  object.chainName = reader.readString(offsets[1]);
  object.coinSymbol = reader.readString(offsets[2]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[3]);
  object.pendingClaim = reader.readDouble(offsets[4]);
  return object;
}

P _gameCoinBalanceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gameCoinBalanceGetId(GameCoinBalance object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameCoinBalanceGetLinks(GameCoinBalance object) {
  return [];
}

void _gameCoinBalanceAttach(
    IsarCollection<dynamic> col, Id id, GameCoinBalance object) {
  object.id = id;
}

extension GameCoinBalanceByIndex on IsarCollection<GameCoinBalance> {
  Future<GameCoinBalance?> getByCoinSymbol(String coinSymbol) {
    return getByIndex(r'coinSymbol', [coinSymbol]);
  }

  GameCoinBalance? getByCoinSymbolSync(String coinSymbol) {
    return getByIndexSync(r'coinSymbol', [coinSymbol]);
  }

  Future<bool> deleteByCoinSymbol(String coinSymbol) {
    return deleteByIndex(r'coinSymbol', [coinSymbol]);
  }

  bool deleteByCoinSymbolSync(String coinSymbol) {
    return deleteByIndexSync(r'coinSymbol', [coinSymbol]);
  }

  Future<List<GameCoinBalance?>> getAllByCoinSymbol(
      List<String> coinSymbolValues) {
    final values = coinSymbolValues.map((e) => [e]).toList();
    return getAllByIndex(r'coinSymbol', values);
  }

  List<GameCoinBalance?> getAllByCoinSymbolSync(List<String> coinSymbolValues) {
    final values = coinSymbolValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'coinSymbol', values);
  }

  Future<int> deleteAllByCoinSymbol(List<String> coinSymbolValues) {
    final values = coinSymbolValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'coinSymbol', values);
  }

  int deleteAllByCoinSymbolSync(List<String> coinSymbolValues) {
    final values = coinSymbolValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'coinSymbol', values);
  }

  Future<Id> putByCoinSymbol(GameCoinBalance object) {
    return putByIndex(r'coinSymbol', object);
  }

  Id putByCoinSymbolSync(GameCoinBalance object, {bool saveLinks = true}) {
    return putByIndexSync(r'coinSymbol', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCoinSymbol(List<GameCoinBalance> objects) {
    return putAllByIndex(r'coinSymbol', objects);
  }

  List<Id> putAllByCoinSymbolSync(List<GameCoinBalance> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'coinSymbol', objects, saveLinks: saveLinks);
  }
}

extension GameCoinBalanceQueryWhereSort
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QWhere> {
  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameCoinBalanceQueryWhere
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QWhereClause> {
  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause>
      coinSymbolEqualTo(String coinSymbol) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'coinSymbol',
        value: [coinSymbol],
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterWhereClause>
      coinSymbolNotEqualTo(String coinSymbol) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [],
              upper: [coinSymbol],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [coinSymbol],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [coinSymbol],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [],
              upper: [coinSymbol],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GameCoinBalanceQueryFilter
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QFilterCondition> {
  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      balanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      balanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      balanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      balanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chainName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chainName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chainName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chainName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chainName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chainName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chainName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chainName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chainName',
        value: '',
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      chainNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chainName',
        value: '',
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinSymbol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coinSymbol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinSymbol',
        value: '',
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      coinSymbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coinSymbol',
        value: '',
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      pendingClaimEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingClaim',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      pendingClaimGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pendingClaim',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      pendingClaimLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pendingClaim',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterFilterCondition>
      pendingClaimBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pendingClaim',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension GameCoinBalanceQueryObject
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QFilterCondition> {}

extension GameCoinBalanceQueryLinks
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QFilterCondition> {}

extension GameCoinBalanceQuerySortBy
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QSortBy> {
  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByChainName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chainName', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByChainNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chainName', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByCoinSymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByCoinSymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByPendingClaim() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingClaim', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      sortByPendingClaimDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingClaim', Sort.desc);
    });
  }
}

extension GameCoinBalanceQuerySortThenBy
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QSortThenBy> {
  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByChainName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chainName', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByChainNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chainName', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByCoinSymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByCoinSymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByPendingClaim() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingClaim', Sort.asc);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QAfterSortBy>
      thenByPendingClaimDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingClaim', Sort.desc);
    });
  }
}

extension GameCoinBalanceQueryWhereDistinct
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QDistinct> {
  QueryBuilder<GameCoinBalance, GameCoinBalance, QDistinct>
      distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QDistinct> distinctByChainName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chainName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QDistinct>
      distinctByCoinSymbol({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinSymbol', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<GameCoinBalance, GameCoinBalance, QDistinct>
      distinctByPendingClaim() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingClaim');
    });
  }
}

extension GameCoinBalanceQueryProperty
    on QueryBuilder<GameCoinBalance, GameCoinBalance, QQueryProperty> {
  QueryBuilder<GameCoinBalance, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameCoinBalance, double, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<GameCoinBalance, String, QQueryOperations> chainNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chainName');
    });
  }

  QueryBuilder<GameCoinBalance, String, QQueryOperations> coinSymbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinSymbol');
    });
  }

  QueryBuilder<GameCoinBalance, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<GameCoinBalance, double, QQueryOperations>
      pendingClaimProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingClaim');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCollectedCoinEventCollection on Isar {
  IsarCollection<CollectedCoinEvent> get collectedCoinEvents =>
      this.collection();
}

const CollectedCoinEventSchema = CollectionSchema(
  name: r'CollectedCoinEvent',
  id: 8643106513423152606,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'claimedOnChain': PropertySchema(
      id: 1,
      name: r'claimedOnChain',
      type: IsarType.bool,
    ),
    r'coinSymbol': PropertySchema(
      id: 2,
      name: r'coinSymbol',
      type: IsarType.string,
    ),
    r'collectedAt': PropertySchema(
      id: 3,
      name: r'collectedAt',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 4,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 5,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'txHash': PropertySchema(
      id: 6,
      name: r'txHash',
      type: IsarType.string,
    )
  },
  estimateSize: _collectedCoinEventEstimateSize,
  serialize: _collectedCoinEventSerialize,
  deserialize: _collectedCoinEventDeserialize,
  deserializeProp: _collectedCoinEventDeserializeProp,
  idName: r'id',
  indexes: {
    r'coinSymbol': IndexSchema(
      id: 2313391437312092075,
      name: r'coinSymbol',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'coinSymbol',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'collectedAt': IndexSchema(
      id: -5519599978623615390,
      name: r'collectedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'collectedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _collectedCoinEventGetId,
  getLinks: _collectedCoinEventGetLinks,
  attach: _collectedCoinEventAttach,
  version: '3.1.0+1',
);

int _collectedCoinEventEstimateSize(
  CollectedCoinEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.coinSymbol.length * 3;
  bytesCount += 3 + object.txHash.length * 3;
  return bytesCount;
}

void _collectedCoinEventSerialize(
  CollectedCoinEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeBool(offsets[1], object.claimedOnChain);
  writer.writeString(offsets[2], object.coinSymbol);
  writer.writeDateTime(offsets[3], object.collectedAt);
  writer.writeDouble(offsets[4], object.latitude);
  writer.writeDouble(offsets[5], object.longitude);
  writer.writeString(offsets[6], object.txHash);
}

CollectedCoinEvent _collectedCoinEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CollectedCoinEvent();
  object.amount = reader.readDouble(offsets[0]);
  object.claimedOnChain = reader.readBool(offsets[1]);
  object.coinSymbol = reader.readString(offsets[2]);
  object.collectedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.latitude = reader.readDouble(offsets[4]);
  object.longitude = reader.readDouble(offsets[5]);
  object.txHash = reader.readString(offsets[6]);
  return object;
}

P _collectedCoinEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _collectedCoinEventGetId(CollectedCoinEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _collectedCoinEventGetLinks(
    CollectedCoinEvent object) {
  return [];
}

void _collectedCoinEventAttach(
    IsarCollection<dynamic> col, Id id, CollectedCoinEvent object) {
  object.id = id;
}

extension CollectedCoinEventQueryWhereSort
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QWhere> {
  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhere>
      anyCollectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'collectedAt'),
      );
    });
  }
}

extension CollectedCoinEventQueryWhere
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QWhereClause> {
  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      coinSymbolEqualTo(String coinSymbol) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'coinSymbol',
        value: [coinSymbol],
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      coinSymbolNotEqualTo(String coinSymbol) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [],
              upper: [coinSymbol],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [coinSymbol],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [coinSymbol],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'coinSymbol',
              lower: [],
              upper: [coinSymbol],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      collectedAtEqualTo(DateTime collectedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'collectedAt',
        value: [collectedAt],
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      collectedAtNotEqualTo(DateTime collectedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectedAt',
              lower: [],
              upper: [collectedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectedAt',
              lower: [collectedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectedAt',
              lower: [collectedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectedAt',
              lower: [],
              upper: [collectedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      collectedAtGreaterThan(
    DateTime collectedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'collectedAt',
        lower: [collectedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      collectedAtLessThan(
    DateTime collectedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'collectedAt',
        lower: [],
        upper: [collectedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterWhereClause>
      collectedAtBetween(
    DateTime lowerCollectedAt,
    DateTime upperCollectedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'collectedAt',
        lower: [lowerCollectedAt],
        includeLower: includeLower,
        upper: [upperCollectedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CollectedCoinEventQueryFilter
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QFilterCondition> {
  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      claimedOnChainEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'claimedOnChain',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coinSymbol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coinSymbol',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coinSymbol',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coinSymbol',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      coinSymbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coinSymbol',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      collectedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      collectedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      collectedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      collectedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collectedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'txHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'txHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: '',
      ));
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterFilterCondition>
      txHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'txHash',
        value: '',
      ));
    });
  }
}

extension CollectedCoinEventQueryObject
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QFilterCondition> {}

extension CollectedCoinEventQueryLinks
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QFilterCondition> {}

extension CollectedCoinEventQuerySortBy
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QSortBy> {
  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByClaimedOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedOnChain', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByClaimedOnChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedOnChain', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByCoinSymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByCoinSymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByCollectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectedAt', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByCollectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectedAt', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      sortByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension CollectedCoinEventQuerySortThenBy
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QSortThenBy> {
  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByClaimedOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedOnChain', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByClaimedOnChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'claimedOnChain', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByCoinSymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByCoinSymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coinSymbol', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByCollectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectedAt', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByCollectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectedAt', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QAfterSortBy>
      thenByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension CollectedCoinEventQueryWhereDistinct
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct> {
  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByClaimedOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'claimedOnChain');
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByCoinSymbol({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coinSymbol', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByCollectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collectedAt');
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QDistinct>
      distinctByTxHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txHash', caseSensitive: caseSensitive);
    });
  }
}

extension CollectedCoinEventQueryProperty
    on QueryBuilder<CollectedCoinEvent, CollectedCoinEvent, QQueryProperty> {
  QueryBuilder<CollectedCoinEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CollectedCoinEvent, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<CollectedCoinEvent, bool, QQueryOperations>
      claimedOnChainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'claimedOnChain');
    });
  }

  QueryBuilder<CollectedCoinEvent, String, QQueryOperations>
      coinSymbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coinSymbol');
    });
  }

  QueryBuilder<CollectedCoinEvent, DateTime, QQueryOperations>
      collectedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectedAt');
    });
  }

  QueryBuilder<CollectedCoinEvent, double, QQueryOperations>
      latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<CollectedCoinEvent, double, QQueryOperations>
      longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<CollectedCoinEvent, String, QQueryOperations> txHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txHash');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetYieldSnapshotLocalCollection on Isar {
  IsarCollection<YieldSnapshotLocal> get yieldSnapshotLocals =>
      this.collection();
}

const YieldSnapshotLocalSchema = CollectionSchema(
  name: r'YieldSnapshotLocal',
  id: 7657032120911119132,
  properties: {
    r'currentAPY': PropertySchema(
      id: 0,
      name: r'currentAPY',
      type: IsarType.double,
    ),
    r'leaderboardRank': PropertySchema(
      id: 1,
      name: r'leaderboardRank',
      type: IsarType.long,
    ),
    r'multiplier': PropertySchema(
      id: 2,
      name: r'multiplier',
      type: IsarType.double,
    ),
    r'runBalance': PropertySchema(
      id: 3,
      name: r'runBalance',
      type: IsarType.double,
    ),
    r'runStaked': PropertySchema(
      id: 4,
      name: r'runStaked',
      type: IsarType.double,
    ),
    r'snapshotDate': PropertySchema(
      id: 5,
      name: r'snapshotDate',
      type: IsarType.dateTime,
    ),
    r'totalPendingYield': PropertySchema(
      id: 6,
      name: r'totalPendingYield',
      type: IsarType.double,
    ),
    r'totalStakedMarkers': PropertySchema(
      id: 7,
      name: r'totalStakedMarkers',
      type: IsarType.long,
    ),
    r'totalYieldTokenBalance': PropertySchema(
      id: 8,
      name: r'totalYieldTokenBalance',
      type: IsarType.double,
    ),
    r'yieldTokenCount': PropertySchema(
      id: 9,
      name: r'yieldTokenCount',
      type: IsarType.long,
    )
  },
  estimateSize: _yieldSnapshotLocalEstimateSize,
  serialize: _yieldSnapshotLocalSerialize,
  deserialize: _yieldSnapshotLocalDeserialize,
  deserializeProp: _yieldSnapshotLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'snapshotDate': IndexSchema(
      id: 5828152464261680763,
      name: r'snapshotDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'snapshotDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _yieldSnapshotLocalGetId,
  getLinks: _yieldSnapshotLocalGetLinks,
  attach: _yieldSnapshotLocalAttach,
  version: '3.1.0+1',
);

int _yieldSnapshotLocalEstimateSize(
  YieldSnapshotLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _yieldSnapshotLocalSerialize(
  YieldSnapshotLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.currentAPY);
  writer.writeLong(offsets[1], object.leaderboardRank);
  writer.writeDouble(offsets[2], object.multiplier);
  writer.writeDouble(offsets[3], object.runBalance);
  writer.writeDouble(offsets[4], object.runStaked);
  writer.writeDateTime(offsets[5], object.snapshotDate);
  writer.writeDouble(offsets[6], object.totalPendingYield);
  writer.writeLong(offsets[7], object.totalStakedMarkers);
  writer.writeDouble(offsets[8], object.totalYieldTokenBalance);
  writer.writeLong(offsets[9], object.yieldTokenCount);
}

YieldSnapshotLocal _yieldSnapshotLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = YieldSnapshotLocal();
  object.currentAPY = reader.readDouble(offsets[0]);
  object.id = id;
  object.leaderboardRank = reader.readLong(offsets[1]);
  object.multiplier = reader.readDouble(offsets[2]);
  object.runBalance = reader.readDouble(offsets[3]);
  object.runStaked = reader.readDouble(offsets[4]);
  object.snapshotDate = reader.readDateTime(offsets[5]);
  object.totalPendingYield = reader.readDouble(offsets[6]);
  object.totalStakedMarkers = reader.readLong(offsets[7]);
  object.totalYieldTokenBalance = reader.readDouble(offsets[8]);
  object.yieldTokenCount = reader.readLong(offsets[9]);
  return object;
}

P _yieldSnapshotLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _yieldSnapshotLocalGetId(YieldSnapshotLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _yieldSnapshotLocalGetLinks(
    YieldSnapshotLocal object) {
  return [];
}

void _yieldSnapshotLocalAttach(
    IsarCollection<dynamic> col, Id id, YieldSnapshotLocal object) {
  object.id = id;
}

extension YieldSnapshotLocalQueryWhereSort
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QWhere> {
  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhere>
      anySnapshotDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'snapshotDate'),
      );
    });
  }
}

extension YieldSnapshotLocalQueryWhere
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QWhereClause> {
  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      snapshotDateEqualTo(DateTime snapshotDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'snapshotDate',
        value: [snapshotDate],
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      snapshotDateNotEqualTo(DateTime snapshotDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotDate',
              lower: [],
              upper: [snapshotDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotDate',
              lower: [snapshotDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotDate',
              lower: [snapshotDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotDate',
              lower: [],
              upper: [snapshotDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      snapshotDateGreaterThan(
    DateTime snapshotDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'snapshotDate',
        lower: [snapshotDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      snapshotDateLessThan(
    DateTime snapshotDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'snapshotDate',
        lower: [],
        upper: [snapshotDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterWhereClause>
      snapshotDateBetween(
    DateTime lowerSnapshotDate,
    DateTime upperSnapshotDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'snapshotDate',
        lower: [lowerSnapshotDate],
        includeLower: includeLower,
        upper: [upperSnapshotDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension YieldSnapshotLocalQueryFilter
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QFilterCondition> {
  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      currentAPYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentAPY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      currentAPYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentAPY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      currentAPYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentAPY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      currentAPYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentAPY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      leaderboardRankEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leaderboardRank',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      leaderboardRankGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leaderboardRank',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      leaderboardRankLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leaderboardRank',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      leaderboardRankBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leaderboardRank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      multiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      multiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      multiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      multiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'multiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runStakedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runStaked',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runStakedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runStaked',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runStakedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runStaked',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      runStakedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runStaked',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      snapshotDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotDate',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      snapshotDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotDate',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      snapshotDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotDate',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      snapshotDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalPendingYieldEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPendingYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalPendingYieldGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPendingYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalPendingYieldLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPendingYield',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalPendingYieldBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPendingYield',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalStakedMarkersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalStakedMarkers',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalStakedMarkersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalStakedMarkers',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalStakedMarkersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalStakedMarkers',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalStakedMarkersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalStakedMarkers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalYieldTokenBalanceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalYieldTokenBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalYieldTokenBalanceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalYieldTokenBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalYieldTokenBalanceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalYieldTokenBalance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      totalYieldTokenBalanceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalYieldTokenBalance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      yieldTokenCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yieldTokenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      yieldTokenCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yieldTokenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      yieldTokenCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yieldTokenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterFilterCondition>
      yieldTokenCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yieldTokenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension YieldSnapshotLocalQueryObject
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QFilterCondition> {}

extension YieldSnapshotLocalQueryLinks
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QFilterCondition> {}

extension YieldSnapshotLocalQuerySortBy
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QSortBy> {
  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByCurrentAPY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAPY', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByCurrentAPYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAPY', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByLeaderboardRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardRank', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByLeaderboardRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardRank', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByRunBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runBalance', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByRunBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runBalance', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByRunStaked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runStaked', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByRunStakedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runStaked', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortBySnapshotDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotDate', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortBySnapshotDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotDate', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByTotalPendingYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPendingYield', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByTotalPendingYieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPendingYield', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByTotalStakedMarkers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStakedMarkers', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByTotalStakedMarkersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStakedMarkers', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByTotalYieldTokenBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalYieldTokenBalance', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByTotalYieldTokenBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalYieldTokenBalance', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByYieldTokenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yieldTokenCount', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      sortByYieldTokenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yieldTokenCount', Sort.desc);
    });
  }
}

extension YieldSnapshotLocalQuerySortThenBy
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QSortThenBy> {
  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByCurrentAPY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAPY', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByCurrentAPYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentAPY', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByLeaderboardRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardRank', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByLeaderboardRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leaderboardRank', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByRunBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runBalance', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByRunBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runBalance', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByRunStaked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runStaked', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByRunStakedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runStaked', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenBySnapshotDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotDate', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenBySnapshotDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotDate', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByTotalPendingYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPendingYield', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByTotalPendingYieldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPendingYield', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByTotalStakedMarkers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStakedMarkers', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByTotalStakedMarkersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStakedMarkers', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByTotalYieldTokenBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalYieldTokenBalance', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByTotalYieldTokenBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalYieldTokenBalance', Sort.desc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByYieldTokenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yieldTokenCount', Sort.asc);
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QAfterSortBy>
      thenByYieldTokenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yieldTokenCount', Sort.desc);
    });
  }
}

extension YieldSnapshotLocalQueryWhereDistinct
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct> {
  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByCurrentAPY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentAPY');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByLeaderboardRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leaderboardRank');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'multiplier');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByRunBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runBalance');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByRunStaked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runStaked');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctBySnapshotDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotDate');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByTotalPendingYield() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPendingYield');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByTotalStakedMarkers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalStakedMarkers');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByTotalYieldTokenBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalYieldTokenBalance');
    });
  }

  QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QDistinct>
      distinctByYieldTokenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yieldTokenCount');
    });
  }
}

extension YieldSnapshotLocalQueryProperty
    on QueryBuilder<YieldSnapshotLocal, YieldSnapshotLocal, QQueryProperty> {
  QueryBuilder<YieldSnapshotLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<YieldSnapshotLocal, double, QQueryOperations>
      currentAPYProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentAPY');
    });
  }

  QueryBuilder<YieldSnapshotLocal, int, QQueryOperations>
      leaderboardRankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leaderboardRank');
    });
  }

  QueryBuilder<YieldSnapshotLocal, double, QQueryOperations>
      multiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'multiplier');
    });
  }

  QueryBuilder<YieldSnapshotLocal, double, QQueryOperations>
      runBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runBalance');
    });
  }

  QueryBuilder<YieldSnapshotLocal, double, QQueryOperations>
      runStakedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runStaked');
    });
  }

  QueryBuilder<YieldSnapshotLocal, DateTime, QQueryOperations>
      snapshotDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotDate');
    });
  }

  QueryBuilder<YieldSnapshotLocal, double, QQueryOperations>
      totalPendingYieldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPendingYield');
    });
  }

  QueryBuilder<YieldSnapshotLocal, int, QQueryOperations>
      totalStakedMarkersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalStakedMarkers');
    });
  }

  QueryBuilder<YieldSnapshotLocal, double, QQueryOperations>
      totalYieldTokenBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalYieldTokenBalance');
    });
  }

  QueryBuilder<YieldSnapshotLocal, int, QQueryOperations>
      yieldTokenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yieldTokenCount');
    });
  }
}
