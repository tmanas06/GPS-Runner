// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGPSMarkerCollection on Isar {
  IsarCollection<GPSMarker> get gPSMarkers => this.collection();
}

const GPSMarkerSchema = CollectionSchema(
  name: r'GPSMarker',
  id: 1474011841484584893,
  properties: {
    r'activityProof': PropertySchema(
      id: 0,
      name: r'activityProof',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 1,
      name: r'city',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 2,
      name: r'color',
      type: IsarType.string,
    ),
    r'landmarkName': PropertySchema(
      id: 3,
      name: r'landmarkName',
      type: IsarType.string,
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
    r'playerId': PropertySchema(
      id: 6,
      name: r'playerId',
      type: IsarType.string,
    ),
    r'playerName': PropertySchema(
      id: 7,
      name: r'playerName',
      type: IsarType.string,
    ),
    r'speedKmh': PropertySchema(
      id: 8,
      name: r'speedKmh',
      type: IsarType.double,
    ),
    r'stepsPerMin': PropertySchema(
      id: 9,
      name: r'stepsPerMin',
      type: IsarType.long,
    ),
    r'syncedToChain': PropertySchema(
      id: 10,
      name: r'syncedToChain',
      type: IsarType.bool,
    ),
    r'timestamp': PropertySchema(
      id: 11,
      name: r'timestamp',
      type: IsarType.long,
    ),
    r'txHash': PropertySchema(
      id: 12,
      name: r'txHash',
      type: IsarType.string,
    )
  },
  estimateSize: _gPSMarkerEstimateSize,
  serialize: _gPSMarkerSerialize,
  deserialize: _gPSMarkerDeserialize,
  deserializeProp: _gPSMarkerDeserializeProp,
  idName: r'id',
  indexes: {
    r'playerId': IndexSchema(
      id: 8338580293383144444,
      name: r'playerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'playerId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'city': IndexSchema(
      id: 2121973393509345332,
      name: r'city',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'city',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'syncedToChain': IndexSchema(
      id: -6024182968502291557,
      name: r'syncedToChain',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'syncedToChain',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _gPSMarkerGetId,
  getLinks: _gPSMarkerGetLinks,
  attach: _gPSMarkerAttach,
  version: '3.1.0+1',
);

int _gPSMarkerEstimateSize(
  GPSMarker object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activityProof.length * 3;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.color.length * 3;
  bytesCount += 3 + object.landmarkName.length * 3;
  bytesCount += 3 + object.playerId.length * 3;
  bytesCount += 3 + object.playerName.length * 3;
  bytesCount += 3 + object.txHash.length * 3;
  return bytesCount;
}

void _gPSMarkerSerialize(
  GPSMarker object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityProof);
  writer.writeString(offsets[1], object.city);
  writer.writeString(offsets[2], object.color);
  writer.writeString(offsets[3], object.landmarkName);
  writer.writeDouble(offsets[4], object.latitude);
  writer.writeDouble(offsets[5], object.longitude);
  writer.writeString(offsets[6], object.playerId);
  writer.writeString(offsets[7], object.playerName);
  writer.writeDouble(offsets[8], object.speedKmh);
  writer.writeLong(offsets[9], object.stepsPerMin);
  writer.writeBool(offsets[10], object.syncedToChain);
  writer.writeLong(offsets[11], object.timestamp);
  writer.writeString(offsets[12], object.txHash);
}

GPSMarker _gPSMarkerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GPSMarker();
  object.activityProof = reader.readString(offsets[0]);
  object.city = reader.readString(offsets[1]);
  object.color = reader.readString(offsets[2]);
  object.id = id;
  object.landmarkName = reader.readString(offsets[3]);
  object.latitude = reader.readDouble(offsets[4]);
  object.longitude = reader.readDouble(offsets[5]);
  object.playerId = reader.readString(offsets[6]);
  object.playerName = reader.readString(offsets[7]);
  object.speedKmh = reader.readDouble(offsets[8]);
  object.stepsPerMin = reader.readLong(offsets[9]);
  object.syncedToChain = reader.readBool(offsets[10]);
  object.timestamp = reader.readLong(offsets[11]);
  object.txHash = reader.readString(offsets[12]);
  return object;
}

P _gPSMarkerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gPSMarkerGetId(GPSMarker object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gPSMarkerGetLinks(GPSMarker object) {
  return [];
}

void _gPSMarkerAttach(IsarCollection<dynamic> col, Id id, GPSMarker object) {
  object.id = id;
}

extension GPSMarkerQueryWhereSort
    on QueryBuilder<GPSMarker, GPSMarker, QWhere> {
  QueryBuilder<GPSMarker, GPSMarker, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhere> anySyncedToChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'syncedToChain'),
      );
    });
  }
}

extension GPSMarkerQueryWhere
    on QueryBuilder<GPSMarker, GPSMarker, QWhereClause> {
  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> idBetween(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> playerIdEqualTo(
      String playerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'playerId',
        value: [playerId],
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> playerIdNotEqualTo(
      String playerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [],
              upper: [playerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [playerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [playerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'playerId',
              lower: [],
              upper: [playerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> cityEqualTo(
      String city) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'city',
        value: [city],
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> cityNotEqualTo(
      String city) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'city',
              lower: [],
              upper: [city],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'city',
              lower: [city],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'city',
              lower: [city],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'city',
              lower: [],
              upper: [city],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> timestampEqualTo(
      int timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> timestampNotEqualTo(
      int timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> timestampGreaterThan(
    int timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> timestampLessThan(
    int timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> timestampBetween(
    int lowerTimestamp,
    int upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> syncedToChainEqualTo(
      bool syncedToChain) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'syncedToChain',
        value: [syncedToChain],
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterWhereClause> syncedToChainNotEqualTo(
      bool syncedToChain) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedToChain',
              lower: [],
              upper: [syncedToChain],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedToChain',
              lower: [syncedToChain],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedToChain',
              lower: [syncedToChain],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'syncedToChain',
              lower: [],
              upper: [syncedToChain],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GPSMarkerQueryFilter
    on QueryBuilder<GPSMarker, GPSMarker, QFilterCondition> {
  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityProof',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityProof',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityProof',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      activityProofIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityProof',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> landmarkNameEqualTo(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> landmarkNameBetween(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      landmarkNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> landmarkNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'landmarkName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      landmarkNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      landmarkNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> latitudeEqualTo(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> latitudeGreaterThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> latitudeLessThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> latitudeBetween(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> longitudeEqualTo(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> longitudeLessThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> longitudeBetween(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      playerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      playerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      playerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> playerNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      playerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      playerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> speedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> speedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> speedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> speedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> stepsPerMinEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepsPerMin',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      stepsPerMinGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stepsPerMin',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> stepsPerMinLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stepsPerMin',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> stepsPerMinBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stepsPerMin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      syncedToChainEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedToChain',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> timestampEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition>
      timestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> timestampLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> timestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashEqualTo(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashGreaterThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashLessThan(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashBetween(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashStartsWith(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashEndsWith(
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

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'txHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'txHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'txHash',
        value: '',
      ));
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterFilterCondition> txHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'txHash',
        value: '',
      ));
    });
  }
}

extension GPSMarkerQueryObject
    on QueryBuilder<GPSMarker, GPSMarker, QFilterCondition> {}

extension GPSMarkerQueryLinks
    on QueryBuilder<GPSMarker, GPSMarker, QFilterCondition> {}

extension GPSMarkerQuerySortBy on QueryBuilder<GPSMarker, GPSMarker, QSortBy> {
  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByActivityProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityProof', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByActivityProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityProof', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortBySpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedKmh', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortBySpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedKmh', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByStepsPerMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByStepsPerMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortBySyncedToChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedToChain', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortBySyncedToChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedToChain', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> sortByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension GPSMarkerQuerySortThenBy
    on QueryBuilder<GPSMarker, GPSMarker, QSortThenBy> {
  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByActivityProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityProof', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByActivityProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityProof', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenBySpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedKmh', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenBySpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedKmh', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByStepsPerMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByStepsPerMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenBySyncedToChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedToChain', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenBySyncedToChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedToChain', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByTxHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.asc);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QAfterSortBy> thenByTxHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txHash', Sort.desc);
    });
  }
}

extension GPSMarkerQueryWhereDistinct
    on QueryBuilder<GPSMarker, GPSMarker, QDistinct> {
  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByActivityProof(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityProof',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByLandmarkName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarkName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByPlayerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByPlayerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctBySpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speedKmh');
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByStepsPerMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepsPerMin');
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctBySyncedToChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedToChain');
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<GPSMarker, GPSMarker, QDistinct> distinctByTxHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txHash', caseSensitive: caseSensitive);
    });
  }
}

extension GPSMarkerQueryProperty
    on QueryBuilder<GPSMarker, GPSMarker, QQueryProperty> {
  QueryBuilder<GPSMarker, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> activityProofProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityProof');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> landmarkNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarkName');
    });
  }

  QueryBuilder<GPSMarker, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<GPSMarker, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> playerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerId');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> playerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerName');
    });
  }

  QueryBuilder<GPSMarker, double, QQueryOperations> speedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speedKmh');
    });
  }

  QueryBuilder<GPSMarker, int, QQueryOperations> stepsPerMinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepsPerMin');
    });
  }

  QueryBuilder<GPSMarker, bool, QQueryOperations> syncedToChainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedToChain');
    });
  }

  QueryBuilder<GPSMarker, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<GPSMarker, String, QQueryOperations> txHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txHash');
    });
  }
}
