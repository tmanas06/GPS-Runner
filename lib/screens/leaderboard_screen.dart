import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/isar_db.dart';
import '../services/auth_service.dart';
import '../services/blockchain_service.dart';
import '../models/walking_session.dart';

/// Leaderboard screen showing weekly rankings
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late IsarDBService _db;
  late AuthService _authService;
  late BlockchainService _blockchain;

  List<WeeklyLeaderboardEntry> _weeklyEntries = [];
  List<LeaderboardEntry> _chainEntries = [];
  WeeklyLeaderboardEntry? _myRank;

  int _selectedWeek = WeeklyLeaderboardEntry.getCurrentWeekNumber();
  String _selectedCity = 'global';
  List<int> _availableWeeks = [];
  List<String> _availableCities = ['global'];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = context.read<IsarDBService>();
    _authService = context.read<AuthService>();
    _blockchain = context.read<BlockchainService>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load available weeks
      _availableWeeks = await _db.getAvailableWeeks();
      if (_availableWeeks.isEmpty) {
        _availableWeeks = [WeeklyLeaderboardEntry.getCurrentWeekNumber()];
      }

      // Load available cities for selected week
      _availableCities = await _db.getLeaderboardCities(_selectedWeek);
      if (_availableCities.isEmpty) {
        _availableCities = ['global'];
      }

      // Load weekly leaderboard
      _weeklyEntries = await _db.getWeeklyLeaderboard(
        city: _selectedCity,
        weekNumber: _selectedWeek,
      );

      // Load player's rank
      final userId = _authService.profile?.id;
      if (userId != null) {
        _myRank = await _db.getPlayerWeeklyRank(userId, city: _selectedCity);
      }

      // Load blockchain leaderboard
      if (_blockchain.isConnected) {
        if (_selectedCity == 'global') {
          _chainEntries = await _blockchain.getGlobalLeaderboard(limit: 50);
        } else {
          _chainEntries = await _blockchain.getCityLeaderboard(_selectedCity, limit: 50);
        }
      }
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: 'Weekly'),
            Tab(icon: Icon(Icons.link), text: 'On-Chain'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(),
          // Leaderboard
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildWeeklyTab(),
                      _buildChainTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black54,
      child: Row(
        children: [
          // Week selector
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<int>(
                value: _selectedWeek,
                isExpanded: true,
                dropdownColor: const Color(0xFF2a2a3e),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: _availableWeeks.map((week) {
                  return DropdownMenuItem(
                    value: week,
                    child: Text(
                      WeeklyLeaderboardEntry.formatWeekNumber(week),
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedWeek = value);
                    _loadData();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // City selector
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedCity,
                isExpanded: true,
                dropdownColor: const Color(0xFF2a2a3e),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: _availableCities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(
                      city == 'global' ? 'Global' : city.toUpperCase(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCity = value);
                    _loadData();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    if (_weeklyEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              'No entries this week',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Start walking to appear on the leaderboard!',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // My rank card
        if (_myRank != null) _buildMyRankCard(_myRank!),
        // Leaderboard list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _weeklyEntries.length,
            itemBuilder: (context, index) {
              final entry = _weeklyEntries[index];
              final isMe = entry.odId == _authService.profile?.id;
              return _buildLeaderboardEntry(entry, isMe);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChainTab() {
    if (!_blockchain.isConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.link_off, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              'Not connected to blockchain',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_chainEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              'No on-chain entries yet',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _chainEntries.length,
      itemBuilder: (context, index) {
        final entry = _chainEntries[index];
        final isMe = entry.address.toLowerCase() == _blockchain.address?.hex.toLowerCase();
        return _buildChainEntry(index + 1, entry, isMe);
      },
    );
  }

  Widget _buildMyRankCard(WeeklyLeaderboardEntry entry) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.orange.shade800],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${entry.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Rank This Week',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildMiniStat(Icons.directions_walk, entry.formattedDistance),
                    const SizedBox(width: 16),
                    _buildMiniStat(Icons.flag, '${entry.markerCount} markers'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLeaderboardEntry(WeeklyLeaderboardEntry entry, bool isMe) {
    Color playerColor;
    try {
      final colorHex = entry.playerColor.replaceAll('#', '');
      playerColor = Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      playerColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.amber.withAlpha(30) : const Color(0xFF2a2a3e),
        borderRadius: BorderRadius.circular(12),
        border: isMe ? Border.all(color: Colors.amber, width: 2) : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: _buildRankBadge(entry.rank),
          ),
          const SizedBox(width: 12),
          // Player avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: playerColor.withAlpha(50),
              shape: BoxShape.circle,
              border: Border.all(color: playerColor, width: 2),
            ),
            child: Center(
              child: Text(
                entry.playerName.isNotEmpty ? entry.playerName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: playerColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.playerName,
                  style: TextStyle(
                    color: isMe ? Colors.amber : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.directions_walk, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      entry.formattedDistance,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.flag, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.markerCount}',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Distance highlight
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.formattedDistance,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${entry.sessionCount} sessions',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChainEntry(int rank, LeaderboardEntry entry, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.purple.withAlpha(30) : const Color(0xFF2a2a3e),
        borderRadius: BorderRadius.circular(12),
        border: isMe ? Border.all(color: Colors.purple, width: 2) : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: _buildRankBadge(rank),
          ),
          const SizedBox(width: 12),
          // Address avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.blue.shade400],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          // Address
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _shortenAddress(entry.address),
                  style: TextStyle(
                    color: isMe ? Colors.purple.shade200 : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.flag, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.markerCount} markers',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    if (entry.distanceMeters > 0) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.directions_walk, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.distanceKm.toStringAsFixed(2)} km',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Markers highlight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${entry.markerCount}',
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    IconData? icon;

    switch (rank) {
      case 1:
        badgeColor = Colors.amber;
        icon = Icons.emoji_events;
        break;
      case 2:
        badgeColor = Colors.grey.shade400;
        icon = Icons.emoji_events;
        break;
      case 3:
        badgeColor = Colors.brown.shade300;
        icon = Icons.emoji_events;
        break;
      default:
        badgeColor = Colors.grey.shade600;
        icon = null;
    }

    if (icon != null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: badgeColor.withAlpha(30),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: badgeColor, size: 20),
      );
    }

    return Text(
      '#$rank',
      style: TextStyle(
        color: badgeColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _shortenAddress(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
