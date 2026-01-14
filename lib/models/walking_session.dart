import 'package:isar/isar.dart';

part 'walking_session.g.dart';

/// A single point in a walking track (embedded in WalkingSession)
@embedded
class TrackPoint {
  late double latitude;
  late double longitude;
  late DateTime timestamp;
  late double speedKmh;
  late int cumulativeSteps;

  TrackPoint();

  TrackPoint.create({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speedKmh,
    required this.cumulativeSteps,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp.toIso8601String(),
        'speedKmh': speedKmh,
        'cumulativeSteps': cumulativeSteps,
      };

  factory TrackPoint.fromJson(Map<String, dynamic> json) {
    return TrackPoint()
      ..latitude = (json['latitude'] ?? 0).toDouble()
      ..longitude = (json['longitude'] ?? 0).toDouble()
      ..timestamp = DateTime.parse(json['timestamp'])
      ..speedKmh = (json['speedKmh'] ?? 0).toDouble()
      ..cumulativeSteps = json['cumulativeSteps'] ?? 0;
  }
}

/// A walking/running session with tracked metrics
@collection
class WalkingSession {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late DateTime startTime;

  DateTime? endTime;
  late int totalSteps;
  late double totalDistanceMeters;
  late double maxSpeedKmh;
  late double avgSpeedKmh;
  late int durationSeconds;
  late List<TrackPoint> trackPoints;

  @Index()
  late String city;

  late String state;

  @Index()
  late bool isActive;

  WalkingSession();

  /// Create a new session
  factory WalkingSession.start({
    required String city,
    required String state,
  }) {
    return WalkingSession()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..startTime = DateTime.now()
      ..totalSteps = 0
      ..totalDistanceMeters = 0
      ..maxSpeedKmh = 0
      ..avgSpeedKmh = 0
      ..durationSeconds = 0
      ..trackPoints = []
      ..city = city
      ..state = state
      ..isActive = true;
  }

  /// Add a track point
  void addTrackPoint(double lat, double lng, double speed, int steps) {
    final newPoint = TrackPoint.create(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      speedKmh: speed,
      cumulativeSteps: steps,
    );
    trackPoints = [...trackPoints, newPoint];

    // Update max speed
    if (speed > maxSpeedKmh) {
      maxSpeedKmh = speed;
    }

    // Calculate distance from previous point
    if (trackPoints.length > 1) {
      final prev = trackPoints[trackPoints.length - 2];
      final dist = _calculateDistance(prev.latitude, prev.longitude, lat, lng);
      totalDistanceMeters += dist;
    }

    // Update duration
    durationSeconds = DateTime.now().difference(startTime).inSeconds;

    // Calculate average speed
    if (durationSeconds > 0) {
      avgSpeedKmh = (totalDistanceMeters / 1000) / (durationSeconds / 3600);
    }
  }

  /// End the session
  void end() {
    endTime = DateTime.now();
    isActive = false;
    durationSeconds = endTime!.difference(startTime).inSeconds;
  }

  /// Calculate distance between two points (Haversine approximation)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371000.0; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) *
            _cos(_toRadians(lat2)) *
            _sin(dLng / 2) *
            _sin(dLng / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double deg) => deg * 3.14159265359 / 180;
  double _sin(double x) => _taylorSin(x);
  double _cos(double x) => _taylorSin(x + 1.5707963267949);
  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _taylorSin(double x) {
    // Normalize to -pi to pi
    while (x > 3.14159265359) {
      x -= 6.28318530718;
    }
    while (x < -3.14159265359) {
      x += 6.28318530718;
    }
    double result = x;
    double term = x;
    for (int i = 1; i <= 7; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  double _atan2(double y, double x) {
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + 3.14159265359;
    if (x < 0 && y < 0) return _atan(y / x) - 3.14159265359;
    if (x == 0 && y > 0) return 1.5707963267949;
    if (x == 0 && y < 0) return -1.5707963267949;
    return 0;
  }

  double _atan(double x) {
    if (x.abs() > 1) {
      return (x > 0 ? 1 : -1) * 1.5707963267949 - _atan(1 / x);
    }
    double result = x;
    double term = x;
    for (int i = 1; i <= 15; i++) {
      term *= -x * x;
      result += term / (2 * i + 1);
    }
    return result;
  }

  /// Get distance in km
  @ignore
  double get distanceKm => totalDistanceMeters / 1000;

  /// Get formatted duration
  @ignore
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  /// Get formatted distance
  @ignore
  String get formattedDistance {
    if (totalDistanceMeters >= 1000) {
      return '${distanceKm.toStringAsFixed(2)} km';
    }
    return '${totalDistanceMeters.toStringAsFixed(0)} m';
  }

  /// Calculate estimated calories burned using MET (Metabolic Equivalent)
  /// MET values: Walking 3.5, Running 7.0, Average 5.0
  @ignore
  double get estimatedCalories {
    // Determine MET based on average speed
    double met;
    if (avgSpeedKmh < 5.0) {
      met = 3.5; // Slow walking
    } else if (avgSpeedKmh < 8.0) {
      met = 5.0; // Brisk walking
    } else if (avgSpeedKmh < 12.0) {
      met = 6.0; // Fast walking / jogging
    } else {
      met = 7.0; // Running
    }

    // Formula: Calories = MET × weight(kg) × time(hours)
    // Using average weight of 70kg (can be made configurable later)
    const averageWeightKg = 70.0;
    final hours = durationSeconds / 3600.0;
    return met * averageWeightKg * hours;
  }

  /// Get formatted calories
  @ignore
  String get formattedCalories {
    return '${estimatedCalories.toStringAsFixed(0)} kcal';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'totalSteps': totalSteps,
        'totalDistanceMeters': totalDistanceMeters,
        'maxSpeedKmh': maxSpeedKmh,
        'avgSpeedKmh': avgSpeedKmh,
        'durationSeconds': durationSeconds,
        'trackPoints': trackPoints.map((p) => p.toJson()).toList(),
        'city': city,
        'state': state,
        'isActive': isActive,
      };

  /// Create from JSON
  factory WalkingSession.fromJson(Map<String, dynamic> json) {
    return WalkingSession()
      ..id = json['id'] ?? ''
      ..startTime = DateTime.parse(json['startTime'])
      ..endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null
      ..totalSteps = json['totalSteps'] ?? 0
      ..totalDistanceMeters = (json['totalDistanceMeters'] ?? 0).toDouble()
      ..maxSpeedKmh = (json['maxSpeedKmh'] ?? 0).toDouble()
      ..avgSpeedKmh = (json['avgSpeedKmh'] ?? 0).toDouble()
      ..durationSeconds = json['durationSeconds'] ?? 0
      ..trackPoints = (json['trackPoints'] as List?)
              ?.map((p) => TrackPoint.fromJson(p))
              .toList() ??
          []
      ..city = json['city'] ?? ''
      ..state = json['state'] ?? ''
      ..isActive = json['isActive'] ?? false;
  }
}

/// Aggregate stats for a user
@collection
class UserWalkingStats {
  Id id = Isar.autoIncrement;

  late int totalSessions;
  late int totalSteps;
  late double totalDistanceMeters;
  late int totalDurationSeconds;
  late double maxSpeedKmh;
  late int markersPlaced;
  late int citiesVisited;
  late int landmarksVisited;

  // Store as JSON strings since Isar doesn't support Map directly
  late String distanceByCityJson;
  late String markersByCityJson;

  UserWalkingStats();

  factory UserWalkingStats.empty() {
    return UserWalkingStats()
      ..totalSessions = 0
      ..totalSteps = 0
      ..totalDistanceMeters = 0
      ..totalDurationSeconds = 0
      ..maxSpeedKmh = 0
      ..markersPlaced = 0
      ..citiesVisited = 0
      ..landmarksVisited = 0
      ..distanceByCityJson = '{}'
      ..markersByCityJson = '{}';
  }

  @ignore
  Map<String, double> get distanceByCity {
    try {
      final map = Map<String, dynamic>.from(
          _parseJson(distanceByCityJson) as Map? ?? {});
      return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (_) {
      return {};
    }
  }

  set distanceByCity(Map<String, double> value) {
    distanceByCityJson = _toJsonString(value);
  }

  @ignore
  Map<String, int> get markersByCity {
    try {
      final map = Map<String, dynamic>.from(
          _parseJson(markersByCityJson) as Map? ?? {});
      return map.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  set markersByCity(Map<String, int> value) {
    markersByCityJson = _toJsonString(value);
  }

  dynamic _parseJson(String json) {
    if (json.isEmpty) return {};
    try {
      // Simple JSON parsing for maps
      final content = json.trim();
      if (content == '{}') return {};
      // Remove braces
      final inner = content.substring(1, content.length - 1);
      if (inner.isEmpty) return {};
      final result = <String, dynamic>{};
      // Split by comma (simple case)
      final pairs = inner.split(',');
      for (final pair in pairs) {
        final kv = pair.split(':');
        if (kv.length == 2) {
          final key = kv[0].trim().replaceAll('"', '');
          final value = num.tryParse(kv[1].trim()) ?? 0;
          result[key] = value;
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  String _toJsonString(Map value) {
    if (value.isEmpty) return '{}';
    final pairs = value.entries.map((e) => '"${e.key}":${e.value}').join(',');
    return '{$pairs}';
  }

  @ignore
  double get totalDistanceKm => totalDistanceMeters / 1000;

  @ignore
  String get formattedTotalDistance {
    if (totalDistanceMeters >= 1000) {
      return '${totalDistanceKm.toStringAsFixed(2)} km';
    }
    return '${totalDistanceMeters.toStringAsFixed(0)} m';
  }

  @ignore
  String get formattedTotalDuration {
    final hours = totalDurationSeconds ~/ 3600;
    final minutes = (totalDurationSeconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Map<String, dynamic> toJson() => {
        'totalSessions': totalSessions,
        'totalSteps': totalSteps,
        'totalDistanceMeters': totalDistanceMeters,
        'totalDurationSeconds': totalDurationSeconds,
        'maxSpeedKmh': maxSpeedKmh,
        'markersPlaced': markersPlaced,
        'citiesVisited': citiesVisited,
        'landmarksVisited': landmarksVisited,
        'distanceByCity': distanceByCity,
        'markersByCity': markersByCity,
      };

  factory UserWalkingStats.fromJson(Map<String, dynamic> json) {
    final stats = UserWalkingStats()
      ..totalSessions = json['totalSessions'] ?? 0
      ..totalSteps = json['totalSteps'] ?? 0
      ..totalDistanceMeters = (json['totalDistanceMeters'] ?? 0).toDouble()
      ..totalDurationSeconds = json['totalDurationSeconds'] ?? 0
      ..maxSpeedKmh = (json['maxSpeedKmh'] ?? 0).toDouble()
      ..markersPlaced = json['markersPlaced'] ?? 0
      ..citiesVisited = json['citiesVisited'] ?? 0
      ..landmarksVisited = json['landmarksVisited'] ?? 0;
    stats.distanceByCity = Map<String, double>.from(json['distanceByCity'] ?? {});
    stats.markersByCity = Map<String, int>.from(json['markersByCity'] ?? {});
    return stats;
  }
}

/// Covered area point for tracking explored regions
@collection
class CoveredAreaPoint {
  Id id = Isar.autoIncrement;

  @Index()
  late String city;

  late double latitude;
  late double longitude;
  late int timestamp;

  CoveredAreaPoint();

  CoveredAreaPoint.create({
    required this.city,
    required this.latitude,
    required this.longitude,
  }) : timestamp = DateTime.now().millisecondsSinceEpoch;
}

/// Weekly leaderboard entry
@collection
class WeeklyLeaderboardEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late String odId; // Player ID

  late String playerName;
  late String playerColor;

  @Index()
  late int weekNumber; // Year * 100 + week (e.g., 202601)

  @Index()
  late String city; // City or 'global'

  late double distanceMeters;
  late int markerCount;
  late int sessionCount;
  late int totalSteps;
  late double maxSpeedKmh;

  @Index()
  late int rank; // Calculated rank for this week

  late DateTime updatedAt;

  WeeklyLeaderboardEntry();

  factory WeeklyLeaderboardEntry.create({
    required String odId,
    required String playerName,
    required String playerColor,
    required int weekNumber,
    required String city,
  }) {
    return WeeklyLeaderboardEntry()
      ..odId = odId
      ..playerName = playerName
      ..playerColor = playerColor
      ..weekNumber = weekNumber
      ..city = city
      ..distanceMeters = 0
      ..markerCount = 0
      ..sessionCount = 0
      ..totalSteps = 0
      ..maxSpeedKmh = 0
      ..rank = 0
      ..updatedAt = DateTime.now();
  }

  @ignore
  double get distanceKm => distanceMeters / 1000;

  @ignore
  String get formattedDistance {
    if (distanceMeters >= 1000) {
      return '${distanceKm.toStringAsFixed(2)} km';
    }
    return '${distanceMeters.toStringAsFixed(0)} m';
  }

  /// Get current week number (year * 100 + week)
  static int getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysDiff = now.difference(firstDayOfYear).inDays;
    final weekOfYear = ((daysDiff + firstDayOfYear.weekday - 1) / 7).ceil();
    return now.year * 100 + weekOfYear;
  }

  /// Get week number for a specific date
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    final weekOfYear = ((daysDiff + firstDayOfYear.weekday - 1) / 7).ceil();
    return date.year * 100 + weekOfYear;
  }

  /// Format week number to readable string
  static String formatWeekNumber(int weekNumber) {
    final year = weekNumber ~/ 100;
    final week = weekNumber % 100;
    return 'Week $week, $year';
  }
}

/// Offline proof queue item for sync
@collection
class OfflineProofItem {
  Id id = Isar.autoIncrement;

  late double latitude;
  late double longitude;
  late double altitude;
  late double accuracy;
  late double speed;
  late int stepsPerMin;
  late int activityType;
  late int timestamp;
  late String playerId;
  late String stateId;
  late String city;
  String? landmarkName;
  late int retryCount;
  late int createdAt;

  OfflineProofItem();

  @ignore
  bool get shouldRetry => retryCount < 5;

  OfflineProofItem incrementRetry() {
    retryCount++;
    return this;
  }
}
