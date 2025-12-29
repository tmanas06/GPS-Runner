import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/marker.dart';
import '../models/gps_proof.dart';

/// Database service using SharedPreferences for local persistence
class IsarDBService extends ChangeNotifier {
  static final IsarDBService _instance = IsarDBService._internal();
  factory IsarDBService() => _instance;
  IsarDBService._internal();

  static const String _markersKey = 'gps_markers';
  static const String _idCounterKey = 'marker_id_counter';
  static const String _collectedCoinsKey = 'collected_coins';

  SharedPreferences? _prefs;
  bool _isInitialized = false;
  List<GPSMarker> _markers = [];
  int _idCounter = 0;

  // Offline queue for sync
  final List<OfflineProof> _offlineQueue = [];
  Timer? _syncTimer;

  // Getters
  bool get isInitialized => _isInitialized;
  int get offlineQueueSize => _offlineQueue.length;

  /// Initialize database
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadMarkers();
      _idCounter = _prefs!.getInt(_idCounterKey) ?? 0;
      _isInitialized = true;

      // Start sync timer
      _startSyncTimer();

      debugPrint('Database initialized with ${_markers.length} markers');
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _loadMarkers() async {
    final json = _prefs?.getString(_markersKey);
    if (json != null && json.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(json);
        _markers = list.map((e) => GPSMarker.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Error loading markers: $e');
        _markers = [];
      }
    }
  }

  Future<void> _saveMarkers() async {
    if (_prefs == null) return;
    final json = jsonEncode(_markers.map((m) => m.toJson()).toList());
    await _prefs!.setString(_markersKey, json);
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _processOfflineQueue(),
    );
  }

  /// Save marker to local database
  Future<int> saveMarker(GPSMarker marker) async {
    if (!_isInitialized || _prefs == null) {
      throw Exception('Database not initialized');
    }

    _idCounter++;
    marker.id = _idCounter;
    await _prefs!.setInt(_idCounterKey, _idCounter);

    _markers.add(marker);
    await _saveMarkers();
    notifyListeners();

    return marker.id;
  }

  /// Save multiple markers
  Future<void> saveMarkers(List<GPSMarker> markers) async {
    if (!_isInitialized || _prefs == null) return;

    for (final marker in markers) {
      _idCounter++;
      marker.id = _idCounter;
      _markers.add(marker);
    }

    await _prefs!.setInt(_idCounterKey, _idCounter);
    await _saveMarkers();
    notifyListeners();
  }

  /// Get all markers for a player
  Future<List<GPSMarker>> getPlayerMarkers(String playerId) async {
    if (!_isInitialized) return [];

    return _markers
        .where((m) => m.playerId == playerId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get markers by city
  Future<List<GPSMarker>> getCityMarkers(String city) async {
    if (!_isInitialized) return [];

    return _markers.where((m) => m.city == city).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get markers not synced to blockchain
  Future<List<GPSMarker>> getUnsyncedMarkers() async {
    if (!_isInitialized) return [];

    return _markers.where((m) => !m.syncedToChain).toList();
  }

  /// Mark marker as synced
  Future<void> markSynced(int markerId, String txHash) async {
    if (!_isInitialized) return;

    final index = _markers.indexWhere((m) => m.id == markerId);
    if (index != -1) {
      _markers[index].syncedToChain = true;
      _markers[index].txHash = txHash;
      await _saveMarkers();
      notifyListeners();
    }
  }

  /// Get marker count by player and city
  Future<int> getMarkerCount(String playerId, {String? city}) async {
    if (!_isInitialized) return 0;

    var filtered = _markers.where((m) => m.playerId == playerId);
    if (city != null) {
      filtered = filtered.where((m) => m.city == city);
    }
    return filtered.length;
  }

  /// Get recent markers (last 24 hours)
  Future<List<GPSMarker>> getRecentMarkers({int hours = 24}) async {
    if (!_isInitialized) return [];

    final cutoff =
        DateTime.now().subtract(Duration(hours: hours)).millisecondsSinceEpoch;

    return _markers.where((m) => m.timestamp > cutoff).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get leaderboard for a city
  Future<List<MapEntry<String, int>>> getLeaderboard(String city,
      {int limit = 10}) async {
    if (!_isInitialized) return [];

    final cityMarkers = _markers.where((m) => m.city == city);

    // Count markers per player
    final counts = <String, int>{};
    for (final marker in cityMarkers) {
      counts[marker.playerName] = (counts[marker.playerName] ?? 0) + 1;
    }

    // Sort by count
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).toList();
  }

  /// Add proof to offline queue
  void addToOfflineQueue(GPSProof proof) {
    _offlineQueue.add(OfflineProof(proof: proof));
    notifyListeners();
    debugPrint(
        'Added proof to offline queue. Queue size: ${_offlineQueue.length}');
  }

  /// Process offline queue
  Future<void> _processOfflineQueue() async {
    if (_offlineQueue.isEmpty) return;

    debugPrint('Processing offline queue: ${_offlineQueue.length} items');

    final toRemove = <OfflineProof>[];

    for (final item in _offlineQueue) {
      if (!item.shouldRetry) {
        toRemove.add(item);
        continue;
      }

      // Try to sync (would call blockchain service here)
      // For now, just mark for removal
      toRemove.add(item);
    }

    for (final item in toRemove) {
      _offlineQueue.remove(item);
    }

    notifyListeners();
  }

  /// Force sync all offline items
  Future<void> forceSyncOffline() async {
    await _processOfflineQueue();
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAll() async {
    if (!_isInitialized || _prefs == null) return;

    _markers.clear();
    await _prefs!.remove(_markersKey);
    await _prefs!.remove(_idCounterKey);
    _idCounter = 0;

    _offlineQueue.clear();
    notifyListeners();
  }

  /// Delete specific marker
  Future<bool> deleteMarker(int id) async {
    if (!_isInitialized) return false;

    final index = _markers.indexWhere((m) => m.id == id);
    if (index != -1) {
      _markers.removeAt(index);
      await _saveMarkers();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Watch markers stream
  Stream<List<GPSMarker>> watchMarkers({String? city}) {
    // Return a stream that emits current markers
    // For real-time updates, this would be enhanced with StreamController
    return Stream.periodic(const Duration(seconds: 1), (_) {
      if (city != null) {
        return _markers.where((m) => m.city == city).toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      return List.from(_markers)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  /// Get collected coins
  Future<Map<String, int>> getCollectedCoins() async {
    if (!_isInitialized || _prefs == null) return {};

    final json = _prefs!.getString(_collectedCoinsKey);
    if (json != null && json.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        return data.map((key, value) => MapEntry(key, value as int));
      } catch (e) {
        debugPrint('Error loading collected coins: $e');
      }
    }
    return {};
  }

  /// Add collected coin
  Future<void> addCollectedCoin(String coinSymbol, int amount) async {
    if (!_isInitialized || _prefs == null) return;

    final coins = await getCollectedCoins();
    coins[coinSymbol] = (coins[coinSymbol] ?? 0) + amount;

    final json = jsonEncode(coins);
    await _prefs!.setString(_collectedCoinsKey, json);
    notifyListeners();
  }

  /// Set collected coins (replace all)
  Future<void> setCollectedCoins(Map<String, int> coins) async {
    if (!_isInitialized || _prefs == null) return;

    final json = jsonEncode(coins);
    await _prefs!.setString(_collectedCoinsKey, json);
    notifyListeners();
  }

  /// Get database stats
  Future<Map<String, dynamic>> getStats() async {
    if (!_isInitialized) {
      return {'error': 'Not initialized'};
    }

    final totalMarkers = _markers.length;
    final delhiMarkers = _markers.where((m) => m.city == 'delhi').length;
    final hydMarkers = _markers.where((m) => m.city == 'hyderabad').length;
    final unsyncedMarkers = _markers.where((m) => !m.syncedToChain).length;

    return {
      'totalMarkers': totalMarkers,
      'delhiMarkers': delhiMarkers,
      'hydMarkers': hydMarkers,
      'unsyncedMarkers': unsyncedMarkers,
      'offlineQueue': _offlineQueue.length,
    };
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
