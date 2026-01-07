import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/isar_db.dart';
import '../services/blockchain_service.dart';
import '../services/coverage_service.dart';
import '../services/chat_service.dart';
import '../models/walking_session.dart';
import '../config/map_config.dart' show MapStyle;
import 'chat_room_screen.dart';

/// Stats dashboard showing walking history, distance, steps, and covered area
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late IsarDBService _db;
  late BlockchainService _blockchain;
  late CoverageService _coverageService;
  late ChatService _chatService;

  UserWalkingStats _localStats = UserWalkingStats();
  PlayerBlockchainStats? _chainStats;
  List<WalkingSession> _sessions = [];
  Map<String, List<Map<String, dynamic>>> _coveredAreas = {};
  List<CoveragePoint> _allCoverage = [];
  List<NearbyPlayer> _nearbyPlayers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = context.read<IsarDBService>();
    _blockchain = context.read<BlockchainService>();
    _coverageService = context.read<CoverageService>();
    _chatService = context.read<ChatService>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load local stats
      _localStats = await _db.getUserStats();
      _sessions = await _db.getWalkingSessions();
      _coveredAreas = await _db.getCoveredAreas();

      // Load blockchain stats
      if (_blockchain.isConnected) {
        _chainStats = await _blockchain.getPlayerStats();
      }

      // Load shared coverage from all players
      final currentCity = _localStats.distanceByCity.keys.isNotEmpty
          ? _localStats.distanceByCity.keys.first
          : 'delhi';
      await _coverageService.loadCityCoverage(currentCity);
      _allCoverage = _coverageService.allCoverage;

      // Load nearby players
      _nearbyPlayers = await _coverageService.loadNearbyPlayers();
    } catch (e) {
      debugPrint('Error loading stats: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stats'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelStyle: const TextStyle(fontSize: 11),
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Overview'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.map), text: 'Coverage'),
            Tab(icon: Icon(Icons.people), text: 'Nearby'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildHistoryTab(),
                _buildCoverageTab(),
                _buildNearbyTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    final totalDistance = (_chainStats?.totalDistanceMeters ?? _localStats.totalDistanceMeters).toDouble();
    final totalMarkers = _chainStats?.totalMarkers ?? _localStats.markersPlaced;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main stats cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.directions_walk,
                  title: 'Total Distance',
                  value: _formatDistance(totalDistance),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.flag,
                  title: 'Markers Placed',
                  value: totalMarkers.toString(),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.timer,
                  title: 'Total Time',
                  value: _localStats.formattedTotalDuration,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.directions_run,
                  title: 'Sessions',
                  value: _localStats.totalSessions.toString(),
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.speed,
                  title: 'Max Speed',
                  value: '${_localStats.maxSpeedKmh.toStringAsFixed(1)} km/h',
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.location_city,
                  title: 'Cities Covered',
                  value: _coveredAreas.keys.length.toString(),
                  color: Colors.teal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Blockchain stats section
          if (_chainStats != null) ...[
            const Text(
              'On-Chain Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade900, Colors.blue.shade900],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Distance (Blockchain)', style: TextStyle(color: Colors.white70)),
                      Text(
                        _formatDistance(_chainStats!.totalDistanceMeters.toDouble()),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Markers (Blockchain)', style: TextStyle(color: Colors.white70)),
                      Text(
                        _chainStats!.totalMarkers.toString(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Registered', style: TextStyle(color: Colors.white70)),
                      Icon(
                        _chainStats!.isRegistered ? Icons.check_circle : Icons.cancel,
                        color: _chainStats!.isRegistered ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Distance by city
          if (_localStats.distanceByCity.isNotEmpty) ...[
            const Text(
              'Distance by City',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._localStats.distanceByCity.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(entry.key.toUpperCase()),
                  ),
                  Text(
                    _formatDistance(entry.value),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No walking sessions yet', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Start walking to track your progress!', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        return _SessionCard(session: session);
      },
    );
  }

  Widget _buildCoverageTab() {
    // Get coverage grouped by player
    final coverageByPlayer = _coverageService.coverageByPlayer;

    if (_allCoverage.isEmpty && _coveredAreas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No coverage data yet', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('Walk around to see covered areas!', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // Calculate center from all coverage points
    LatLng center = const LatLng(28.6139, 77.2090); // Default Delhi
    if (_allCoverage.isNotEmpty) {
      double sumLat = 0, sumLng = 0;
      for (final point in _allCoverage) {
        sumLat += point.latitude;
        sumLng += point.longitude;
      }
      center = LatLng(sumLat / _allCoverage.length, sumLng / _allCoverage.length);
    }

    // Generate colors for each player
    final playerColors = <String, Color>{};
    final colorPalette = [
      Colors.blue, Colors.green, Colors.red, Colors.purple,
      Colors.orange, Colors.teal, Colors.pink, Colors.amber,
      Colors.indigo, Colors.cyan, Colors.lime, Colors.deepOrange,
    ];
    int colorIndex = 0;
    for (final odId in coverageByPlayer.keys) {
      final playerPoint = coverageByPlayer[odId]?.first;
      if (playerPoint != null) {
        // Try to parse player's color, fallback to palette
        try {
          final colorHex = playerPoint.playerColor.replaceAll('#', '');
          playerColors[odId] = Color(int.parse('FF$colorHex', radix: 16));
        } catch (_) {
          playerColors[odId] = colorPalette[colorIndex % colorPalette.length];
          colorIndex++;
        }
      }
    }

    return Column(
      children: [
        // Stats bar with player count
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    coverageByPlayer.keys.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text('Players', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              Column(
                children: [
                  Text(
                    _allCoverage.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text('Total Points', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
              Column(
                children: [
                  Text(
                    _nearbyPlayers.where((p) => p.isActive).length.toString(),
                    style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text('Active Now', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        // Player legend
        if (coverageByPlayer.isNotEmpty)
          Container(
            height: 40,
            color: Colors.black54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: coverageByPlayer.keys.length,
              itemBuilder: (context, index) {
                final odId = coverageByPlayer.keys.elementAt(index);
                final points = coverageByPlayer[odId]!;
                final color = playerColors[odId] ?? Colors.grey;
                final playerName = points.first.playerName;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        playerName.length > 10 ? '${playerName.substring(0, 10)}...' : playerName,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      Text(
                        ' (${points.length})',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        // Map
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: MapStyle.dark.tileUrl,
                userAgentPackageName: 'com.gpsrunner.web3',
              ),
              // Show each player's coverage with their color
              CircleLayer(
                circles: _allCoverage.map((point) {
                  final color = playerColors[point.odId] ?? Colors.green;
                  return CircleMarker(
                    point: point.location,
                    radius: 10,
                    color: color.withAlpha(100),
                    borderColor: color,
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyTab() {
    if (_nearbyPlayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              'No nearby players found',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Walk around to find other players!',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _nearbyPlayers.length,
      itemBuilder: (context, index) {
        final player = _nearbyPlayers[index];
        return _NearbyPlayerCard(
          player: player,
          onTap: () => _openChatWithPlayer(player),
        );
      },
    );
  }

  Future<void> _openChatWithPlayer(NearbyPlayer player) async {
    // Join the city chat room to chat with nearby players
    final cityRoom = await _chatService.joinCityRoom(
      cityName: player.city.isNotEmpty ? player.city : 'global',
      country: 'India',
    );

    if (cityRoom != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(roomId: cityRoom.id),
        ),
      );
    }
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final WalkingSession session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(session.startTime),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: session.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.isActive ? 'Active' : 'Completed',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SessionStat(
                  icon: Icons.directions_walk,
                  value: session.formattedDistance,
                  label: 'Distance',
                ),
                _SessionStat(
                  icon: Icons.timer,
                  value: session.formattedDuration,
                  label: 'Duration',
                ),
                _SessionStat(
                  icon: Icons.speed,
                  value: '${session.avgSpeedKmh.toStringAsFixed(1)} km/h',
                  label: 'Avg Speed',
                ),
              ],
            ),
            if (session.city.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${session.city}, ${session.state}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _SessionStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SessionStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _NearbyPlayerCard extends StatelessWidget {
  final NearbyPlayer player;
  final VoidCallback onTap;

  const _NearbyPlayerCard({
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color playerColor;
    try {
      final colorHex = player.color.replaceAll('#', '');
      playerColor = Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      playerColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF2a2a3e),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Player avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: playerColor.withAlpha(50),
                  shape: BoxShape.circle,
                  border: Border.all(color: playerColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: playerColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Player info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            player.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Online indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: player.isActive ? Colors.green.withAlpha(50) : Colors.grey.withAlpha(50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: player.isActive ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                player.isActive ? 'Active' : _formatLastSeen(player.lastSeen),
                                style: TextStyle(
                                  color: player.isActive ? Colors.green : Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          _formatDistance(player.distanceMeters),
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        if (player.city.isNotEmpty) ...[
                          Icon(Icons.place, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(
                            player.city,
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                    if (player.coveragePoints > 0 || player.totalDistanceWalked > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (player.coveragePoints > 0) ...[
                            Icon(Icons.map, size: 14, color: Colors.amber.shade300),
                            const SizedBox(width: 4),
                            Text(
                              '${player.coveragePoints} points',
                              style: TextStyle(color: Colors.amber.shade300, fontSize: 11),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (player.totalDistanceWalked > 0) ...[
                            Icon(Icons.directions_walk, size: 14, color: Colors.blue.shade300),
                            const SizedBox(width: 4),
                            Text(
                              _formatDistance(player.totalDistanceWalked),
                              style: TextStyle(color: Colors.blue.shade300, fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Chat button
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chat_bubble, color: Colors.amber, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toInt()} m';
  }

  String _formatLastSeen(DateTime lastSeen) {
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return '${diff.inDays}d ago';
  }
}
