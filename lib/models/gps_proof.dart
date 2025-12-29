import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Activity types for anti-cheat verification
enum ActivityType {
  onFoot(0, 'On Foot'),
  walking(1, 'Walking'),
  running(2, 'Running'),
  onBicycle(3, 'On Bicycle'),
  inVehicle(4, 'In Vehicle'),
  still(5, 'Still'),
  unknown(6, 'Unknown');

  final int code;
  final String label;
  const ActivityType(this.code, this.label);

  static ActivityType fromCode(int code) {
    return ActivityType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ActivityType.unknown,
    );
  }

  bool get isValidForRun => this == onFoot || this == walking || this == running;
}

/// GPS proof structure for blockchain submission
class GPSProof {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final double speed; // m/s
  final double speedKmh; // km/h
  final int stepsPerMin;
  final ActivityType activityType;
  final int timestamp;
  final String playerId;
  final String city;
  final String? landmarkName;
  late final String signature;

  GPSProof({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    required this.speed,
    required this.stepsPerMin,
    required this.activityType,
    required this.timestamp,
    required this.playerId,
    required this.city,
    this.landmarkName,
  }) : speedKmh = speed * 3.6 {
    signature = _generateSignature();
  }

  /// Convert latitude to 1e6 integer for blockchain
  int get lat1e6 => (latitude * 1e6).round();

  /// Convert longitude to 1e6 integer for blockchain
  int get lng1e6 => (longitude * 1e6).round();

  /// Speed in km/h as integer for blockchain
  int get speedInt => speedKmh.round();

  String _generateSignature() {
    final data = '$lat1e6:$lng1e6:$timestamp:$playerId:${activityType.code}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Validate proof for anti-cheat
  bool get isValid {
    // Speed check: max 8 m/s (28.8 km/h) for running
    if (speed > 8) return false;
    // Activity check: must be on foot
    if (!activityType.isValidForRun) return false;
    // Steps check: minimum 40 steps/min for walking
    if (stepsPerMin < 40 && activityType != ActivityType.still) return false;
    // Accuracy check: must be reasonably accurate
    if (accuracy > 50) return false;
    return true;
  }

  /// Get rejection reason if invalid
  String? get rejectionReason {
    if (speed > 8) return 'Speed too high (${speedKmh.toStringAsFixed(1)} km/h) - Vehicle detected!';
    if (!activityType.isValidForRun) return 'Activity "${activityType.label}" not allowed - Walking/Running only!';
    if (stepsPerMin < 40 && activityType != ActivityType.still) {
      return 'Steps too low ($stepsPerMin/min) - Are you in a vehicle?';
    }
    if (accuracy > 50) return 'GPS accuracy too low (${accuracy.toStringAsFixed(0)}m) - Move to open area';
    return null;
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'lat1e6': lat1e6,
        'lng1e6': lng1e6,
        'altitude': altitude,
        'accuracy': accuracy,
        'speed': speed,
        'speedKmh': speedKmh,
        'stepsPerMin': stepsPerMin,
        'activityType': activityType.code,
        'timestamp': timestamp,
        'playerId': playerId,
        'city': city,
        'landmarkName': landmarkName,
        'signature': signature,
      };

  factory GPSProof.fromJson(Map<String, dynamic> json) {
    return GPSProof(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      altitude: (json['altitude'] ?? 0).toDouble(),
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      speed: (json['speed'] ?? 0).toDouble(),
      stepsPerMin: json['stepsPerMin'] ?? 0,
      activityType: ActivityType.fromCode(json['activityType'] ?? 6),
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      playerId: json['playerId'] ?? '',
      city: json['city'] ?? 'delhi',
      landmarkName: json['landmarkName'],
    );
  }
}

/// Offline proof queue item for sync
class OfflineProof {
  final GPSProof proof;
  final int retryCount;
  final int createdAt;

  OfflineProof({
    required this.proof,
    this.retryCount = 0,
  }) : createdAt = DateTime.now().millisecondsSinceEpoch;

  OfflineProof copyWithRetry() => OfflineProof(
        proof: proof,
        retryCount: retryCount + 1,
      );

  bool get shouldRetry => retryCount < 5;
}
