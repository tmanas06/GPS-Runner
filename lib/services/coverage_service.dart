import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'auth_service.dart';

/// A player's coverage point on the map
class CoveragePoint {
  final String id;
  final String odId;
  final String playerName;
  final String playerColor;
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final DateTime timestamp;
  final double? distanceMeters;

  CoveragePoint({
    required this.id,
    required this.odId,
    required this.playerName,
    required this.playerColor,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.timestamp,
    this.distanceMeters,
  });

  LatLng get location => LatLng(latitude, longitude);

  factory CoveragePoint.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoveragePoint(
      id: doc.id,
      odId: data['odId'] ?? '',
      playerName: data['playerName'] ?? 'Unknown',
      playerColor: data['playerColor'] ?? '#2196F3',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      distanceMeters: data['distanceMeters']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'odId': odId,
    'playerName': playerName,
    'playerColor': playerColor,
    'latitude': latitude,
    'longitude': longitude,
    'city': city,
    'state': state,
    'timestamp': FieldValue.serverTimestamp(),
    'distanceMeters': distanceMeters,
    'geohash': _generateGeohash(latitude, longitude),
  };

  /// Simple geohash for proximity queries (precision ~1km)
  static String _generateGeohash(double lat, double lng) {
    final latBucket = (lat * 100).round();
    final lngBucket = (lng * 100).round();
    return '${latBucket}_$lngBucket';
  }
}

/// Nearby player info for display
class NearbyPlayer {
  final String odId;
  final String name;
  final String color;
  final LatLng lastLocation;
  final double distanceMeters;
  final DateTime lastSeen;
  final String city;
  final double totalDistanceWalked;
  final int coveragePoints;

  NearbyPlayer({
    required this.odId,
    required this.name,
    required this.color,
    required this.lastLocation,
    required this.distanceMeters,
    required this.lastSeen,
    required this.city,
    this.totalDistanceWalked = 0,
    this.coveragePoints = 0,
  });

  bool get isActive => DateTime.now().difference(lastSeen).inMinutes < 15;
  bool get isRecent => DateTime.now().difference(lastSeen).inHours < 24;
}

/// Service for sharing and viewing player coverage across the network
class CoverageService extends ChangeNotifier {
  static final CoverageService _instance = CoverageService._internal();
  factory CoverageService() => _instance;
  CoverageService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  static const String _coverageCollection = 'player_coverage';
  static const String _playersCollection = 'active_players';
  static const Duration _updateInterval = Duration(seconds: 30);
  static const double _nearbyRadiusMeters = 5000; // 5km

  Timer? _updateTimer;
  bool _isInitialized = false;
  String? _currentCity;
  LatLng? _currentLocation;

  // Cached data
  List<CoveragePoint> _allCoverage = [];
  List<NearbyPlayer> _nearbyPlayers = [];
  Map<String, List<CoveragePoint>> _coverageByPlayer = {};

  // Getters
  bool get isInitialized => _isInitialized;
  List<CoveragePoint> get allCoverage => _allCoverage;
  List<NearbyPlayer> get nearbyPlayers => _nearbyPlayers;
  Map<String, List<CoveragePoint>> get coverageByPlayer => _coverageByPlayer;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = true;
      debugPrint('CoverageService: Initialized');
      notifyListeners();
    } catch (e) {
      debugPrint('CoverageService: Initialization error: $e');
    }
  }

  /// Start tracking and sharing coverage for a city
  Future<void> startTracking(String city, String state) async {
    _currentCity = city;
    await _updatePlayerPresence(city, state);

    // Start periodic updates
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(_updateInterval, (_) {
      if (_currentLocation != null && _currentCity != null) {
        _updatePlayerPresence(_currentCity!, state);
      }
    });

    // Load coverage for this city
    await loadCityCoverage(city);
  }

  /// Stop tracking
  void stopTracking() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  /// Update current location and save coverage point
  Future<void> updateLocation(double lat, double lng, String city, String state, {double? distanceMeters}) async {
    final user = _authService.profile;
    if (user == null) return;

    _currentLocation = LatLng(lat, lng);
    _currentCity = city;

    try {
      // Check if we should save this point (avoid duplicates within 50m)
      final shouldSave = await _shouldSavePoint(lat, lng, user.id);
      if (!shouldSave) return;

      // Save coverage point
      final point = CoveragePoint(
        id: '',
        odId: user.id,
        playerName: user.name,
        playerColor: user.color,
        latitude: lat,
        longitude: lng,
        city: city.toLowerCase(),
        state: state.toLowerCase(),
        timestamp: DateTime.now(),
        distanceMeters: distanceMeters,
      );

      await _firestore.collection(_coverageCollection).add(point.toFirestore());
      debugPrint('CoverageService: Saved coverage point');
    } catch (e) {
      debugPrint('CoverageService: Error saving coverage: $e');
    }
  }

  /// Check if we should save a new point (avoid too many duplicates)
  Future<bool> _shouldSavePoint(double lat, double lng, String odId) async {
    try {
      // Check for recent points from this user nearby
      final geohash = CoveragePoint._generateGeohash(lat, lng);
      final recentPoints = await _firestore
          .collection(_coverageCollection)
          .where('odId', isEqualTo: odId)
          .where('geohash', isEqualTo: geohash)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (recentPoints.docs.isEmpty) return true;

      final lastPoint = CoveragePoint.fromFirestore(recentPoints.docs.first);
      final timeDiff = DateTime.now().difference(lastPoint.timestamp);

      // Save if last point was more than 30 seconds ago
      return timeDiff.inSeconds > 30;
    } catch (e) {
      // If query fails, save anyway
      return true;
    }
  }

  /// Update player presence (for showing online players)
  Future<void> _updatePlayerPresence(String city, String state) async {
    final user = _authService.profile;
    if (user == null || _currentLocation == null) return;

    try {
      await _firestore.collection(_playersCollection).doc(user.id).set({
        'odId': user.id,
        'name': user.name,
        'color': user.color,
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
        'city': city.toLowerCase(),
        'state': state.toLowerCase(),
        'lastSeen': FieldValue.serverTimestamp(),
        'geohash': CoveragePoint._generateGeohash(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
        ),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('CoverageService: Error updating presence: $e');
    }
  }

  /// Load all coverage for a city
  Future<void> loadCityCoverage(String city) async {
    try {
      final snapshot = await _firestore
          .collection(_coverageCollection)
          .where('city', isEqualTo: city.toLowerCase())
          .orderBy('timestamp', descending: true)
          .limit(1000) // Limit for performance
          .get();

      _allCoverage = snapshot.docs
          .map((doc) => CoveragePoint.fromFirestore(doc))
          .toList();

      // Group by player
      _coverageByPlayer = {};
      for (final point in _allCoverage) {
        _coverageByPlayer.putIfAbsent(point.odId, () => []).add(point);
      }

      notifyListeners();
      debugPrint('CoverageService: Loaded ${_allCoverage.length} coverage points for $city');
    } catch (e) {
      debugPrint('CoverageService: Error loading coverage: $e');
    }
  }

  /// Watch coverage updates for a city in real-time
  Stream<List<CoveragePoint>> watchCityCoverage(String city) {
    return _firestore
        .collection(_coverageCollection)
        .where('city', isEqualTo: city.toLowerCase())
        .orderBy('timestamp', descending: true)
        .limit(500)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CoveragePoint.fromFirestore(doc))
          .toList();
    });
  }

  /// Load nearby players
  Future<List<NearbyPlayer>> loadNearbyPlayers() async {
    if (_currentLocation == null) return [];

    try {
      final geohash = CoveragePoint._generateGeohash(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );

      // Get players with same geohash (within ~1km)
      // Also get adjacent geohashes for better coverage
      final adjacentHashes = _getAdjacentGeohashes(geohash);

      final snapshot = await _firestore
          .collection(_playersCollection)
          .where('geohash', whereIn: adjacentHashes)
          .get();

      final currentUserId = _authService.profile?.id;
      const distance = Distance();

      _nearbyPlayers = snapshot.docs
          .map((doc) {
            final data = doc.data();
            final playerLoc = LatLng(
              (data['latitude'] ?? 0).toDouble(),
              (data['longitude'] ?? 0).toDouble(),
            );
            final dist = distance.as(LengthUnit.Meter, _currentLocation!, playerLoc);

            return NearbyPlayer(
              odId: data['odId'] ?? doc.id,
              name: data['name'] ?? 'Unknown',
              color: data['color'] ?? '#2196F3',
              lastLocation: playerLoc,
              distanceMeters: dist,
              lastSeen: (data['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
              city: data['city'] ?? '',
              totalDistanceWalked: (data['totalDistance'] ?? 0).toDouble(),
              coveragePoints: _coverageByPlayer[data['odId']]?.length ?? 0,
            );
          })
          .where((p) => p.odId != currentUserId) // Exclude self
          .where((p) => p.distanceMeters <= _nearbyRadiusMeters)
          .toList()
        ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

      notifyListeners();
      return _nearbyPlayers;
    } catch (e) {
      debugPrint('CoverageService: Error loading nearby players: $e');
      return [];
    }
  }

  /// Watch nearby players in real-time
  Stream<List<NearbyPlayer>> watchNearbyPlayers() {
    if (_currentLocation == null) {
      return Stream.value([]);
    }

    final geohash = CoveragePoint._generateGeohash(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
    );
    final adjacentHashes = _getAdjacentGeohashes(geohash);

    return _firestore
        .collection(_playersCollection)
        .where('geohash', whereIn: adjacentHashes)
        .snapshots()
        .map((snapshot) {
      final currentUserId = _authService.profile?.id;
      const distance = Distance();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            final playerLoc = LatLng(
              (data['latitude'] ?? 0).toDouble(),
              (data['longitude'] ?? 0).toDouble(),
            );
            final dist = _currentLocation != null
                ? distance.as(LengthUnit.Meter, _currentLocation!, playerLoc)
                : 0.0;

            return NearbyPlayer(
              odId: data['odId'] ?? doc.id,
              name: data['name'] ?? 'Unknown',
              color: data['color'] ?? '#2196F3',
              lastLocation: playerLoc,
              distanceMeters: dist,
              lastSeen: (data['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
              city: data['city'] ?? '',
            );
          })
          .where((p) => p.odId != currentUserId)
          .where((p) => p.distanceMeters <= _nearbyRadiusMeters)
          .toList()
        ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    });
  }

  /// Get adjacent geohashes for broader area coverage
  List<String> _getAdjacentGeohashes(String geohash) {
    final parts = geohash.split('_');
    if (parts.length != 2) return [geohash];

    final lat = int.tryParse(parts[0]) ?? 0;
    final lng = int.tryParse(parts[1]) ?? 0;

    return [
      geohash,
      '${lat - 1}_${lng - 1}',
      '${lat - 1}_$lng',
      '${lat - 1}_${lng + 1}',
      '${lat}_${lng - 1}',
      '${lat}_${lng + 1}',
      '${lat + 1}_${lng - 1}',
      '${lat + 1}_$lng',
      '${lat + 1}_${lng + 1}',
    ];
  }

  /// Get coverage stats for a player
  Future<Map<String, dynamic>> getPlayerStats(String odId) async {
    try {
      final coverageSnapshot = await _firestore
          .collection(_coverageCollection)
          .where('odId', isEqualTo: odId)
          .get();

      final points = coverageSnapshot.docs
          .map((doc) => CoveragePoint.fromFirestore(doc))
          .toList();

      // Calculate total distance
      double totalDistance = 0;
      for (final point in points) {
        if (point.distanceMeters != null) {
          totalDistance += point.distanceMeters!;
        }
      }

      // Get unique cities
      final cities = points.map((p) => p.city).toSet();

      return {
        'totalPoints': points.length,
        'totalDistance': totalDistance,
        'citiesVisited': cities.length,
        'cities': cities.toList(),
      };
    } catch (e) {
      debugPrint('CoverageService: Error getting player stats: $e');
      return {};
    }
  }

  /// Get player coverage trail (for drawing on map)
  List<LatLng> getPlayerTrail(String odId) {
    final points = _coverageByPlayer[odId] ?? [];
    return points.map((p) => p.location).toList();
  }

  /// Get all unique players with coverage in current area
  List<String> get playersWithCoverage => _coverageByPlayer.keys.toList();

  /// Clear cache and unsubscribe
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
