import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/gps_proof.dart';
import 'gps_service.dart';

/// Anti-cheat verification result
enum CheatStatus {
  valid,
  speedTooHigh,
  vehicleDetected,
  stepsLow,
  gpsAccuracyLow,
  teleportDetected,
  suspended,
}

/// Anti-cheat verification data
class AntiCheatResult {
  final CheatStatus status;
  final String message;
  final double confidence;
  final Map<String, dynamic> details;

  AntiCheatResult({
    required this.status,
    required this.message,
    this.confidence = 1.0,
    this.details = const {},
  });

  bool get isValid => status == CheatStatus.valid;
}

/// Anti-cheat detection thresholds
class AntiCheatConfig {
  // Speed limits
  static const double maxRunningSpeedMs = 8.0; // 28.8 km/h
  static const double maxWalkingSpeedMs = 2.5; // 9 km/h
  static const double maxSpeedKmh = 28.8;

  // Steps thresholds
  static const int minStepsPerMinWalking = 40;
  static const int minStepsPerMinRunning = 80;

  // GPS accuracy
  static const double maxAccuracyMeters = 50.0;

  // Teleport detection
  static const double maxDistancePerSecond = 15.0; // meters
  static const int teleportCheckSeconds = 5;

  // Suspension
  static const int maxViolations = 3;
  static const int suspensionMinutes = 15;
}

/// Anti-cheat service for detecting GPS spoofing and vehicle use
class AntiCheatService extends ChangeNotifier {
  static final AntiCheatService _instance = AntiCheatService._internal();
  factory AntiCheatService() => _instance;
  AntiCheatService._internal();

  // Violation tracking
  int _violationCount = 0;
  DateTime? _suspendedUntil;
  final List<_LocationHistory> _locationHistory = [];

  // Last verification result
  AntiCheatResult? _lastResult;

  // Status indicators
  bool _speedOk = true;
  bool _activityOk = true;
  bool _stepsOk = true;
  bool _gpsOk = true;

  // Getters
  AntiCheatResult? get lastResult => _lastResult;
  bool get isSuspended =>
      _suspendedUntil != null && DateTime.now().isBefore(_suspendedUntil!);
  int get violationCount => _violationCount;
  bool get speedOk => _speedOk;
  bool get activityOk => _activityOk;
  bool get stepsOk => _stepsOk;
  bool get gpsOk => _gpsOk;
  bool get allChecksPass => _speedOk && _activityOk && _stepsOk && _gpsOk;

  /// Verify GPS data for anti-cheat
  AntiCheatResult verify(GPSData data) {
    // Check if suspended
    if (isSuspended) {
      final remaining =
          _suspendedUntil!.difference(DateTime.now()).inMinutes + 1;
      _lastResult = AntiCheatResult(
        status: CheatStatus.suspended,
        message: 'Account suspended for $remaining more minutes',
        details: {'remainingMinutes': remaining},
      );
      notifyListeners();
      return _lastResult!;
    }

    // Reset status indicators
    _speedOk = true;
    _activityOk = true;
    _stepsOk = true;
    _gpsOk = true;

    // 1. Speed check
    final speedResult = _checkSpeed(data);
    if (!speedResult.isValid) {
      _speedOk = false;
      _recordViolation();
      _lastResult = speedResult;
      notifyListeners();
      return speedResult;
    }

    // 2. Activity check
    final activityResult = _checkActivity(data);
    if (!activityResult.isValid) {
      _activityOk = false;
      _recordViolation();
      _lastResult = activityResult;
      notifyListeners();
      return activityResult;
    }

    // 3. Steps check
    final stepsResult = _checkSteps(data);
    if (!stepsResult.isValid) {
      _stepsOk = false;
      _recordViolation();
      _lastResult = stepsResult;
      notifyListeners();
      return stepsResult;
    }

    // 4. GPS accuracy check
    final gpsResult = _checkGPSAccuracy(data);
    if (!gpsResult.isValid) {
      _gpsOk = false;
      _recordViolation();
      _lastResult = gpsResult;
      notifyListeners();
      return gpsResult;
    }

    // 5. Teleport check
    final teleportResult = _checkTeleport(data);
    if (!teleportResult.isValid) {
      _recordViolation();
      _lastResult = teleportResult;
      notifyListeners();
      return teleportResult;
    }

    // All checks passed - add to history
    _addToHistory(data);
    _resetViolations();

    _lastResult = AntiCheatResult(
      status: CheatStatus.valid,
      message: 'All checks passed',
      confidence: 0.92,
      details: {
        'speed': data.speedKmh,
        'activity': data.activityType.label,
        'steps': data.stepsPerMin,
        'accuracy': data.position.accuracy,
      },
    );

    notifyListeners();
    return _lastResult!;
  }

  AntiCheatResult _checkSpeed(GPSData data) {
    final speedMs = data.position.speed;
    final speedKmh = speedMs * 3.6;

    if (speedMs > AntiCheatConfig.maxRunningSpeedMs) {
      return AntiCheatResult(
        status: CheatStatus.speedTooHigh,
        message: 'Speed too high: ${speedKmh.toStringAsFixed(1)} km/h\nMax allowed: ${AntiCheatConfig.maxSpeedKmh} km/h',
        confidence: min(1.0, speedMs / AntiCheatConfig.maxRunningSpeedMs),
        details: {'speed': speedKmh, 'limit': AntiCheatConfig.maxSpeedKmh},
      );
    }

    return AntiCheatResult(status: CheatStatus.valid, message: 'Speed OK');
  }

  AntiCheatResult _checkActivity(GPSData data) {
    if (data.activityType == ActivityType.inVehicle) {
      return AntiCheatResult(
        status: CheatStatus.vehicleDetected,
        message: 'Vehicle activity detected!\nOnly walking/running allowed',
        confidence: 0.95,
        details: {'activity': 'IN_VEHICLE'},
      );
    }

    if (data.activityType == ActivityType.onBicycle) {
      return AntiCheatResult(
        status: CheatStatus.vehicleDetected,
        message: 'Bicycle activity detected!\nOnly walking/running allowed',
        confidence: 0.90,
        details: {'activity': 'ON_BICYCLE'},
      );
    }

    return AntiCheatResult(status: CheatStatus.valid, message: 'Activity OK');
  }

  AntiCheatResult _checkSteps(GPSData data) {
    // Skip step check if standing still
    if (data.activityType == ActivityType.still) {
      return AntiCheatResult(status: CheatStatus.valid, message: 'Standing still');
    }

    final minSteps = data.activityType == ActivityType.running
        ? AntiCheatConfig.minStepsPerMinRunning
        : AntiCheatConfig.minStepsPerMinWalking;

    if (data.stepsPerMin < minSteps && data.position.speed > 1.0) {
      return AntiCheatResult(
        status: CheatStatus.stepsLow,
        message: 'Steps too low: ${data.stepsPerMin}/min\nExpected: $minSteps+/min while moving',
        confidence: 0.85,
        details: {
          'steps': data.stepsPerMin,
          'minRequired': minSteps,
          'speed': data.speedKmh
        },
      );
    }

    return AntiCheatResult(status: CheatStatus.valid, message: 'Steps OK');
  }

  AntiCheatResult _checkGPSAccuracy(GPSData data) {
    if (data.position.accuracy > AntiCheatConfig.maxAccuracyMeters) {
      return AntiCheatResult(
        status: CheatStatus.gpsAccuracyLow,
        message: 'GPS accuracy too low: ${data.position.accuracy.toStringAsFixed(0)}m\nMove to open area',
        confidence: 0.70,
        details: {
          'accuracy': data.position.accuracy,
          'maxAllowed': AntiCheatConfig.maxAccuracyMeters
        },
      );
    }

    return AntiCheatResult(status: CheatStatus.valid, message: 'GPS OK');
  }

  AntiCheatResult _checkTeleport(GPSData data) {
    if (_locationHistory.isEmpty) {
      return AntiCheatResult(status: CheatStatus.valid, message: 'First location');
    }

    // Check against recent locations
    for (final history in _locationHistory.reversed.take(5)) {
      final timeDiff =
          data.timestamp.difference(history.timestamp).inSeconds.abs();
      if (timeDiff == 0) continue;

      final distance = _calculateDistance(
        data.latitude,
        data.longitude,
        history.latitude,
        history.longitude,
      );

      final speedMs = distance / timeDiff;

      if (speedMs > AntiCheatConfig.maxDistancePerSecond) {
        return AntiCheatResult(
          status: CheatStatus.teleportDetected,
          message: 'Teleport detected!\nMoved ${distance.toStringAsFixed(0)}m in ${timeDiff}s',
          confidence: 0.98,
          details: {
            'distance': distance,
            'timeDiff': timeDiff,
            'impliedSpeed': speedMs * 3.6
          },
        );
      }
    }

    return AntiCheatResult(status: CheatStatus.valid, message: 'No teleport');
  }

  void _addToHistory(GPSData data) {
    _locationHistory.add(_LocationHistory(
      latitude: data.latitude,
      longitude: data.longitude,
      timestamp: data.timestamp,
    ));

    // Keep only last 20 entries
    while (_locationHistory.length > 20) {
      _locationHistory.removeAt(0);
    }
  }

  void _recordViolation() {
    _violationCount++;

    if (_violationCount >= AntiCheatConfig.maxViolations) {
      _suspendedUntil = DateTime.now().add(
        Duration(minutes: AntiCheatConfig.suspensionMinutes),
      );
      debugPrint('Account suspended until $_suspendedUntil');
    }
  }

  void _resetViolations() {
    if (_violationCount > 0) {
      _violationCount--;
    }
  }

  /// Calculate distance between two coordinates (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const R = 6371000.0; // Earth radius in meters
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  /// Clear suspension (for testing)
  void clearSuspension() {
    _suspendedUntil = null;
    _violationCount = 0;
    notifyListeners();
  }

  /// Reset all anti-cheat data
  void reset() {
    _violationCount = 0;
    _suspendedUntil = null;
    _locationHistory.clear();
    _lastResult = null;
    _speedOk = true;
    _activityOk = true;
    _stepsOk = true;
    _gpsOk = true;
    notifyListeners();
  }
}

class _LocationHistory {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  _LocationHistory({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}
