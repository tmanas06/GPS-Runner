import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' hide ActivityType;
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart' as activity_recognition;
import 'package:pedometer/pedometer.dart';
import '../models/gps_proof.dart';
import '../models/city_bounds.dart';

/// GPS tracking state
enum GPSState {
  disabled,
  denied,
  deniedForever,
  ready,
  tracking,
  paused,
  error,
}

/// Current GPS data with activity info
class GPSData {
  final Position position;
  final ActivityType activityType;
  final int stepsPerMin;
  final CityConfig? city;
  final Landmark? nearestLandmark;
  final DateTime timestamp;

  GPSData({
    required this.position,
    required this.activityType,
    required this.stepsPerMin,
    this.city,
    this.nearestLandmark,
  }) : timestamp = DateTime.now();

  double get speedKmh => position.speed * 3.6;
  double get latitude => position.latitude;
  double get longitude => position.longitude;

  /// Check if current activity is valid for running
  bool get isValidActivity {
    if (!activityType.isValidForRun) return false;
    if (position.speed > 8) return false; // Max 8 m/s (28.8 km/h)
    if (stepsPerMin < 40 && activityType != ActivityType.still) return false;
    return true;
  }

  /// Convert to GPS proof for blockchain
  GPSProof toProof(String playerId) {
    return GPSProof(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
      speed: position.speed,
      stepsPerMin: stepsPerMin,
      activityType: activityType,
      timestamp: timestamp.millisecondsSinceEpoch,
      playerId: playerId,
      city: city?.id ?? 'unknown',
      landmarkName: nearestLandmark?.name,
    );
  }
}

/// GPS Service for tracking location and activity
class GPSService extends ChangeNotifier {
  static final GPSService _instance = GPSService._internal();
  factory GPSService() => _instance;
  GPSService._internal();

  GPSState _state = GPSState.disabled;
  GPSData? _currentData;
  String? _errorMessage;

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<activity_recognition.Activity>? _activitySubscription;
  StreamSubscription<StepCount>? _stepSubscription;

  final activity_recognition.FlutterActivityRecognition _activityRecognition =
      activity_recognition.FlutterActivityRecognition.instance;

  // Activity tracking
  ActivityType _currentActivity = ActivityType.unknown;
  int _stepsPerMin = 0;
  int _lastStepCount = 0;
  DateTime _lastStepTime = DateTime.now();

  // Callbacks
  final List<void Function(GPSData)> _onLocationCallbacks = [];
  final List<void Function(String)> _onLandmarkCallbacks = [];

  // Getters
  GPSState get state => _state;
  GPSData? get currentData => _currentData;
  String? get errorMessage => _errorMessage;
  ActivityType get currentActivity => _currentActivity;
  int get stepsPerMin => _stepsPerMin;
  bool get isTracking => _state == GPSState.tracking;
  CityConfig? get currentCity => _currentData?.city;

  /// Initialize GPS service and check permissions
  Future<void> initialize() async {
    _state = GPSState.disabled;
    notifyListeners();

    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _state = GPSState.disabled;
      _errorMessage = 'Location services are disabled';
      notifyListeners();
      return;
    }

    // Check permissions
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _state = GPSState.denied;
        _errorMessage = 'Location permission denied';
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _state = GPSState.deniedForever;
      _errorMessage = 'Location permission permanently denied';
      notifyListeners();
      return;
    }

    // Check activity recognition permission
    try {
      final activityPermission =
          await _activityRecognition.checkPermission();
      if (activityPermission == activity_recognition.ActivityPermission.DENIED) {
        await _activityRecognition.requestPermission();
      }
    } catch (e) {
      debugPrint('Activity recognition permission error: $e');
    }

    _state = GPSState.ready;
    _errorMessage = null;
    notifyListeners();
  }

  /// Start GPS tracking
  Future<void> startTracking() async {
    if (_state != GPSState.ready && _state != GPSState.paused) {
      await initialize();
      if (_state != GPSState.ready) return;
    }

    _state = GPSState.tracking;
    notifyListeners();

    // Start position stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPositionUpdate,
      onError: _onPositionError,
    );

    // Start activity recognition
    _activitySubscription = _activityRecognition.activityStream.listen(
      _onActivityUpdate,
      onError: (e) => debugPrint('Activity error: $e'),
    );

    // Start pedometer
    _stepSubscription = Pedometer.stepCountStream.listen(
      _onStepUpdate,
      onError: (e) => debugPrint('Pedometer error: $e'),
    );

    debugPrint('GPS tracking started');
  }

  /// Stop GPS tracking
  Future<void> stopTracking() async {
    _positionSubscription?.cancel();
    _activitySubscription?.cancel();
    _stepSubscription?.cancel();

    _positionSubscription = null;
    _activitySubscription = null;
    _stepSubscription = null;

    _state = GPSState.paused;
    notifyListeners();
    debugPrint('GPS tracking stopped');
  }

  /// Pause tracking temporarily
  void pauseTracking() {
    _positionSubscription?.pause();
    _activitySubscription?.pause();
    _state = GPSState.paused;
    notifyListeners();
  }

  /// Resume tracking
  void resumeTracking() {
    _positionSubscription?.resume();
    _activitySubscription?.resume();
    _state = GPSState.tracking;
    notifyListeners();
  }

  /// Add callback for location updates
  void addLocationCallback(void Function(GPSData) callback) {
    _onLocationCallbacks.add(callback);
  }

  /// Remove location callback
  void removeLocationCallback(void Function(GPSData) callback) {
    _onLocationCallbacks.remove(callback);
  }

  /// Add callback for landmark detection
  void addLandmarkCallback(void Function(String) callback) {
    _onLandmarkCallbacks.add(callback);
  }

  /// Remove landmark callback
  void removeLandmarkCallback(void Function(String) callback) {
    _onLandmarkCallbacks.remove(callback);
  }

  void _onPositionUpdate(Position position) {
    // Detect city
    final city = CityBounds.detect(position.latitude, position.longitude);

    // Detect nearest landmark
    final (_, landmark) =
        CityBounds.getNearestLandmark(position.latitude, position.longitude);

    // Create GPS data
    _currentData = GPSData(
      position: position,
      activityType: _currentActivity,
      stepsPerMin: _stepsPerMin,
      city: city,
      nearestLandmark: landmark,
    );

    // Notify callbacks
    for (final callback in _onLocationCallbacks) {
      callback(_currentData!);
    }

    // Check for landmark entry
    if (landmark != null && city != null) {
      final landmarkMsg = '${city.emoji} ${landmark.name}';
      for (final callback in _onLandmarkCallbacks) {
        callback(landmarkMsg);
      }
    }

    notifyListeners();
  }

  void _onPositionError(dynamic error) {
    _state = GPSState.error;
    _errorMessage = error.toString();
    notifyListeners();
    debugPrint('GPS error: $error');
  }

  void _onActivityUpdate(activity_recognition.Activity activity) {
    // Map flutter_activity_recognition to our ActivityType using name matching
    final typeName = activity.type.name.toUpperCase();
    switch (typeName) {
      case 'ON_FOOT':
        _currentActivity = ActivityType.onFoot;
        break;
      case 'WALKING':
        _currentActivity = ActivityType.walking;
        break;
      case 'RUNNING':
        _currentActivity = ActivityType.running;
        break;
      case 'ON_BICYCLE':
        _currentActivity = ActivityType.onBicycle;
        break;
      case 'IN_VEHICLE':
        _currentActivity = ActivityType.inVehicle;
        break;
      case 'STILL':
        _currentActivity = ActivityType.still;
        break;
      default:
        _currentActivity = ActivityType.unknown;
    }
    notifyListeners();
  }

  void _onStepUpdate(StepCount event) {
    final now = DateTime.now();
    final diff = now.difference(_lastStepTime).inSeconds;

    if (diff > 0 && _lastStepCount > 0) {
      final stepsDiff = event.steps - _lastStepCount;
      _stepsPerMin = ((stepsDiff / diff) * 60).round();
    }

    _lastStepCount = event.steps;
    _lastStepTime = now;
    notifyListeners();
  }

  /// Get current position once
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting position: $e');
      return null;
    }
  }

  /// Open location settings
  Future<void> openSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
