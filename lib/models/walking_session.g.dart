// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walking_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWalkingSessionCollection on Isar {
  IsarCollection<WalkingSession> get walkingSessions => this.collection();
}

const WalkingSessionSchema = CollectionSchema(
  name: r'WalkingSession',
  id: 146181713400011743,
  properties: {
    r'avgSpeedKmh': PropertySchema(
      id: 0,
      name: r'avgSpeedKmh',
      type: IsarType.double,
    ),
    r'city': PropertySchema(
      id: 1,
      name: r'city',
      type: IsarType.string,
    ),
    r'durationSeconds': PropertySchema(
      id: 2,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 3,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 5,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'maxSpeedKmh': PropertySchema(
      id: 6,
      name: r'maxSpeedKmh',
      type: IsarType.double,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'state': PropertySchema(
      id: 8,
      name: r'state',
      type: IsarType.string,
    ),
    r'totalDistanceMeters': PropertySchema(
      id: 9,
      name: r'totalDistanceMeters',
      type: IsarType.double,
    ),
    r'totalSteps': PropertySchema(
      id: 10,
      name: r'totalSteps',
      type: IsarType.long,
    ),
    r'trackPoints': PropertySchema(
      id: 11,
      name: r'trackPoints',
      type: IsarType.objectList,
      target: r'TrackPoint',
    )
  },
  estimateSize: _walkingSessionEstimateSize,
  serialize: _walkingSessionSerialize,
  deserialize: _walkingSessionDeserialize,
  deserializeProp: _walkingSessionDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'startTime': IndexSchema(
      id: -3870335341264752872,
      name: r'startTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startTime',
          type: IndexType.value,
          caseSensitive: false,
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
    r'isActive': IndexSchema(
      id: 8092228061260947457,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isActive',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'TrackPoint': TrackPointSchema},
  getId: _walkingSessionGetId,
  getLinks: _walkingSessionGetLinks,
  attach: _walkingSessionAttach,
  version: '3.1.0+1',
);

int _walkingSessionEstimateSize(
  WalkingSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.state.length * 3;
  bytesCount += 3 + object.trackPoints.length * 3;
  {
    final offsets = allOffsets[TrackPoint]!;
    for (var i = 0; i < object.trackPoints.length; i++) {
      final value = object.trackPoints[i];
      bytesCount += TrackPointSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _walkingSessionSerialize(
  WalkingSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgSpeedKmh);
  writer.writeString(offsets[1], object.city);
  writer.writeLong(offsets[2], object.durationSeconds);
  writer.writeDateTime(offsets[3], object.endTime);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeDouble(offsets[6], object.maxSpeedKmh);
  writer.writeDateTime(offsets[7], object.startTime);
  writer.writeString(offsets[8], object.state);
  writer.writeDouble(offsets[9], object.totalDistanceMeters);
  writer.writeLong(offsets[10], object.totalSteps);
  writer.writeObjectList<TrackPoint>(
    offsets[11],
    allOffsets,
    TrackPointSchema.serialize,
    object.trackPoints,
  );
}

WalkingSession _walkingSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WalkingSession();
  object.avgSpeedKmh = reader.readDouble(offsets[0]);
  object.city = reader.readString(offsets[1]);
  object.durationSeconds = reader.readLong(offsets[2]);
  object.endTime = reader.readDateTimeOrNull(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.isActive = reader.readBool(offsets[5]);
  object.isarId = id;
  object.maxSpeedKmh = reader.readDouble(offsets[6]);
  object.startTime = reader.readDateTime(offsets[7]);
  object.state = reader.readString(offsets[8]);
  object.totalDistanceMeters = reader.readDouble(offsets[9]);
  object.totalSteps = reader.readLong(offsets[10]);
  object.trackPoints = reader.readObjectList<TrackPoint>(
        offsets[11],
        TrackPointSchema.deserialize,
        allOffsets,
        TrackPoint(),
      ) ??
      [];
  return object;
}

P _walkingSessionDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readObjectList<TrackPoint>(
            offset,
            TrackPointSchema.deserialize,
            allOffsets,
            TrackPoint(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _walkingSessionGetId(WalkingSession object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _walkingSessionGetLinks(WalkingSession object) {
  return [];
}

void _walkingSessionAttach(
    IsarCollection<dynamic> col, Id id, WalkingSession object) {
  object.isarId = id;
}

extension WalkingSessionByIndex on IsarCollection<WalkingSession> {
  Future<WalkingSession?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  WalkingSession? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<WalkingSession?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<WalkingSession?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(WalkingSession object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(WalkingSession object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<WalkingSession> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<WalkingSession> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension WalkingSessionQueryWhereSort
    on QueryBuilder<WalkingSession, WalkingSession, QWhere> {
  QueryBuilder<WalkingSession, WalkingSession, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhere> anyStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startTime'),
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhere> anyIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isActive'),
      );
    });
  }
}

extension WalkingSessionQueryWhere
    on QueryBuilder<WalkingSession, WalkingSession, QWhereClause> {
  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      startTimeEqualTo(DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startTime',
        value: [startTime],
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      startTimeNotEqualTo(DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [],
              upper: [startTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [startTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [startTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [],
              upper: [startTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      startTimeGreaterThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [startTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      startTimeLessThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [],
        upper: [startTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      startTimeBetween(
    DateTime lowerStartTime,
    DateTime upperStartTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [lowerStartTime],
        includeLower: includeLower,
        upper: [upperStartTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause> cityEqualTo(
      String city) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'city',
        value: [city],
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      cityNotEqualTo(String city) {
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      isActiveEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isActive',
        value: [isActive],
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterWhereClause>
      isActiveNotEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WalkingSessionQueryFilter
    on QueryBuilder<WalkingSession, WalkingSession, QFilterCondition> {
  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      avgSpeedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      avgSpeedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      avgSpeedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      avgSpeedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityEqualTo(
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityGreaterThan(
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityLessThan(
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityBetween(
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityStartsWith(
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityEndsWith(
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

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      maxSpeedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      maxSpeedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      maxSpeedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      maxSpeedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalDistanceMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalDistanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalDistanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalDistanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      totalStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'trackPoints',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'trackPoints',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'trackPoints',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'trackPoints',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'trackPoints',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'trackPoints',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension WalkingSessionQueryObject
    on QueryBuilder<WalkingSession, WalkingSession, QFilterCondition> {
  QueryBuilder<WalkingSession, WalkingSession, QAfterFilterCondition>
      trackPointsElement(FilterQuery<TrackPoint> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'trackPoints');
    });
  }
}

extension WalkingSessionQueryLinks
    on QueryBuilder<WalkingSession, WalkingSession, QFilterCondition> {}

extension WalkingSessionQuerySortBy
    on QueryBuilder<WalkingSession, WalkingSession, QSortBy> {
  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByAvgSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByAvgSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      sortByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }
}

extension WalkingSessionQuerySortThenBy
    on QueryBuilder<WalkingSession, WalkingSession, QSortThenBy> {
  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByAvgSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByAvgSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QAfterSortBy>
      thenByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }
}

extension WalkingSessionQueryWhereDistinct
    on QueryBuilder<WalkingSession, WalkingSession, QDistinct> {
  QueryBuilder<WalkingSession, WalkingSession, QDistinct>
      distinctByAvgSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgSpeedKmh');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct>
      distinctByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSpeedKmh');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct> distinctByState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct>
      distinctByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistanceMeters');
    });
  }

  QueryBuilder<WalkingSession, WalkingSession, QDistinct>
      distinctByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSteps');
    });
  }
}

extension WalkingSessionQueryProperty
    on QueryBuilder<WalkingSession, WalkingSession, QQueryProperty> {
  QueryBuilder<WalkingSession, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<WalkingSession, double, QQueryOperations> avgSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgSpeedKmh');
    });
  }

  QueryBuilder<WalkingSession, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<WalkingSession, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<WalkingSession, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<WalkingSession, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WalkingSession, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<WalkingSession, double, QQueryOperations> maxSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSpeedKmh');
    });
  }

  QueryBuilder<WalkingSession, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<WalkingSession, String, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<WalkingSession, double, QQueryOperations>
      totalDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistanceMeters');
    });
  }

  QueryBuilder<WalkingSession, int, QQueryOperations> totalStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSteps');
    });
  }

  QueryBuilder<WalkingSession, List<TrackPoint>, QQueryOperations>
      trackPointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackPoints');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserWalkingStatsCollection on Isar {
  IsarCollection<UserWalkingStats> get userWalkingStats => this.collection();
}

const UserWalkingStatsSchema = CollectionSchema(
  name: r'UserWalkingStats',
  id: -9125050284943422307,
  properties: {
    r'citiesVisited': PropertySchema(
      id: 0,
      name: r'citiesVisited',
      type: IsarType.long,
    ),
    r'distanceByCityJson': PropertySchema(
      id: 1,
      name: r'distanceByCityJson',
      type: IsarType.string,
    ),
    r'landmarksVisited': PropertySchema(
      id: 2,
      name: r'landmarksVisited',
      type: IsarType.long,
    ),
    r'markersByCityJson': PropertySchema(
      id: 3,
      name: r'markersByCityJson',
      type: IsarType.string,
    ),
    r'markersPlaced': PropertySchema(
      id: 4,
      name: r'markersPlaced',
      type: IsarType.long,
    ),
    r'maxSpeedKmh': PropertySchema(
      id: 5,
      name: r'maxSpeedKmh',
      type: IsarType.double,
    ),
    r'totalDistanceMeters': PropertySchema(
      id: 6,
      name: r'totalDistanceMeters',
      type: IsarType.double,
    ),
    r'totalDurationSeconds': PropertySchema(
      id: 7,
      name: r'totalDurationSeconds',
      type: IsarType.long,
    ),
    r'totalSessions': PropertySchema(
      id: 8,
      name: r'totalSessions',
      type: IsarType.long,
    ),
    r'totalSteps': PropertySchema(
      id: 9,
      name: r'totalSteps',
      type: IsarType.long,
    )
  },
  estimateSize: _userWalkingStatsEstimateSize,
  serialize: _userWalkingStatsSerialize,
  deserialize: _userWalkingStatsDeserialize,
  deserializeProp: _userWalkingStatsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userWalkingStatsGetId,
  getLinks: _userWalkingStatsGetLinks,
  attach: _userWalkingStatsAttach,
  version: '3.1.0+1',
);

int _userWalkingStatsEstimateSize(
  UserWalkingStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.distanceByCityJson.length * 3;
  bytesCount += 3 + object.markersByCityJson.length * 3;
  return bytesCount;
}

void _userWalkingStatsSerialize(
  UserWalkingStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.citiesVisited);
  writer.writeString(offsets[1], object.distanceByCityJson);
  writer.writeLong(offsets[2], object.landmarksVisited);
  writer.writeString(offsets[3], object.markersByCityJson);
  writer.writeLong(offsets[4], object.markersPlaced);
  writer.writeDouble(offsets[5], object.maxSpeedKmh);
  writer.writeDouble(offsets[6], object.totalDistanceMeters);
  writer.writeLong(offsets[7], object.totalDurationSeconds);
  writer.writeLong(offsets[8], object.totalSessions);
  writer.writeLong(offsets[9], object.totalSteps);
}

UserWalkingStats _userWalkingStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserWalkingStats();
  object.citiesVisited = reader.readLong(offsets[0]);
  object.distanceByCityJson = reader.readString(offsets[1]);
  object.id = id;
  object.landmarksVisited = reader.readLong(offsets[2]);
  object.markersByCityJson = reader.readString(offsets[3]);
  object.markersPlaced = reader.readLong(offsets[4]);
  object.maxSpeedKmh = reader.readDouble(offsets[5]);
  object.totalDistanceMeters = reader.readDouble(offsets[6]);
  object.totalDurationSeconds = reader.readLong(offsets[7]);
  object.totalSessions = reader.readLong(offsets[8]);
  object.totalSteps = reader.readLong(offsets[9]);
  return object;
}

P _userWalkingStatsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userWalkingStatsGetId(UserWalkingStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userWalkingStatsGetLinks(UserWalkingStats object) {
  return [];
}

void _userWalkingStatsAttach(
    IsarCollection<dynamic> col, Id id, UserWalkingStats object) {
  object.id = id;
}

extension UserWalkingStatsQueryWhereSort
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QWhere> {
  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserWalkingStatsQueryWhere
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QWhereClause> {
  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterWhereClause>
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

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterWhereClause> idBetween(
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

extension UserWalkingStatsQueryFilter
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QFilterCondition> {
  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      citiesVisitedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'citiesVisited',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      citiesVisitedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'citiesVisited',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      citiesVisitedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'citiesVisited',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      citiesVisitedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'citiesVisited',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distanceByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distanceByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distanceByCityJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'distanceByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'distanceByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'distanceByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'distanceByCityJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceByCityJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      distanceByCityJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'distanceByCityJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
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

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
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

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
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

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      landmarksVisitedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarksVisited',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      landmarksVisitedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'landmarksVisited',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      landmarksVisitedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'landmarksVisited',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      landmarksVisitedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'landmarksVisited',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markersByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'markersByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'markersByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'markersByCityJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'markersByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'markersByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'markersByCityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'markersByCityJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markersByCityJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersByCityJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'markersByCityJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersPlacedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markersPlaced',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersPlacedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'markersPlaced',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersPlacedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'markersPlaced',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      markersPlacedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'markersPlaced',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      maxSpeedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      maxSpeedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      maxSpeedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      maxSpeedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDistanceMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDistanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDistanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDistanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalSessionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalSessionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSessions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterFilterCondition>
      totalStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserWalkingStatsQueryObject
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QFilterCondition> {}

extension UserWalkingStatsQueryLinks
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QFilterCondition> {}

extension UserWalkingStatsQuerySortBy
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QSortBy> {
  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByCitiesVisited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'citiesVisited', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByCitiesVisitedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'citiesVisited', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByDistanceByCityJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceByCityJson', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByDistanceByCityJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceByCityJson', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByLandmarksVisited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarksVisited', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByLandmarksVisitedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarksVisited', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByMarkersByCityJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersByCityJson', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByMarkersByCityJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersByCityJson', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByMarkersPlaced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersPlaced', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByMarkersPlacedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersPlaced', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      sortByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }
}

extension UserWalkingStatsQuerySortThenBy
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QSortThenBy> {
  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByCitiesVisited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'citiesVisited', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByCitiesVisitedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'citiesVisited', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByDistanceByCityJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceByCityJson', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByDistanceByCityJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceByCityJson', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByLandmarksVisited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarksVisited', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByLandmarksVisitedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarksVisited', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByMarkersByCityJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersByCityJson', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByMarkersByCityJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersByCityJson', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByMarkersPlaced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersPlaced', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByMarkersPlacedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markersPlaced', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QAfterSortBy>
      thenByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }
}

extension UserWalkingStatsQueryWhereDistinct
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct> {
  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByCitiesVisited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'citiesVisited');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByDistanceByCityJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distanceByCityJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByLandmarksVisited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarksVisited');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByMarkersByCityJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markersByCityJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByMarkersPlaced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markersPlaced');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSpeedKmh');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistanceMeters');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDurationSeconds');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSessions');
    });
  }

  QueryBuilder<UserWalkingStats, UserWalkingStats, QDistinct>
      distinctByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSteps');
    });
  }
}

extension UserWalkingStatsQueryProperty
    on QueryBuilder<UserWalkingStats, UserWalkingStats, QQueryProperty> {
  QueryBuilder<UserWalkingStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserWalkingStats, int, QQueryOperations>
      citiesVisitedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'citiesVisited');
    });
  }

  QueryBuilder<UserWalkingStats, String, QQueryOperations>
      distanceByCityJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distanceByCityJson');
    });
  }

  QueryBuilder<UserWalkingStats, int, QQueryOperations>
      landmarksVisitedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarksVisited');
    });
  }

  QueryBuilder<UserWalkingStats, String, QQueryOperations>
      markersByCityJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markersByCityJson');
    });
  }

  QueryBuilder<UserWalkingStats, int, QQueryOperations>
      markersPlacedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markersPlaced');
    });
  }

  QueryBuilder<UserWalkingStats, double, QQueryOperations>
      maxSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSpeedKmh');
    });
  }

  QueryBuilder<UserWalkingStats, double, QQueryOperations>
      totalDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistanceMeters');
    });
  }

  QueryBuilder<UserWalkingStats, int, QQueryOperations>
      totalDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDurationSeconds');
    });
  }

  QueryBuilder<UserWalkingStats, int, QQueryOperations>
      totalSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSessions');
    });
  }

  QueryBuilder<UserWalkingStats, int, QQueryOperations> totalStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSteps');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCoveredAreaPointCollection on Isar {
  IsarCollection<CoveredAreaPoint> get coveredAreaPoints => this.collection();
}

const CoveredAreaPointSchema = CollectionSchema(
  name: r'CoveredAreaPoint',
  id: 4993129435540995633,
  properties: {
    r'city': PropertySchema(
      id: 0,
      name: r'city',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 1,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 2,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'timestamp': PropertySchema(
      id: 3,
      name: r'timestamp',
      type: IsarType.long,
    )
  },
  estimateSize: _coveredAreaPointEstimateSize,
  serialize: _coveredAreaPointSerialize,
  deserialize: _coveredAreaPointDeserialize,
  deserializeProp: _coveredAreaPointDeserializeProp,
  idName: r'id',
  indexes: {
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _coveredAreaPointGetId,
  getLinks: _coveredAreaPointGetLinks,
  attach: _coveredAreaPointAttach,
  version: '3.1.0+1',
);

int _coveredAreaPointEstimateSize(
  CoveredAreaPoint object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.city.length * 3;
  return bytesCount;
}

void _coveredAreaPointSerialize(
  CoveredAreaPoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.city);
  writer.writeDouble(offsets[1], object.latitude);
  writer.writeDouble(offsets[2], object.longitude);
  writer.writeLong(offsets[3], object.timestamp);
}

CoveredAreaPoint _coveredAreaPointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoveredAreaPoint();
  object.city = reader.readString(offsets[0]);
  object.id = id;
  object.latitude = reader.readDouble(offsets[1]);
  object.longitude = reader.readDouble(offsets[2]);
  object.timestamp = reader.readLong(offsets[3]);
  return object;
}

P _coveredAreaPointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _coveredAreaPointGetId(CoveredAreaPoint object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _coveredAreaPointGetLinks(CoveredAreaPoint object) {
  return [];
}

void _coveredAreaPointAttach(
    IsarCollection<dynamic> col, Id id, CoveredAreaPoint object) {
  object.id = id;
}

extension CoveredAreaPointQueryWhereSort
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QWhere> {
  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CoveredAreaPointQueryWhere
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QWhereClause> {
  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause> idBetween(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause>
      cityEqualTo(String city) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'city',
        value: [city],
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterWhereClause>
      cityNotEqualTo(String city) {
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
}

extension CoveredAreaPointQueryFilter
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QFilterCondition> {
  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityEqualTo(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityGreaterThan(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityLessThan(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityBetween(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityStartsWith(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityEndsWith(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      timestampLessThan(
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

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterFilterCondition>
      timestampBetween(
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
}

extension CoveredAreaPointQueryObject
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QFilterCondition> {}

extension CoveredAreaPointQueryLinks
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QFilterCondition> {}

extension CoveredAreaPointQuerySortBy
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QSortBy> {
  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension CoveredAreaPointQuerySortThenBy
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QSortThenBy> {
  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension CoveredAreaPointQueryWhereDistinct
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QDistinct> {
  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension CoveredAreaPointQueryProperty
    on QueryBuilder<CoveredAreaPoint, CoveredAreaPoint, QQueryProperty> {
  QueryBuilder<CoveredAreaPoint, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CoveredAreaPoint, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<CoveredAreaPoint, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<CoveredAreaPoint, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<CoveredAreaPoint, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyLeaderboardEntryCollection on Isar {
  IsarCollection<WeeklyLeaderboardEntry> get weeklyLeaderboardEntrys =>
      this.collection();
}

const WeeklyLeaderboardEntrySchema = CollectionSchema(
  name: r'WeeklyLeaderboardEntry',
  id: -4359746739516864964,
  properties: {
    r'city': PropertySchema(
      id: 0,
      name: r'city',
      type: IsarType.string,
    ),
    r'distanceMeters': PropertySchema(
      id: 1,
      name: r'distanceMeters',
      type: IsarType.double,
    ),
    r'markerCount': PropertySchema(
      id: 2,
      name: r'markerCount',
      type: IsarType.long,
    ),
    r'maxSpeedKmh': PropertySchema(
      id: 3,
      name: r'maxSpeedKmh',
      type: IsarType.double,
    ),
    r'odId': PropertySchema(
      id: 4,
      name: r'odId',
      type: IsarType.string,
    ),
    r'playerColor': PropertySchema(
      id: 5,
      name: r'playerColor',
      type: IsarType.string,
    ),
    r'playerName': PropertySchema(
      id: 6,
      name: r'playerName',
      type: IsarType.string,
    ),
    r'rank': PropertySchema(
      id: 7,
      name: r'rank',
      type: IsarType.long,
    ),
    r'sessionCount': PropertySchema(
      id: 8,
      name: r'sessionCount',
      type: IsarType.long,
    ),
    r'totalSteps': PropertySchema(
      id: 9,
      name: r'totalSteps',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekNumber': PropertySchema(
      id: 11,
      name: r'weekNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _weeklyLeaderboardEntryEstimateSize,
  serialize: _weeklyLeaderboardEntrySerialize,
  deserialize: _weeklyLeaderboardEntryDeserialize,
  deserializeProp: _weeklyLeaderboardEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'odId': IndexSchema(
      id: -3963395389739130653,
      name: r'odId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'odId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'weekNumber': IndexSchema(
      id: 3113799900175558897,
      name: r'weekNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weekNumber',
          type: IndexType.value,
          caseSensitive: false,
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
    r'rank': IndexSchema(
      id: 432257220865207671,
      name: r'rank',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rank',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklyLeaderboardEntryGetId,
  getLinks: _weeklyLeaderboardEntryGetLinks,
  attach: _weeklyLeaderboardEntryAttach,
  version: '3.1.0+1',
);

int _weeklyLeaderboardEntryEstimateSize(
  WeeklyLeaderboardEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.odId.length * 3;
  bytesCount += 3 + object.playerColor.length * 3;
  bytesCount += 3 + object.playerName.length * 3;
  return bytesCount;
}

void _weeklyLeaderboardEntrySerialize(
  WeeklyLeaderboardEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.city);
  writer.writeDouble(offsets[1], object.distanceMeters);
  writer.writeLong(offsets[2], object.markerCount);
  writer.writeDouble(offsets[3], object.maxSpeedKmh);
  writer.writeString(offsets[4], object.odId);
  writer.writeString(offsets[5], object.playerColor);
  writer.writeString(offsets[6], object.playerName);
  writer.writeLong(offsets[7], object.rank);
  writer.writeLong(offsets[8], object.sessionCount);
  writer.writeLong(offsets[9], object.totalSteps);
  writer.writeDateTime(offsets[10], object.updatedAt);
  writer.writeLong(offsets[11], object.weekNumber);
}

WeeklyLeaderboardEntry _weeklyLeaderboardEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyLeaderboardEntry();
  object.city = reader.readString(offsets[0]);
  object.distanceMeters = reader.readDouble(offsets[1]);
  object.id = id;
  object.markerCount = reader.readLong(offsets[2]);
  object.maxSpeedKmh = reader.readDouble(offsets[3]);
  object.odId = reader.readString(offsets[4]);
  object.playerColor = reader.readString(offsets[5]);
  object.playerName = reader.readString(offsets[6]);
  object.rank = reader.readLong(offsets[7]);
  object.sessionCount = reader.readLong(offsets[8]);
  object.totalSteps = reader.readLong(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  object.weekNumber = reader.readLong(offsets[11]);
  return object;
}

P _weeklyLeaderboardEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyLeaderboardEntryGetId(WeeklyLeaderboardEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyLeaderboardEntryGetLinks(
    WeeklyLeaderboardEntry object) {
  return [];
}

void _weeklyLeaderboardEntryAttach(
    IsarCollection<dynamic> col, Id id, WeeklyLeaderboardEntry object) {
  object.id = id;
}

extension WeeklyLeaderboardEntryQueryWhereSort
    on QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QWhere> {
  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterWhere>
      anyWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekNumber'),
      );
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterWhere>
      anyRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'rank'),
      );
    });
  }
}

extension WeeklyLeaderboardEntryQueryWhere on QueryBuilder<
    WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QWhereClause> {
  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> odIdEqualTo(String odId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'odId',
        value: [odId],
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> odIdNotEqualTo(String odId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [],
              upper: [odId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [odId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [odId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'odId',
              lower: [],
              upper: [odId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> weekNumberEqualTo(int weekNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weekNumber',
        value: [weekNumber],
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> weekNumberNotEqualTo(int weekNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekNumber',
              lower: [],
              upper: [weekNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekNumber',
              lower: [weekNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekNumber',
              lower: [weekNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekNumber',
              lower: [],
              upper: [weekNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> weekNumberGreaterThan(
    int weekNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekNumber',
        lower: [weekNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> weekNumberLessThan(
    int weekNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekNumber',
        lower: [],
        upper: [weekNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> weekNumberBetween(
    int lowerWeekNumber,
    int upperWeekNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekNumber',
        lower: [lowerWeekNumber],
        includeLower: includeLower,
        upper: [upperWeekNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> cityEqualTo(String city) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'city',
        value: [city],
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> cityNotEqualTo(String city) {
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> rankEqualTo(int rank) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rank',
        value: [rank],
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> rankNotEqualTo(int rank) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rank',
              lower: [],
              upper: [rank],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rank',
              lower: [rank],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rank',
              lower: [rank],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rank',
              lower: [],
              upper: [rank],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> rankGreaterThan(
    int rank, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rank',
        lower: [rank],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> rankLessThan(
    int rank, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rank',
        lower: [],
        upper: [rank],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterWhereClause> rankBetween(
    int lowerRank,
    int upperRank, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rank',
        lower: [lowerRank],
        includeLower: includeLower,
        upper: [upperRank],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyLeaderboardEntryQueryFilter on QueryBuilder<
    WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QFilterCondition> {
  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityEqualTo(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityGreaterThan(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityLessThan(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityBetween(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityStartsWith(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityEndsWith(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> distanceMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> distanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> distanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> distanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> markerCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'markerCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> markerCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'markerCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> markerCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'markerCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> markerCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'markerCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> maxSpeedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> maxSpeedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> maxSpeedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> maxSpeedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'odId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      odIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'odId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      odIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'odId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> odIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'odId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      playerColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      playerColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerColor',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerColor',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameEqualTo(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameGreaterThan(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameLessThan(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameBetween(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameStartsWith(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameEndsWith(
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

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      playerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
          QAfterFilterCondition>
      playerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> playerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> rankEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rank',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> rankGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rank',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> rankLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rank',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> rankBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> sessionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> sessionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> sessionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> sessionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> totalStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> totalStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> totalStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> totalStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> weekNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> weekNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> weekNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry,
      QAfterFilterCondition> weekNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyLeaderboardEntryQueryObject on QueryBuilder<
    WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QFilterCondition> {}

extension WeeklyLeaderboardEntryQueryLinks on QueryBuilder<
    WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QFilterCondition> {}

extension WeeklyLeaderboardEntryQuerySortBy
    on QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QSortBy> {
  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByMarkerCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByMarkerCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByPlayerColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerColor', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByPlayerColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerColor', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      sortByWeekNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.desc);
    });
  }
}

extension WeeklyLeaderboardEntryQuerySortThenBy on QueryBuilder<
    WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QSortThenBy> {
  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distanceMeters', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByMarkerCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByMarkerCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markerCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByOdId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByOdIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'odId', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByPlayerColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerColor', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByPlayerColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerColor', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByTotalStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSteps', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.asc);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QAfterSortBy>
      thenByWeekNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.desc);
    });
  }
}

extension WeeklyLeaderboardEntryQueryWhereDistinct
    on QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct> {
  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distanceMeters');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByMarkerCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markerCount');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSpeedKmh');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByOdId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'odId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByPlayerColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerColor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByPlayerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rank');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionCount');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByTotalSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSteps');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QDistinct>
      distinctByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekNumber');
    });
  }
}

extension WeeklyLeaderboardEntryQueryProperty on QueryBuilder<
    WeeklyLeaderboardEntry, WeeklyLeaderboardEntry, QQueryProperty> {
  QueryBuilder<WeeklyLeaderboardEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, String, QQueryOperations>
      cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, double, QQueryOperations>
      distanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distanceMeters');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, int, QQueryOperations>
      markerCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markerCount');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, double, QQueryOperations>
      maxSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSpeedKmh');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, String, QQueryOperations>
      odIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'odId');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, String, QQueryOperations>
      playerColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerColor');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, String, QQueryOperations>
      playerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerName');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, int, QQueryOperations> rankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rank');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, int, QQueryOperations>
      sessionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionCount');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, int, QQueryOperations>
      totalStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSteps');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<WeeklyLeaderboardEntry, int, QQueryOperations>
      weekNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekNumber');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOfflineProofItemCollection on Isar {
  IsarCollection<OfflineProofItem> get offlineProofItems => this.collection();
}

const OfflineProofItemSchema = CollectionSchema(
  name: r'OfflineProofItem',
  id: -4906269830520422444,
  properties: {
    r'accuracy': PropertySchema(
      id: 0,
      name: r'accuracy',
      type: IsarType.double,
    ),
    r'activityType': PropertySchema(
      id: 1,
      name: r'activityType',
      type: IsarType.long,
    ),
    r'altitude': PropertySchema(
      id: 2,
      name: r'altitude',
      type: IsarType.double,
    ),
    r'city': PropertySchema(
      id: 3,
      name: r'city',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.long,
    ),
    r'landmarkName': PropertySchema(
      id: 5,
      name: r'landmarkName',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 6,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 7,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'playerId': PropertySchema(
      id: 8,
      name: r'playerId',
      type: IsarType.string,
    ),
    r'retryCount': PropertySchema(
      id: 9,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'speed': PropertySchema(
      id: 10,
      name: r'speed',
      type: IsarType.double,
    ),
    r'stateId': PropertySchema(
      id: 11,
      name: r'stateId',
      type: IsarType.string,
    ),
    r'stepsPerMin': PropertySchema(
      id: 12,
      name: r'stepsPerMin',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 13,
      name: r'timestamp',
      type: IsarType.long,
    )
  },
  estimateSize: _offlineProofItemEstimateSize,
  serialize: _offlineProofItemSerialize,
  deserialize: _offlineProofItemDeserialize,
  deserializeProp: _offlineProofItemDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _offlineProofItemGetId,
  getLinks: _offlineProofItemGetLinks,
  attach: _offlineProofItemAttach,
  version: '3.1.0+1',
);

int _offlineProofItemEstimateSize(
  OfflineProofItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.city.length * 3;
  {
    final value = object.landmarkName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.playerId.length * 3;
  bytesCount += 3 + object.stateId.length * 3;
  return bytesCount;
}

void _offlineProofItemSerialize(
  OfflineProofItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accuracy);
  writer.writeLong(offsets[1], object.activityType);
  writer.writeDouble(offsets[2], object.altitude);
  writer.writeString(offsets[3], object.city);
  writer.writeLong(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.landmarkName);
  writer.writeDouble(offsets[6], object.latitude);
  writer.writeDouble(offsets[7], object.longitude);
  writer.writeString(offsets[8], object.playerId);
  writer.writeLong(offsets[9], object.retryCount);
  writer.writeDouble(offsets[10], object.speed);
  writer.writeString(offsets[11], object.stateId);
  writer.writeLong(offsets[12], object.stepsPerMin);
  writer.writeLong(offsets[13], object.timestamp);
}

OfflineProofItem _offlineProofItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OfflineProofItem();
  object.accuracy = reader.readDouble(offsets[0]);
  object.activityType = reader.readLong(offsets[1]);
  object.altitude = reader.readDouble(offsets[2]);
  object.city = reader.readString(offsets[3]);
  object.createdAt = reader.readLong(offsets[4]);
  object.id = id;
  object.landmarkName = reader.readStringOrNull(offsets[5]);
  object.latitude = reader.readDouble(offsets[6]);
  object.longitude = reader.readDouble(offsets[7]);
  object.playerId = reader.readString(offsets[8]);
  object.retryCount = reader.readLong(offsets[9]);
  object.speed = reader.readDouble(offsets[10]);
  object.stateId = reader.readString(offsets[11]);
  object.stepsPerMin = reader.readLong(offsets[12]);
  object.timestamp = reader.readLong(offsets[13]);
  return object;
}

P _offlineProofItemDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _offlineProofItemGetId(OfflineProofItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _offlineProofItemGetLinks(OfflineProofItem object) {
  return [];
}

void _offlineProofItemAttach(
    IsarCollection<dynamic> col, Id id, OfflineProofItem object) {
  object.id = id;
}

extension OfflineProofItemQueryWhereSort
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QWhere> {
  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OfflineProofItemQueryWhere
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QWhereClause> {
  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterWhereClause>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterWhereClause> idBetween(
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

extension OfflineProofItemQueryFilter
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QFilterCondition> {
  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      accuracyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      accuracyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      accuracyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      accuracyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      activityTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityType',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      activityTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityType',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      activityTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityType',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      activityTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      altitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'altitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      altitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'altitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      altitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'altitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      altitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'altitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityEqualTo(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityGreaterThan(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityLessThan(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityBetween(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityStartsWith(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityEndsWith(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      createdAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'landmarkName',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'landmarkName',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameEqualTo(
    String? value, {
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameGreaterThan(
    String? value, {
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameLessThan(
    String? value, {
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'landmarkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'landmarkName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      landmarkNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'landmarkName',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdEqualTo(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdGreaterThan(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdLessThan(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdBetween(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdStartsWith(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdEndsWith(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      playerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      retryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      retryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      speedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      speedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      speedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      speedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stateIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateId',
        value: '',
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stepsPerMinEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stepsPerMin',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stepsPerMinLessThan(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      stepsPerMinBetween(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      timestampLessThan(
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

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterFilterCondition>
      timestampBetween(
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
}

extension OfflineProofItemQueryObject
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QFilterCondition> {}

extension OfflineProofItemQueryLinks
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QFilterCondition> {}

extension OfflineProofItemQuerySortBy
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QSortBy> {
  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByActivityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByAltitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy> sortBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByStateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByStateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByStepsPerMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByStepsPerMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension OfflineProofItemQuerySortThenBy
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QSortThenBy> {
  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByActivityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByAltitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'altitude', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByLandmarkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByLandmarkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'landmarkName', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByPlayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByPlayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerId', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy> thenBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByStateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByStateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateId', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByStepsPerMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByStepsPerMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepsPerMin', Sort.desc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension OfflineProofItemQueryWhereDistinct
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct> {
  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accuracy');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityType');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByAltitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'altitude');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByLandmarkName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'landmarkName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByPlayerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speed');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct> distinctByStateId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByStepsPerMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepsPerMin');
    });
  }

  QueryBuilder<OfflineProofItem, OfflineProofItem, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension OfflineProofItemQueryProperty
    on QueryBuilder<OfflineProofItem, OfflineProofItem, QQueryProperty> {
  QueryBuilder<OfflineProofItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OfflineProofItem, double, QQueryOperations> accuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accuracy');
    });
  }

  QueryBuilder<OfflineProofItem, int, QQueryOperations> activityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityType');
    });
  }

  QueryBuilder<OfflineProofItem, double, QQueryOperations> altitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'altitude');
    });
  }

  QueryBuilder<OfflineProofItem, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<OfflineProofItem, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OfflineProofItem, String?, QQueryOperations>
      landmarkNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'landmarkName');
    });
  }

  QueryBuilder<OfflineProofItem, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<OfflineProofItem, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<OfflineProofItem, String, QQueryOperations> playerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerId');
    });
  }

  QueryBuilder<OfflineProofItem, int, QQueryOperations> retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<OfflineProofItem, double, QQueryOperations> speedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speed');
    });
  }

  QueryBuilder<OfflineProofItem, String, QQueryOperations> stateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateId');
    });
  }

  QueryBuilder<OfflineProofItem, int, QQueryOperations> stepsPerMinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepsPerMin');
    });
  }

  QueryBuilder<OfflineProofItem, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TrackPointSchema = Schema(
  name: r'TrackPoint',
  id: 8639004722250935870,
  properties: {
    r'cumulativeSteps': PropertySchema(
      id: 0,
      name: r'cumulativeSteps',
      type: IsarType.long,
    ),
    r'latitude': PropertySchema(
      id: 1,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 2,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'speedKmh': PropertySchema(
      id: 3,
      name: r'speedKmh',
      type: IsarType.double,
    ),
    r'timestamp': PropertySchema(
      id: 4,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _trackPointEstimateSize,
  serialize: _trackPointSerialize,
  deserialize: _trackPointDeserialize,
  deserializeProp: _trackPointDeserializeProp,
);

int _trackPointEstimateSize(
  TrackPoint object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _trackPointSerialize(
  TrackPoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cumulativeSteps);
  writer.writeDouble(offsets[1], object.latitude);
  writer.writeDouble(offsets[2], object.longitude);
  writer.writeDouble(offsets[3], object.speedKmh);
  writer.writeDateTime(offsets[4], object.timestamp);
}

TrackPoint _trackPointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackPoint();
  object.cumulativeSteps = reader.readLong(offsets[0]);
  object.latitude = reader.readDouble(offsets[1]);
  object.longitude = reader.readDouble(offsets[2]);
  object.speedKmh = reader.readDouble(offsets[3]);
  object.timestamp = reader.readDateTime(offsets[4]);
  return object;
}

P _trackPointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TrackPointQueryFilter
    on QueryBuilder<TrackPoint, TrackPoint, QFilterCondition> {
  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
      cumulativeStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cumulativeSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
      cumulativeStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cumulativeSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
      cumulativeStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cumulativeSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
      cumulativeStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cumulativeSteps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> latitudeEqualTo(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> latitudeLessThan(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> latitudeBetween(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> longitudeEqualTo(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> longitudeLessThan(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> longitudeBetween(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> speedKmhEqualTo(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
      speedKmhGreaterThan(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> speedKmhLessThan(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> speedKmhBetween(
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
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

  QueryBuilder<TrackPoint, TrackPoint, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
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
}

extension TrackPointQueryObject
    on QueryBuilder<TrackPoint, TrackPoint, QFilterCondition> {}
