import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/marker.dart';
import '../models/gps_proof.dart';
import '../models/walking_session.dart';
import '../models/staked_marker.dart';

/// Database service using Isar for local persistence
class IsarDBService extends ChangeNotifier {
  static final IsarDBService _instance = IsarDBService._internal();
  factory IsarDBService() => _instance;
  IsarDBService._internal();

  Isar? _isar;
  bool _isInitialized = false;
  Timer? _syncTimer;

  // Getters
  bool get isInitialized => _isInitialized;
  Isar get isar => _isar!;

  /// Get offline queue size
  Future<int> get offlineQueueSize async {
    if (!_isInitialized) return 0;
    return await _isar!.offlineProofItems.count();
  }

  /// Initialize database
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          GPSMarkerSchema,
          WalkingSessionSchema,
          UserWalkingStatsSchema,
          CoveredAreaPointSchema,
          OfflineProofItemSchema,
          WeeklyLeaderboardEntrySchema,
          GameCoinBalanceSchema,
          CollectedCoinEventSchema,
        ],
        directory: dir.path,
      );
      _isInitialized = true;

      // Start sync timer
      _startSyncTimer();

      final markerCount = await _isar!.gPSMarkers.count();
      debugPrint('Database initialized with $markerCount markers');
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
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
    if (!_isInitialized) {
      throw Exception('Database not initialized');
    }

    await _isar!.writeTxn(() async {
      await _isar!.gPSMarkers.put(marker);
    });

    notifyListeners();
    return marker.id;
  }

  /// Save multiple markers
  Future<void> saveMarkers(List<GPSMarker> markers) async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      await _isar!.gPSMarkers.putAll(markers);
    });

    notifyListeners();
  }

  /// Get all markers for a player
  Future<List<GPSMarker>> getPlayerMarkers(String playerId) async {
    if (!_isInitialized) return [];

    return await _isar!.gPSMarkers
        .filter()
        .playerIdEqualTo(playerId)
        .sortByTimestampDesc()
        .findAll();
  }

  /// Get markers by city
  Future<List<GPSMarker>> getCityMarkers(String city) async {
    if (!_isInitialized) return [];

    return await _isar!.gPSMarkers
        .filter()
        .cityEqualTo(city)
        .sortByTimestampDesc()
        .findAll();
  }

  /// Get markers not synced to blockchain
  Future<List<GPSMarker>> getUnsyncedMarkers() async {
    if (!_isInitialized) return [];

    return await _isar!.gPSMarkers
        .filter()
        .syncedToChainEqualTo(false)
        .findAll();
  }

  /// Mark marker as synced
  Future<void> markSynced(int markerId, String txHash) async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      final marker = await _isar!.gPSMarkers.get(markerId);
      if (marker != null) {
        marker.syncedToChain = true;
        marker.txHash = txHash;
        await _isar!.gPSMarkers.put(marker);
      }
    });

    notifyListeners();
  }

  /// Get marker count by player and city
  Future<int> getMarkerCount(String playerId, {String? city}) async {
    if (!_isInitialized) return 0;

    var query = _isar!.gPSMarkers.filter().playerIdEqualTo(playerId);
    if (city != null) {
      query = query.cityEqualTo(city);
    }
    return await query.count();
  }

  /// Get recent markers (last 24 hours)
  Future<List<GPSMarker>> getRecentMarkers({int hours = 24}) async {
    if (!_isInitialized) return [];

    final cutoff =
        DateTime.now().subtract(Duration(hours: hours)).millisecondsSinceEpoch;

    return await _isar!.gPSMarkers
        .filter()
        .timestampGreaterThan(cutoff)
        .sortByTimestampDesc()
        .findAll();
  }

  /// Get leaderboard for a city
  Future<List<MapEntry<String, int>>> getLeaderboard(String city,
      {int limit = 10}) async {
    if (!_isInitialized) return [];

    final markers =
        await _isar!.gPSMarkers.filter().cityEqualTo(city).findAll();

    // Count markers per player
    final counts = <String, int>{};
    for (final marker in markers) {
      counts[marker.playerName] = (counts[marker.playerName] ?? 0) + 1;
    }

    // Sort by count
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).toList();
  }

  /// Add proof to offline queue
  Future<void> addToOfflineQueue(GPSProof proof) async {
    if (!_isInitialized) return;

    final item = OfflineProofItem()
      ..latitude = proof.latitude
      ..longitude = proof.longitude
      ..altitude = proof.altitude
      ..accuracy = proof.accuracy
      ..speed = proof.speed
      ..stepsPerMin = proof.stepsPerMin
      ..activityType = proof.activityType.code
      ..timestamp = proof.timestamp
      ..playerId = proof.playerId
      ..stateId = proof.stateId
      ..city = proof.city
      ..landmarkName = proof.landmarkName
      ..retryCount = 0
      ..createdAt = DateTime.now().millisecondsSinceEpoch;

    await _isar!.writeTxn(() async {
      await _isar!.offlineProofItems.put(item);
    });

    notifyListeners();
    final queueSize = await _isar!.offlineProofItems.count();
    debugPrint('Added proof to offline queue. Queue size: $queueSize');
  }

  /// Process offline queue in batches to prevent UI blocking
  Future<void> _processOfflineQueue() async {
    if (!_isInitialized) return;

    final items = await _isar!.offlineProofItems.where().findAll();
    if (items.isEmpty) return;

    debugPrint('Processing offline queue: ${items.length} items');

    // Process in batches of 10 to prevent UI blocking
    const batchSize = 10;
    final toRemove = <int>[];

    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.skip(i).take(batchSize).toList();
      
      for (final item in batch) {
        if (!item.shouldRetry) {
          toRemove.add(item.id);
          continue;
        }
        // Try to sync (would call blockchain service here)
        // For now, just mark for removal
        toRemove.add(item.id);
      }
      
      // Small delay between batches to keep UI responsive
      if (i + batchSize < items.length) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (toRemove.isNotEmpty) {
      await _isar!.writeTxn(() async {
        await _isar!.offlineProofItems.deleteAll(toRemove);
      });
    }

    notifyListeners();
  }

  /// Force sync all offline items
  Future<void> forceSyncOffline() async {
    await _processOfflineQueue();
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAll() async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      await _isar!.gPSMarkers.clear();
      await _isar!.walkingSessions.clear();
      await _isar!.userWalkingStats.clear();
      await _isar!.coveredAreaPoints.clear();
      await _isar!.offlineProofItems.clear();
    });

    notifyListeners();
  }

  /// Delete specific marker
  Future<bool> deleteMarker(int id) async {
    if (!_isInitialized) return false;

    bool deleted = false;
    await _isar!.writeTxn(() async {
      deleted = await _isar!.gPSMarkers.delete(id);
    });

    if (deleted) notifyListeners();
    return deleted;
  }

  /// Watch markers stream
  Stream<List<GPSMarker>> watchMarkers({String? city}) {
    if (!_isInitialized) {
      return Stream.value([]);
    }

    if (city != null) {
      return _isar!.gPSMarkers
          .filter()
          .cityEqualTo(city)
          .sortByTimestampDesc()
          .watch(fireImmediately: true);
    }

    return _isar!.gPSMarkers
        .where()
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  // ============ Game Coin Collection ============

  /// Initialize game coin balances for all chains
  Future<void> initializeGameCoins() async {
    if (!_isInitialized) return;

    final coins = [
      {'symbol': 'gMNT', 'chain': 'Mantle'},
      {'symbol': 'gPOL', 'chain': 'Polygon'},
      {'symbol': 'gBNB', 'chain': 'BNB'},
    ];

    await _isar!.writeTxn(() async {
      for (final coin in coins) {
        final existing = await _isar!.gameCoinBalances
            .filter()
            .coinSymbolEqualTo(coin['symbol']!)
            .findFirst();

        if (existing == null) {
          final balance = GameCoinBalance.create(
            coinSymbol: coin['symbol']!,
            chainName: coin['chain']!,
          );
          await _isar!.gameCoinBalances.put(balance);
        }
      }
    });
  }

  /// Get all game coin balances
  Future<Map<String, double>> getGameCoinBalances() async {
    if (!_isInitialized) return {};

    final balances = await _isar!.gameCoinBalances.where().findAll();
    return {for (var b in balances) b.coinSymbol: b.balance};
  }

  /// Get single coin balance
  Future<GameCoinBalance?> getGameCoinBalance(String coinSymbol) async {
    if (!_isInitialized) return null;

    return await _isar!.gameCoinBalances
        .filter()
        .coinSymbolEqualTo(coinSymbol)
        .findFirst();
  }

  /// Add collected coin to balance
  Future<void> addCollectedCoin(
    String coinSymbol,
    double amount, {
    double? latitude,
    double? longitude,
  }) async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      // Update balance
      var balance = await _isar!.gameCoinBalances
          .filter()
          .coinSymbolEqualTo(coinSymbol)
          .findFirst();

      if (balance == null) {
        // Create if doesn't exist
        final chainName = coinSymbol == 'gMNT'
            ? 'Mantle'
            : coinSymbol == 'gPOL'
                ? 'Polygon'
                : 'BNB';
        balance = GameCoinBalance.create(
          coinSymbol: coinSymbol,
          chainName: chainName,
        );
      }

      balance.balance += amount;
      balance.pendingClaim += amount;
      balance.lastUpdated = DateTime.now();
      await _isar!.gameCoinBalances.put(balance);

      // Record collection event
      if (latitude != null && longitude != null) {
        final event = CollectedCoinEvent.create(
          coinSymbol: coinSymbol,
          amount: amount,
          latitude: latitude,
          longitude: longitude,
        );
        await _isar!.collectedCoinEvents.put(event);
      }
    });

    notifyListeners();
  }

  /// Get unclaimed coins (pending to be minted on-chain)
  Future<Map<String, double>> getPendingClaimCoins() async {
    if (!_isInitialized) return {};

    final balances = await _isar!.gameCoinBalances.where().findAll();
    return {for (var b in balances) b.coinSymbol: b.pendingClaim};
  }

  /// Mark coins as claimed on-chain
  Future<void> markCoinsClaimed(String coinSymbol, double amount, String txHash) async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      final balance = await _isar!.gameCoinBalances
          .filter()
          .coinSymbolEqualTo(coinSymbol)
          .findFirst();

      if (balance != null) {
        balance.pendingClaim -= amount;
        if (balance.pendingClaim < 0) balance.pendingClaim = 0;
        balance.lastUpdated = DateTime.now();
        await _isar!.gameCoinBalances.put(balance);
      }

      // Update recent collection events
      final events = await _isar!.collectedCoinEvents
          .filter()
          .coinSymbolEqualTo(coinSymbol)
          .claimedOnChainEqualTo(false)
          .findAll();

      double remaining = amount;
      for (final event in events) {
        if (remaining <= 0) break;
        event.claimedOnChain = true;
        event.txHash = txHash;
        await _isar!.collectedCoinEvents.put(event);
        remaining -= event.amount;
      }
    });

    notifyListeners();
  }

  /// Get collection history
  Future<List<CollectedCoinEvent>> getCollectionHistory({
    String? coinSymbol,
    int limit = 50,
  }) async {
    if (!_isInitialized) return [];

    var query = _isar!.collectedCoinEvents.where();

    if (coinSymbol != null) {
      return await _isar!.collectedCoinEvents
          .filter()
          .coinSymbolEqualTo(coinSymbol)
          .sortByCollectedAtDesc()
          .limit(limit)
          .findAll();
    }

    return await query.sortByCollectedAtDesc().limit(limit).findAll();
  }

  /// Get total coins collected today
  Future<Map<String, double>> getTodayCollectedCoins() async {
    if (!_isInitialized) return {};

    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

    final events = await _isar!.collectedCoinEvents
        .filter()
        .collectedAtGreaterThan(todayStart)
        .findAll();

    final totals = <String, double>{};
    for (final event in events) {
      totals[event.coinSymbol] = (totals[event.coinSymbol] ?? 0) + event.amount;
    }
    return totals;
  }

  /// Get database stats
  Future<Map<String, dynamic>> getStats() async {
    if (!_isInitialized) {
      return {'error': 'Not initialized'};
    }

    final totalMarkers = await _isar!.gPSMarkers.count();
    final delhiMarkers =
        await _isar!.gPSMarkers.filter().cityEqualTo('delhi').count();
    final hydMarkers =
        await _isar!.gPSMarkers.filter().cityEqualTo('hyderabad').count();
    final unsyncedMarkers =
        await _isar!.gPSMarkers.filter().syncedToChainEqualTo(false).count();
    final offlineQueue = await _isar!.offlineProofItems.count();

    return {
      'totalMarkers': totalMarkers,
      'delhiMarkers': delhiMarkers,
      'hydMarkers': hydMarkers,
      'unsyncedMarkers': unsyncedMarkers,
      'offlineQueue': offlineQueue,
    };
  }

  // ============ Walking Sessions ============

  /// Start a new walking session
  Future<WalkingSession> startWalkingSession({
    required String city,
    required String state,
  }) async {
    final session = WalkingSession.start(city: city, state: state);

    await _isar!.writeTxn(() async {
      await _isar!.walkingSessions.put(session);
    });

    notifyListeners();
    return session;
  }

  /// Get current active session
  Future<WalkingSession?> getCurrentSession() async {
    if (!_isInitialized) return null;

    return await _isar!.walkingSessions
        .filter()
        .isActiveEqualTo(true)
        .findFirst();
  }

  /// Update current session with new track point
  Future<void> updateCurrentSession(WalkingSession session) async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      await _isar!.walkingSessions.put(session);
    });

    notifyListeners();
  }

  /// End current session and save to history
  Future<void> endCurrentSession(WalkingSession session) async {
    if (!_isInitialized) return;

    session.end();

    await _isar!.writeTxn(() async {
      await _isar!.walkingSessions.put(session);
    });

    // Update user stats
    await _updateUserStats(session);
    notifyListeners();
  }

  /// Get all walking sessions
  Future<List<WalkingSession>> getWalkingSessions() async {
    if (!_isInitialized) return [];

    return await _isar!.walkingSessions
        .where()
        .sortByStartTimeDesc()
        .findAll();
  }

  /// Get user walking stats
  Future<UserWalkingStats> getUserStats() async {
    if (!_isInitialized) return UserWalkingStats.empty();

    final stats = await _isar!.userWalkingStats.where().findFirst();
    return stats ?? UserWalkingStats.empty();
  }

  /// Update user stats with session data
  Future<void> _updateUserStats(WalkingSession session) async {
    if (!_isInitialized) return;

    var stats = await _isar!.userWalkingStats.where().findFirst();
    stats ??= UserWalkingStats.empty();

    stats.totalSessions++;
    stats.totalSteps += session.totalSteps;
    stats.totalDistanceMeters += session.totalDistanceMeters;
    stats.totalDurationSeconds += session.durationSeconds;

    if (session.maxSpeedKmh > stats.maxSpeedKmh) {
      stats.maxSpeedKmh = session.maxSpeedKmh;
    }

    // Update distance by city
    final cityDist = Map<String, double>.from(stats.distanceByCity);
    cityDist[session.city] =
        (cityDist[session.city] ?? 0) + session.totalDistanceMeters;
    stats.distanceByCity = cityDist;

    await _isar!.writeTxn(() async {
      await _isar!.userWalkingStats.put(stats!);
    });
  }

  /// Manually update user stats
  Future<void> setUserStats(UserWalkingStats stats) async {
    if (!_isInitialized) return;

    await _isar!.writeTxn(() async {
      await _isar!.userWalkingStats.put(stats);
    });

    notifyListeners();
  }

  // ============ Covered Areas ============

  /// Save covered area point
  Future<void> saveCoveredAreaPoint(double lat, double lng, String city) async {
    if (!_isInitialized) return;

    // Check for duplicates within ~10m
    final existing = await _isar!.coveredAreaPoints
        .filter()
        .cityEqualTo(city)
        .latitudeBetween(lat - 0.0001, lat + 0.0001)
        .longitudeBetween(lng - 0.0001, lng + 0.0001)
        .findFirst();

    if (existing == null) {
      final point = CoveredAreaPoint.create(
        city: city,
        latitude: lat,
        longitude: lng,
      );

      await _isar!.writeTxn(() async {
        await _isar!.coveredAreaPoints.put(point);
      });
    }
  }

  /// Get covered areas by city
  Future<Map<String, List<Map<String, dynamic>>>> getCoveredAreas() async {
    if (!_isInitialized) return {};

    final points = await _isar!.coveredAreaPoints.where().findAll();
    final result = <String, List<Map<String, dynamic>>>{};

    for (final point in points) {
      result.putIfAbsent(point.city, () => []);
      result[point.city]!.add({
        'lat': point.latitude,
        'lng': point.longitude,
        'timestamp': point.timestamp,
      });
    }

    return result;
  }

  /// Get covered area points for a specific city
  Future<List<Map<String, dynamic>>> getCityCoveredArea(String city) async {
    if (!_isInitialized) return [];

    final points = await _isar!.coveredAreaPoints
        .filter()
        .cityEqualTo(city)
        .findAll();

    return points
        .map((p) => {
              'lat': p.latitude,
              'lng': p.longitude,
              'timestamp': p.timestamp,
            })
        .toList();
  }

  /// Get total covered area stats
  Future<Map<String, int>> getCoveredAreaStats() async {
    if (!_isInitialized) return {};

    final points = await _isar!.coveredAreaPoints.where().findAll();
    final result = <String, int>{};

    for (final point in points) {
      result[point.city] = (result[point.city] ?? 0) + 1;
    }

    return result;
  }

  // ============ Weekly Leaderboard ============

  /// Initialize user on leaderboard with 0 stats (call on login/app start)
  Future<void> initializeUserOnLeaderboard({
    required String odId,
    required String playerName,
    required String playerColor,
    String city = 'global',
  }) async {
    if (!_isInitialized) return;

    final weekNumber = WeeklyLeaderboardEntry.getCurrentWeekNumber();

    // Check if entry exists for global
    final globalEntry = await _isar!.weeklyLeaderboardEntrys
        .filter()
        .odIdEqualTo(odId)
        .weekNumberEqualTo(weekNumber)
        .cityEqualTo('global')
        .findFirst();

    if (globalEntry == null) {
      final entry = WeeklyLeaderboardEntry.create(
        odId: odId,
        playerName: playerName,
        playerColor: playerColor,
        weekNumber: weekNumber,
        city: 'global',
      );

      await _isar!.writeTxn(() async {
        await _isar!.weeklyLeaderboardEntrys.put(entry);
      });

      await _recalculateRanks(weekNumber, 'global');
      debugPrint('Initialized user $playerName on global leaderboard');
    }

    // Also initialize for specific city if provided
    if (city != 'global') {
      final cityEntry = await _isar!.weeklyLeaderboardEntrys
          .filter()
          .odIdEqualTo(odId)
          .weekNumberEqualTo(weekNumber)
          .cityEqualTo(city)
          .findFirst();

      if (cityEntry == null) {
        final entry = WeeklyLeaderboardEntry.create(
          odId: odId,
          playerName: playerName,
          playerColor: playerColor,
          weekNumber: weekNumber,
          city: city,
        );

        await _isar!.writeTxn(() async {
          await _isar!.weeklyLeaderboardEntrys.put(entry);
        });

        await _recalculateRanks(weekNumber, city);
        debugPrint('Initialized user $playerName on $city leaderboard');
      }
    }

    notifyListeners();
  }

  /// Update or create weekly leaderboard entry for current user
  Future<void> updateWeeklyLeaderboard({
    required String odId,
    required String playerName,
    required String playerColor,
    required String city,
    required double distanceMeters,
    required int markerCount,
    required int steps,
    required double maxSpeed,
  }) async {
    if (!_isInitialized) return;

    final weekNumber = WeeklyLeaderboardEntry.getCurrentWeekNumber();

    // Update city-specific entry
    await _updateLeaderboardEntry(
      odId: odId,
      playerName: playerName,
      playerColor: playerColor,
      weekNumber: weekNumber,
      city: city,
      distanceMeters: distanceMeters,
      markerCount: markerCount,
      steps: steps,
      maxSpeed: maxSpeed,
    );

    // Update global entry
    await _updateLeaderboardEntry(
      odId: odId,
      playerName: playerName,
      playerColor: playerColor,
      weekNumber: weekNumber,
      city: 'global',
      distanceMeters: distanceMeters,
      markerCount: markerCount,
      steps: steps,
      maxSpeed: maxSpeed,
    );

    // Recalculate ranks
    await _recalculateRanks(weekNumber, city);
    await _recalculateRanks(weekNumber, 'global');

    notifyListeners();
  }

  Future<void> _updateLeaderboardEntry({
    required String odId,
    required String playerName,
    required String playerColor,
    required int weekNumber,
    required String city,
    required double distanceMeters,
    required int markerCount,
    required int steps,
    required double maxSpeed,
  }) async {
    // Find existing entry
    var entry = await _isar!.weeklyLeaderboardEntrys
        .filter()
        .odIdEqualTo(odId)
        .weekNumberEqualTo(weekNumber)
        .cityEqualTo(city)
        .findFirst();

    if (entry == null) {
      entry = WeeklyLeaderboardEntry.create(
        odId: odId,
        playerName: playerName,
        playerColor: playerColor,
        weekNumber: weekNumber,
        city: city,
      );
    }

    entry.distanceMeters += distanceMeters;
    entry.markerCount += markerCount;
    entry.totalSteps += steps;
    entry.sessionCount += 1;
    if (maxSpeed > entry.maxSpeedKmh) {
      entry.maxSpeedKmh = maxSpeed;
    }
    entry.updatedAt = DateTime.now();

    await _isar!.writeTxn(() async {
      await _isar!.weeklyLeaderboardEntrys.put(entry!);
    });
  }

  Future<void> _recalculateRanks(int weekNumber, String city) async {
    final entries = await _isar!.weeklyLeaderboardEntrys
        .filter()
        .weekNumberEqualTo(weekNumber)
        .cityEqualTo(city)
        .findAll();

    // Sort by distance descending
    entries.sort((a, b) => b.distanceMeters.compareTo(a.distanceMeters));

    // Assign ranks
    await _isar!.writeTxn(() async {
      for (int i = 0; i < entries.length; i++) {
        entries[i].rank = i + 1;
        await _isar!.weeklyLeaderboardEntrys.put(entries[i]);
      }
    });
  }

  /// Get weekly leaderboard for a city (or 'global')
  Future<List<WeeklyLeaderboardEntry>> getWeeklyLeaderboard({
    String city = 'global',
    int? weekNumber,
    int limit = 50,
  }) async {
    if (!_isInitialized) return [];

    final week = weekNumber ?? WeeklyLeaderboardEntry.getCurrentWeekNumber();

    return await _isar!.weeklyLeaderboardEntrys
        .filter()
        .weekNumberEqualTo(week)
        .cityEqualTo(city)
        .sortByRank()
        .limit(limit)
        .findAll();
  }

  /// Get player's rank for current week
  Future<WeeklyLeaderboardEntry?> getPlayerWeeklyRank(String odId, {String city = 'global'}) async {
    if (!_isInitialized) return null;

    final weekNumber = WeeklyLeaderboardEntry.getCurrentWeekNumber();

    return await _isar!.weeklyLeaderboardEntrys
        .filter()
        .odIdEqualTo(odId)
        .weekNumberEqualTo(weekNumber)
        .cityEqualTo(city)
        .findFirst();
  }

  /// Get available weeks with data
  Future<List<int>> getAvailableWeeks() async {
    if (!_isInitialized) return [];

    final entries = await _isar!.weeklyLeaderboardEntrys
        .where()
        .distinctByWeekNumber()
        .findAll();

    final weeks = entries.map((e) => e.weekNumber).toSet().toList();
    weeks.sort((a, b) => b.compareTo(a)); // Most recent first
    return weeks;
  }

  /// Get all cities with leaderboard data for a week
  Future<List<String>> getLeaderboardCities(int weekNumber) async {
    if (!_isInitialized) return [];

    final entries = await _isar!.weeklyLeaderboardEntrys
        .filter()
        .weekNumberEqualTo(weekNumber)
        .findAll();

    final cities = entries.map((e) => e.city).toSet().toList();
    cities.remove('global');
    cities.sort();
    return ['global', ...cities];
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _isar?.close();
    super.dispose();
  }
}
