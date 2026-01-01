import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../services/auth_service.dart';
import '../services/blockchain_service.dart';
import '../services/isar_db.dart';
import '../models/marker.dart';
import '../widgets/colored_marker.dart';
import '../config/map_config.dart';
import 'runner_screen.dart';
import 'how_to_play_screen.dart';
import 'user_profile_screen.dart';
import 'wallet_screen.dart';
import 'chat_list_screen.dart';
import 'login_screen.dart';

/// Profile screen with dual-city map and leaderboards
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MapController _mapController = MapController();

  // Services
  late AuthService _auth;
  late BlockchainService _blockchain;
  late IsarDBService _db;

  // Data
  List<GPSMarker> _cityMarkers = [];
  List<MapEntry<String, int>> _cityLeaderboard = [];
  bool _isLoading = true;

  // Current location
  LatLng? _currentLocation;
  StreamSubscription<Position>? _locationSubscription;
  bool _hasMovedToLocation = false;

  // Current city info (detected from location)
  String _currentCity = 'Detecting...';
  String _currentCountry = '';

  // Map style
  MapStyle _mapStyle = MapStyle.streets;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = context.read<AuthService>();
    _blockchain = context.read<BlockchainService>();
    _db = context.read<IsarDBService>();

    _startLocationTracking();
  }

  Future<void> _startLocationTracking() async {
    try {
      // Get current position immediately
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });

        // Detect city from coordinates
        await _detectCityFromLocation(position.latitude, position.longitude);

        // Move map to current location with zoom level 18 (street level, like walking directions)
        if (!_hasMovedToLocation && _currentLocation != null) {
          _hasMovedToLocation = true;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _mapController.move(_currentLocation!, 18);
            }
          });
        }

        // Load data after city is detected
        _loadData();
      }

      // Start listening for location updates (real-time like Swiggy/Zomato)
      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0, // Update on every movement
          timeLimit: Duration(seconds: 1), // Update at least every second
        ),
      ).listen((Position position) {
        if (mounted) {
          final newLocation = LatLng(position.latitude, position.longitude);
          setState(() {
            _currentLocation = newLocation;
          });
          // Keep map centered on current location (follow mode)
          _mapController.move(newLocation, _mapController.camera.zoom);
        }
      });
    } catch (e) {
      debugPrint('Location tracking error: $e');
    }
  }

  Future<void> _detectCityFromLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;

        // Prefer broader location names: district > city > state
        // Avoid small localities, prefer larger areas
        String? detectedCity;

        // First try subAdministrativeArea (district/county level)
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          detectedCity = place.subAdministrativeArea;
        }
        // Then try locality (city)
        else if (place.locality != null && place.locality!.isNotEmpty) {
          detectedCity = place.locality;
        }
        // Fall back to administrativeArea (state/province)
        else if (place.administrativeArea != null &&
                 place.administrativeArea!.isNotEmpty) {
          detectedCity = place.administrativeArea;
        }

        setState(() {
          _currentCity = detectedCity ?? 'Unknown';
          _currentCountry = place.country ?? '';
        });
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
      if (mounted) {
        setState(() {
          _currentCity = 'Unknown';
          _currentCountry = '';
        });
      }
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final cityKey = _currentCity.toLowerCase().replaceAll(' ', '_');

      // Load markers from local DB for current city
      _cityMarkers = await _db.getCityMarkers(cityKey);

      // Load leaderboard for current city
      _cityLeaderboard = await _db.getLeaderboard(cityKey);

      // Try to fetch from chain
      if (_blockchain.isConnected) {
        final chainMarkers = await _blockchain.getAllMarkers();

        // Merge with local markers (avoid duplicates)
        for (final marker in chainMarkers) {
          if (!_cityMarkers.any((m) => m.txHash == marker.txHash)) {
            _cityMarkers.add(marker);
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Runner Web3'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatListScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Wallet',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'How to Play',
            onPressed: () => QuickReferenceCard.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: const Icon(Icons.my_location),
              text: '$_currentCity (${_cityMarkers.length})',
            ),
            const Tab(
              icon: Icon(Icons.leaderboard),
              text: 'Leaderboard',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Profile header (tap to open full profile)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserProfileScreen(),
                ),
              );
            },
            child: _buildProfileHeader(),
          ),

          // Map and content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCityView(),
                _buildLeaderboardView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const RunnerScreen(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.catching_pokemon),
        label: const Text('Collect Crypto'),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final profile = _auth.profile;
    if (profile == null) return const SizedBox();

    final totalMarkers = _cityMarkers.length;
    final isGoogle = profile.authProvider == AuthProvider.google;

    return Stack(
      children: [
        Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(profile.color.replaceFirst('#', '0xFF'))),
            Colors.black87,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(int.parse(profile.color.replaceFirst('#', '0xFF'))),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      image: profile.photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(profile.photoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: profile.photoUrl == null
                        ? Center(
                            child: Text(
                              profile.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                  if (isGoogle)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.g_mobiledata,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _currentCountry.isNotEmpty
                                ? '$_currentCity, $_currentCountry'
                                : _currentCity,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Markers: $totalMarkers',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

          const SizedBox(height: 12),

          // Wallet & blockchain status (tap to open wallet)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.amber,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _auth.shortWalletAddress,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  if (_blockchain.isConnected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Connected',
                            style: TextStyle(color: Colors.green, fontSize: 10),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_off, color: Colors.orange, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Offline',
                            style: TextStyle(color: Colors.orange, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        ),
        // View Profile indicator
        Positioned(
          right: 16,
          top: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Profile',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityView() {
    final playerMarkers = _cityMarkers
        .where((m) => m.playerId == _auth.playerId)
        .toList();
    final otherMarkers = _cityMarkers
        .where((m) => m.playerId != _auth.playerId)
        .toList();

    // Count unique players: current user (1) + other unique players from markers
    final otherPlayerIds = _cityMarkers
        .where((m) => m.playerId != _auth.playerId)
        .map((m) => m.playerId)
        .toSet();
    final livePlayerCount = 1 + otherPlayerIds.length; // Always count current user

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Live player count and city info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.black87,
          child: Row(
            children: [
              Icon(Icons.people, color: Colors.white.withOpacity(0.7), size: 20),
              const SizedBox(width: 8),
              Text(
                'Live: $livePlayerCount ${livePlayerCount == 1 ? 'player' : 'players'}',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const Spacer(),
              const Icon(Icons.location_on, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                _currentCity,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Map
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLocation ?? const LatLng(0, 0),
                  initialZoom: _currentLocation != null ? 18 : 12,
                  minZoom: 10,
                  maxZoom: 19,
                ),
                children: [
                  // Map Tiles (Mapbox or OSM fallback)
                  TileLayer(
                    urlTemplate: _mapStyle.tileUrl,
                    userAgentPackageName: 'com.gpsrunner.web3',
                    tileSize: MapConfig.hasValidToken ? 512 : 256,
                    zoomOffset: MapConfig.hasValidToken ? -1 : 0,
                  ),

                  // Current location circle (accuracy indicator)
                  if (_currentLocation != null)
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: _currentLocation!,
                          radius: 40,
                          color: Colors.blue.withOpacity(0.15),
                          borderColor: Colors.blue.withOpacity(0.5),
                          borderStrokeWidth: 2,
                        ),
                      ],
                    ),

                  // Player markers
                  MarkerLayer(
                    markers: [
                      // Current location marker (blue dot)
                      if (_currentLocation != null)
                        Marker(
                          point: _currentLocation!,
                          width: 30,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      // Other players (smaller, faded)
                      ...otherMarkers.map((m) => Marker(
                            point: LatLng(m.latitude, m.longitude),
                            width: 30,
                            height: 40,
                            child: ColoredMarkerWidget(
                              playerName: m.playerName,
                              color: m.color,
                              isCurrentUser: false,
                              landmarkName: m.landmarkName,
                            ),
                          )),
                      // Current player markers (larger, highlighted)
                      ...playerMarkers.map((m) => Marker(
                            point: LatLng(m.latitude, m.longitude),
                            width: 40,
                            height: 50,
                            child: ColoredMarkerWidget(
                              playerName: m.playerName,
                              color: m.color,
                              isCurrentUser: true,
                              landmarkName: m.landmarkName,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              // Map style switcher button
              Positioned(
                top: 8,
                right: 8,
                child: _buildMapStyleButton(),
              ),
            ],
          ),
        ),

        // Marker list
        Expanded(
          child: _buildMarkerList(playerMarkers),
        ),
      ],
    );
  }

  Widget _buildMapStyleButton() {
    return GestureDetector(
      onTap: _showMapStylePicker,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.layers, size: 20),
            const SizedBox(width: 4),
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
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Style',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (!MapConfig.hasValidToken)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Add Mapbox token in map_config.dart for satellite view',
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
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
                          ? Colors.blue
                          : isDisabled
                              ? Colors.grey.shade200
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.blue.shade700, width: 2)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(style.icon, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          style.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isDisabled
                                    ? Colors.grey
                                    : Colors.black,
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

  Widget _buildMarkerList(List<GPSMarker> markers) {
    if (markers.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No markers yet',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const Text(
                    'Start running to place markers!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemCount: markers.length,
        itemBuilder: (context, index) {
          final marker = markers[index];
          final time = DateTime.fromMillisecondsSinceEpoch(marker.timestamp);
          final timeAgo = _formatTimeAgo(time);

          return Card(
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(marker.color.replaceFirst('#', '0xFF'))),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.flag, color: Colors.white),
              ),
              title: Text(marker.landmarkName),
              subtitle: Text(
                '$timeAgo • ${marker.speedKmh.toStringAsFixed(1)} km/h',
              ),
              trailing: marker.syncedToChain
                  ? const Icon(Icons.verified, color: Colors.green)
                  : const Icon(Icons.cloud_upload, color: Colors.orange),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardView() {
    return Column(
      children: [
        // City header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                '$_currentCity Leaderboard',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildLeaderboard(_cityLeaderboard, Colors.blue),
        ),
      ],
    );
  }

  Widget _buildLeaderboard(
    List<MapEntry<String, int>> leaderboard,
    Color color,
  ) {
    if (leaderboard.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No data yet'),
                  const SizedBox(height: 8),
                  Text(
                    'Pull down to refresh',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final entry = leaderboard[index];
          final isCurrentUser = entry.key == _auth.playerName;

          return Card(
            color: isCurrentUser ? color.withOpacity(0.1) : null,
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: index < 3 ? _getRankColor(index) : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                entry.key,
                style: TextStyle(
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentUser ? color : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flag, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey.shade400;
      case 2:
        return Colors.brown.shade400;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _showSettings() {
    final profile = _auth.profile;
    final isGoogle = profile?.authProvider == AuthProvider.google;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Account info
            if (isGoogle && profile != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.g_mobiledata, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Google Account',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            profile.email,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.green, size: 20),
                  ],
                ),
              ),

            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.blue),
              title: const Text('How to Play'),
              subtitle: const Text('Game instructions & tips'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HowToPlayScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Change Name'),
              onTap: () => _changeName(),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Change Color'),
              onTap: () => _changeColor(),
            ),
            ListTile(
              leading: const Icon(Icons.key, color: Colors.amber),
              title: const Text('Export Private Key'),
              subtitle: const Text('Backup your wallet'),
              onTap: () => _exportPrivateKey(),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: const Text('Clear Local Data'),
              onTap: () => _clearData(),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out'),
              onTap: () => _signOut(),
            ),
          ],
        ),
      ),
    );
  }

  void _exportPrivateKey() async {
    Navigator.pop(context);

    final privateKey = await _auth.exportPrivateKey();
    if (privateKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No private key found')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Private Key'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                privateKey,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Never share your private key with anyone!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Store this safely to recover your wallet.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    Navigator.pop(context); // Close settings drawer

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text(
          'You will need to sign in again to access your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _auth.signOut();
      if (mounted) {
        // Navigate to login screen and clear all routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _changeName() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _auth.playerName);
        return AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Runner Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _auth.updateName(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _changeColor() {
    Navigator.pop(context);
    final colors = [
      '#2196F3', '#4CAF50', '#F44336', '#FF9800',
      '#9C27B0', '#00BCD4', '#E91E63', '#FFEB3B',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                _auth.updateColor(color);
                Navigator.pop(context);
                setState(() {});
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                  shape: BoxShape.circle,
                  border: color == _auth.playerColor
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _clearData() async {
    Navigator.pop(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Data?'),
        content: const Text(
          'This will delete all local markers. Blockchain data will remain.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.clearAll();
      _loadData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }
}
