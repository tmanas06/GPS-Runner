import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/isar_db.dart';
import '../services/coverage_service.dart';
import '../models/walking_session.dart';
import '../models/city_bounds.dart';
import '../config/map_config.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';
import 'leaderboard_screen.dart';

/// Crypto coin types with their properties
enum CryptoCoin {
  mantle('MNT', 'Mantle', Colors.teal, 0.5, 'assets/mnt.png', 'gMNT'),
  polygon('MATIC', 'Polygon', Colors.purple, 0.1, 'assets/matic.png', 'gPOL'),
  bnb('BNB', 'BNB Chain', Colors.amber, 0.01, 'assets/bnb.png', 'gBNB');

  final String symbol;
  final String name;
  final Color color;
  final double baseAmount;
  final String icon;
  final String gameTokenSymbol; // Token symbol for on-chain (gMNT, gPOL, gBNB)

  const CryptoCoin(this.symbol, this.name, this.color, this.baseAmount, this.icon, this.gameTokenSymbol);
}

/// A spawned coin on the map
class SpawnedCoin {
  final String id;
  final CryptoCoin type;
  final LatLng location;
  final double amount;
  final DateTime spawnTime;
  bool collected;

  SpawnedCoin({
    required this.id,
    required this.type,
    required this.location,
    required this.amount,
    required this.spawnTime,
    this.collected = false,
  });
}

/// Pokemon Go style crypto collection game
class RunnerScreen extends StatefulWidget {
  const RunnerScreen({super.key});

  @override
  State<RunnerScreen> createState() => _RunnerScreenState();
}

class _RunnerScreenState extends State<RunnerScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  // Map controller
  final MapController _mapController = MapController();

  // Location tracking
  LatLng? _currentLocation;
  StreamSubscription<Position>? _locationSubscription;

  // Walking trail - stores path points (limited to prevent memory issues)
  final List<LatLng> _walkingTrail = [];
  static const int _maxTrailPoints = 1000; // Limit trail to prevent memory leaks

  // Spawned coins on map
  final List<SpawnedCoin> _spawnedCoins = [];

  // Collected coins wallet
  final Map<CryptoCoin, double> _wallet = {};

  // Timers
  Timer? _spawnTimer;
  Timer? _collectionCheckTimer;
  Timer? _autoSaveTimer;

  // Random generator
  final Random _random = Random();

  // Collection radius in meters
  static const double _collectionRadius = 25.0;

  // Spawn radius in meters
  static const double _spawnRadius = 300.0;

  // Max coins on map
  static const int _maxCoins = 15;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Services
  late AuthService _auth;
  late IsarDBService _db;
  late CoverageService _coverageService;

  // Walking session tracking
  WalkingSession? _currentSession;
  String _currentCity = '';
  String _currentState = '';
  int _stepCount = 0;

  // Error state
  String? _locationError;

  // Map style
  MapStyle _mapStyle = MapStyle.streets;

  @override
  void initState() {
    super.initState();

    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Initialize wallet
    for (final coin in CryptoCoin.values) {
      _wallet[coin] = 0.0;
    }

    // Pulse animation for collectible coins
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startLocationTracking();

    // Spawn coins periodically
    _spawnTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _spawnCoins(),
    );

    // Check for collection periodically
    _collectionCheckTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _checkCollection(),
    );

    // Auto-save session every 30 seconds
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _saveCurrentSession(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Save when app goes to background or is paused
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveCurrentSession();
      debugPrint('App lifecycle: $state - Session saved');
    }
  }

  Future<void> _saveCurrentSession() async {
    if (_currentSession != null && _currentSession!.isActive) {
      _currentSession!.totalSteps = _stepCount;
      await _db.updateCurrentSession(_currentSession!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = context.read<AuthService>();
    _db = context.read<IsarDBService>();
    _coverageService = context.read<CoverageService>();

    // Initialize user on leaderboard with 0 stats
    _initializeLeaderboard();

    // Load saved coin balances
    _loadSavedBalances();
  }

  /// Load saved coin balances from database
  Future<void> _loadSavedBalances() async {
    await _db.initializeGameCoins();
    final savedBalances = await _db.getGameCoinBalances();

    if (mounted) {
      setState(() {
        for (final coin in CryptoCoin.values) {
          final savedAmount = savedBalances[coin.gameTokenSymbol] ?? 0.0;
          _wallet[coin] = savedAmount;
        }
      });
    }
    debugPrint('Loaded saved balances: $savedBalances');
  }

  Future<void> _initializeLeaderboard() async {
    final profile = _auth.profile;
    if (profile != null) {
      await _db.initializeUserOnLeaderboard(
        odId: profile.id,
        playerName: profile.name,
        playerColor: profile.color,
        city: _currentCity,
      );
    }
  }

  Future<void> _startLocationTracking() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _locationError = 'Location services are disabled. Please enable GPS.';
          });
        }
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _locationError = 'Location permission denied.';
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _locationError = 'Location permissions are permanently denied.';
          });
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      if (mounted) {
        final initialLocation = LatLng(position.latitude, position.longitude);

        // Detect city and state from location
        final stateConfig = CityBounds.detectState(position.latitude, position.longitude);
        if (stateConfig != null) {
          _currentState = stateConfig.name;
          final city = stateConfig.detectCity(position.latitude, position.longitude);
          _currentCity = city?.name ?? stateConfig.name;
        } else {
          _currentCity = 'Unknown';
          _currentState = 'Unknown';
        }

        setState(() {
          _currentLocation = initialLocation;
          _locationError = null;
          // Start the walking trail from initial position
          _walkingTrail.add(initialLocation);
        });

        // Start walking session
        _startWalkingSession();

        // Start coverage tracking
        _coverageService.startTracking(_currentCity, _currentState);

        // Center map on current location (street level like walking directions)
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _currentLocation != null) {
            _mapController.move(_currentLocation!, 18);
          }
        });

        // Initial coin spawn
        _spawnCoins();
      }

      // Listen for location updates with adaptive frequency for battery optimization
      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // Changed from bestForNavigation to reduce battery drain
          distanceFilter: 5, // Adaptive: 5m when moving (reduced from 2m for battery)
          timeLimit: const Duration(seconds: 2), // Update at least every 2 seconds (reduced frequency)
        ),
      ).listen((Position position) {
        if (mounted) {
          final newLocation = LatLng(position.latitude, position.longitude);
          final speedKmh = position.speed * 3.6; // Convert m/s to km/h

          setState(() {
            _currentLocation = newLocation;
            // Add to walking trail with memory management
            if (_walkingTrail.isEmpty ||
                _getDistance(_walkingTrail.last, newLocation) > 2) {
              _walkingTrail.add(newLocation);
              
              // Limit trail size to prevent memory leaks
              if (_walkingTrail.length > _maxTrailPoints) {
                // Remove oldest 100 points when limit reached
                _walkingTrail.removeRange(0, 100);
              }

              // Estimate steps (approx 1.3 steps per meter at walking pace)
              _stepCount += (_getDistance(_walkingTrail.length > 1 ? _walkingTrail[_walkingTrail.length - 2] : newLocation, newLocation) * 1.3).toInt();

              // Update walking session
              _currentSession?.addTrackPoint(
                position.latitude,
                position.longitude,
                speedKmh,
                _stepCount,
              );

              // Save covered area point locally
              if (_currentCity.isNotEmpty && _currentCity != 'Unknown') {
                _db.saveCoveredAreaPoint(position.latitude, position.longitude, _currentCity.toLowerCase());

                // Sync to cloud for other players to see
                _coverageService.updateLocation(
                  position.latitude,
                  position.longitude,
                  _currentCity,
                  _currentState,
                  distanceMeters: _currentSession?.totalDistanceMeters,
                );
              }
            }
          });

          // Update session in DB frequently (every 5 points or 30 seconds worth)
          if (_currentSession != null && _walkingTrail.length % 5 == 0) {
            _currentSession!.totalSteps = _stepCount;
            _db.updateCurrentSession(_currentSession!);
            debugPrint('Session saved: ${_currentSession!.formattedDistance}, $_stepCount steps');
          }

          // Keep map centered on current location (follow mode)
          _mapController.move(newLocation, _mapController.camera.zoom);
        }
      });
    } catch (e) {
      debugPrint('Location error: $e');
      if (mounted) {
        setState(() {
          _locationError = 'Could not get location: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _startWalkingSession() async {
    try {
      // Check if there's an existing active session
      _currentSession = await _db.getCurrentSession();

      if (_currentSession == null || !_currentSession!.isActive) {
        // Start new session
        _currentSession = await _db.startWalkingSession(
          city: _currentCity,
          state: _currentState,
        );
        debugPrint('Started new walking session: ${_currentSession?.id}');
      } else {
        debugPrint('Resuming existing walking session: ${_currentSession?.id}');
      }
    } catch (e) {
      debugPrint('Error starting walking session: $e');
    }
  }

  Future<void> _endWalkingSession() async {
    if (_currentSession != null && _currentSession!.isActive) {
      try {
        _currentSession!.totalSteps = _stepCount;
        await _db.endCurrentSession(_currentSession!);
        debugPrint('Ended walking session: ${_currentSession?.id}');

        // Update weekly leaderboard
        final profile = _auth.profile;
        if (profile != null) {
          await _db.updateWeeklyLeaderboard(
            odId: profile.id,
            playerName: profile.name,
            playerColor: profile.color,
            city: _currentCity,
            distanceMeters: _currentSession!.totalDistanceMeters,
            markerCount: 0, // Markers are tracked separately
            steps: _currentSession!.totalSteps,
            maxSpeed: _currentSession!.maxSpeedKmh,
          );
          debugPrint('Updated weekly leaderboard');
        }
      } catch (e) {
        debugPrint('Error ending walking session: $e');
      }
    }
  }

  void _spawnCoins() {
    if (_currentLocation == null) return;
    if (_spawnedCoins.where((c) => !c.collected).length >= _maxCoins) return;

    setState(() {
      // Spawn 2-4 coins each time
      final coinsToSpawn = _random.nextInt(3) + 2;

      for (int i = 0; i < coinsToSpawn; i++) {
        if (_spawnedCoins.where((c) => !c.collected).length >= _maxCoins) break;

        // Random coin type (rarer coins less likely)
        final coinType = _getRandomCoinType();

        // Random location within spawn radius
        final location = _getRandomLocation(_currentLocation!, _spawnRadius);

        // Random amount multiplier (0.5x to 2x base amount)
        final amount = coinType.baseAmount * (0.5 + _random.nextDouble() * 1.5);

        _spawnedCoins.add(SpawnedCoin(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          type: coinType,
          location: location,
          amount: amount,
          spawnTime: DateTime.now(),
        ));
      }
    });
  }

  CryptoCoin _getRandomCoinType() {
    // Weighted random - common coins more likely
    final weights = [
      30,  // MNT - common (Mantle)
      40,  // MATIC - very common (Polygon)
      30,  // BNB - common (BNB Chain)
    ];

    final totalWeight = weights.reduce((a, b) => a + b);
    var random = _random.nextInt(totalWeight);

    for (int i = 0; i < weights.length; i++) {
      random -= weights[i];
      if (random < 0) {
        return CryptoCoin.values[i];
      }
    }
    return CryptoCoin.polygon;
  }

  LatLng _getRandomLocation(LatLng center, double radiusMeters) {
    // Convert radius from meters to degrees (approximate)
    final radiusDeg = radiusMeters / 111000;

    // Random angle and distance
    final angle = _random.nextDouble() * 2 * pi;
    final distance = _random.nextDouble() * radiusDeg;

    return LatLng(
      center.latitude + distance * cos(angle),
      center.longitude + distance * sin(angle) / cos(center.latitude * pi / 180),
    );
  }

  // Calculate distance between two points in meters
  double _getDistance(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, from, to);
  }

  void _checkCollection() {
    if (_currentLocation == null) return;

    final distance = const Distance();

    setState(() {
      for (final coin in _spawnedCoins) {
        if (coin.collected) continue;

        final distanceToCoins = distance.as(
          LengthUnit.Meter,
          _currentLocation!,
          coin.location,
        );

        if (distanceToCoins <= _collectionRadius) {
          coin.collected = true;
          _wallet[coin.type] = (_wallet[coin.type] ?? 0) + coin.amount;

          // Save to database for persistence
          _saveCollectedCoin(coin);

          HapticFeedback.mediumImpact();
          _showCollectionPopup(coin);
        }
      }

      // Remove old collected coins
      _spawnedCoins.removeWhere((c) =>
        c.collected && DateTime.now().difference(c.spawnTime).inSeconds > 5
      );
    });
  }

  /// Save collected coin to database
  Future<void> _saveCollectedCoin(SpawnedCoin coin) async {
    await _db.addCollectedCoin(
      coin.type.gameTokenSymbol,
      coin.amount,
      latitude: coin.location.latitude,
      longitude: coin.location.longitude,
    );
    debugPrint('Saved ${coin.amount} ${coin.type.gameTokenSymbol} to database');
  }

  void _showCollectionPopup(SpawnedCoin coin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            _buildCoinIcon(coin.type, 24),
            const SizedBox(width: 12),
            Text(
              '+${coin.amount.toStringAsFixed(coin.type == CryptoCoin.mantle ? 2 : 4)} ${coin.type.symbol}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: coin.type.color.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: Stack(
        children: [
          // Map or loading state
          if (_currentLocation == null)
            _buildLoadingState()
          else
            _buildMap(),

          // Top HUD - Wallet summary
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: _buildWalletHUD(),
          ),

          // Back button - always visible
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: _buildBackButton(),
          ),

          // Safety disclaimer (shown when location is loaded)
          if (_currentLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildSafetyDisclaimer(),
            ),

          // Only show these when location is loaded
          if (_currentLocation != null) ...[
            // Map style button
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: _buildMapStyleButton(),
            ),

            // Center on me button
            Positioned(
              bottom: 100,
              right: 16,
              child: _buildCenterButton(),
            ),

            // Wallet button
            Positioned(
              bottom: 100,
              left: 16,
              child: _buildWalletButton(),
            ),

            // Stats button
            Positioned(
              bottom: 170,
              left: 16,
              child: _buildStatsButton(),
            ),

            // Leaderboard button
            Positioned(
              bottom: 230,
              left: 16,
              child: _buildLeaderboardButton(),
            ),

            // Collection radius indicator
            Positioned(
              bottom: 300,
              left: 0,
              right: 0,
              child: _buildRadiusIndicator(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: const Color(0xFF1a1a2e),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated coin or error icon
            if (_locationError == null)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 6.28,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '₿',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_off,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            const SizedBox(height: 32),
            Text(
              _locationError ?? 'Finding your location...',
              style: TextStyle(
                color: _locationError != null ? Colors.red : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _locationError != null
                  ? 'Please enable location to play'
                  : 'Crypto coins will appear nearby',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            if (_locationError == null)
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 3,
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _locationError = null;
                  });
                  _startLocationTracking();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? const LatLng(28.6139, 77.2090),
        initialZoom: 18,
        minZoom: 14,
        maxZoom: 19,
      ),
      children: [
        // Map tiles (Mapbox or OSM fallback)
        TileLayer(
          urlTemplate: _mapStyle.tileUrl,
          userAgentPackageName: 'com.gpsrunner.web3',
          tileSize: MapConfig.hasValidToken ? 512 : 256,
          zoomOffset: MapConfig.hasValidToken ? -1 : 0,
        ),

        // Walking trail polyline
        if (_walkingTrail.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _walkingTrail,
                color: Colors.blue.withOpacity(0.8),
                strokeWidth: 5,
                borderColor: Colors.white,
                borderStrokeWidth: 1,
              ),
            ],
          ),

        // Collection radius circle
        if (_currentLocation != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: _currentLocation!,
                radius: _collectionRadius,
                useRadiusInMeter: true,
                color: Colors.green.withOpacity(0.15),
                borderColor: Colors.green.withOpacity(0.5),
                borderStrokeWidth: 2,
              ),
            ],
          ),

        // Crypto coins
        MarkerLayer(
          markers: [
            // Spawned coins
            ..._spawnedCoins.where((c) => !c.collected).map((coin) =>
              Marker(
                point: coin.location,
                width: 50,
                height: 60,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: _buildCoinMarker(coin),
                    );
                  },
                ),
              ),
            ),

            // Current location
            if (_currentLocation != null)
              Marker(
                point: _currentLocation!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoinMarker(SpawnedCoin coin) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            coin.type.symbol,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: coin.type.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: coin.type.color.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: _buildCoinIcon(coin.type, 24),
          ),
        ),
      ],
    );
  }

  Widget _buildCoinIcon(CryptoCoin coin, double size) {
    // Use text symbols since we don't have actual crypto icons
    final symbols = {
      CryptoCoin.mantle: 'M',
      CryptoCoin.polygon: '⬡',
      CryptoCoin.bnb: '◆',
    };

    return Text(
      symbols[coin] ?? '?',
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWalletHUD() {
    // Show top 3 coins with balance
    final sortedCoins = _wallet.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCoins = sortedCoins.take(3).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (topCoins.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Walk to collect crypto!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        else
          ...topCoins.map((entry) => Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: entry.key.color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCoinIcon(entry.key, 14),
                const SizedBox(width: 6),
                Text(
                  '${entry.value.toStringAsFixed(entry.key == CryptoCoin.mantle ? 2 : 4)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return FloatingActionButton(
      heroTag: 'center',
      mini: true,
      backgroundColor: Colors.blue,
      onPressed: () {
        if (_currentLocation != null) {
          _mapController.move(_currentLocation!, 18);
        }
      },
      child: const Icon(Icons.my_location, color: Colors.white),
    );
  }

  Widget _buildMapStyleButton() {
    return GestureDetector(
      onTap: _showMapStylePicker,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.layers, size: 20, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              _mapStyle.icon,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showMapStylePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1a1a2e),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Style',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (!MapConfig.hasValidToken)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Add Mapbox token for satellite view',
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MapStyle.values.map((style) {
                final isSelected = style == _mapStyle;
                final isDisabled = !MapConfig.hasValidToken &&
                    style != MapStyle.streets;

                return GestureDetector(
                  onTap: isDisabled ? null : () {
                    setState(() => _mapStyle = style);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.amber
                          : isDisabled
                              ? Colors.grey.shade800
                              : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(style.icon, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          style.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : isDisabled
                                    ? Colors.grey
                                    : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletButton() {
    return FloatingActionButton(
      heroTag: 'wallet',
      backgroundColor: Colors.amber,
      onPressed: _showWalletDialog,
      child: const Icon(Icons.account_balance_wallet, color: Colors.white),
    );
  }

  Widget _buildStatsButton() {
    return FloatingActionButton(
      heroTag: 'stats',
      mini: true,
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatsScreen()),
        );
      },
      child: const Icon(Icons.analytics, color: Colors.white),
    );
  }

  Widget _buildLeaderboardButton() {
    return FloatingActionButton(
      heroTag: 'leaderboard',
      mini: true,
      backgroundColor: Colors.purple,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
        );
      },
      child: const Icon(Icons.leaderboard, color: Colors.white),
    );
  }

  // Calculate total walking distance
  double get _totalWalkingDistance {
    if (_walkingTrail.length < 2) return 0;
    double total = 0;
    for (int i = 1; i < _walkingTrail.length; i++) {
      total += _getDistance(_walkingTrail[i - 1], _walkingTrail[i]);
    }
    return total;
  }

  Widget _buildSafetyDisclaimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Walk safely! Be aware of your surroundings and traffic.',
              style: TextStyle(
                color: Colors.red.shade200,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusIndicator() {
    final distanceKm = _totalWalkingDistance / 1000;
    final distanceText = distanceKm >= 1
        ? '${distanceKm.toStringAsFixed(2)} km'
        : '${_totalWalkingDistance.toInt()} m';

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_walk, color: Colors.blue, size: 20),
            const SizedBox(width: 6),
            Text(
              distanceText,
              style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.hiking, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            Text(
              '$_stepCount',
              style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '| ${_spawnedCoins.where((c) => !c.collected).length} coins',
              style: TextStyle(color: Colors.amber.shade300, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF1a1a2e),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Crypto Wallet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Collected while walking',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: CryptoCoin.values.length,
                itemBuilder: (context, index) {
                  final coin = CryptoCoin.values[index];
                  final balance = _wallet[coin] ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: coin.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: coin.color.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: coin.color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: _buildCoinIcon(coin, 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coin.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                coin.symbol,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          balance > 0
                            ? balance.toStringAsFixed(coin == CryptoCoin.mantle ? 2 : 4)
                            : '0',
                          style: TextStyle(
                            color: balance > 0 ? Colors.white : Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Walk around to find more crypto coins!',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove lifecycle observer
    WidgetsBinding.instance.removeObserver(this);

    // Save session before closing
    _saveCurrentSession();
    _endWalkingSession();

    // Stop services
    _coverageService.stopTracking();

    // Cancel timers
    _autoSaveTimer?.cancel();
    _locationSubscription?.cancel();
    _spawnTimer?.cancel();
    _collectionCheckTimer?.cancel();

    _pulseController.dispose();
    super.dispose();
  }
}
