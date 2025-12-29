import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/blockchain_service.dart';
import '../services/isar_db.dart';
import '../models/marker.dart';

/// Detailed user profile screen
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late AuthService _auth;
  late BlockchainService _blockchain;
  late IsarDBService _db;

  bool _isLoading = true;
  double _walletBalance = 0;
  int _totalMarkers = 0;
  int _delhiMarkers = 0;
  int _hydMarkers = 0;
  int _landmarksVisited = 0;
  List<GPSMarker> _recentMarkers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = context.read<AuthService>();
    _blockchain = context.read<BlockchainService>();
    _db = context.read<IsarDBService>();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);

    try {
      // Load markers from database
      final delhiMarkers = await _db.getCityMarkers('delhi');
      final hydMarkers = await _db.getCityMarkers('hyderabad');

      // Filter for current user
      final myDelhiMarkers = delhiMarkers
          .where((m) => m.playerId == _auth.playerId)
          .toList();
      final myHydMarkers = hydMarkers
          .where((m) => m.playerId == _auth.playerId)
          .toList();

      // Get unique landmarks
      final allMyMarkers = [...myDelhiMarkers, ...myHydMarkers];
      final uniqueLandmarks = allMyMarkers
          .map((m) => m.landmarkName)
          .toSet()
          .length;

      // Sort by timestamp for recent markers
      allMyMarkers.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Get wallet balance
      double balance = 0;
      if (_blockchain.isConnected) {
        balance = await _blockchain.getBalance();
      }

      if (mounted) {
        setState(() {
          _delhiMarkers = myDelhiMarkers.length;
          _hydMarkers = myHydMarkers.length;
          _totalMarkers = allMyMarkers.length;
          _landmarksVisited = uniqueLandmarks;
          _walletBalance = balance;
          _recentMarkers = allMyMarkers.take(5).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading stats: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _auth.profile;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Not logged in')),
      );
    }

    final isGoogle = profile.authProvider == AuthProvider.google;
    final profileColor = Color(
      int.parse(profile.color.replaceFirst('#', '0xFF')),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: profileColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      profileColor,
                      profileColor.withOpacity(0.8),
                      Colors.black87,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: profileColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
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
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          // Badge for auth type
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isGoogle ? Colors.white : Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: profileColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                isGoogle ? Icons.g_mobiledata : Icons.person,
                                size: 20,
                                color: isGoogle ? Colors.blue : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email or account type
                      Text(
                        profile.email.isNotEmpty
                            ? profile.email
                            : 'Guest Account',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Member since
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Member since ${_formatDate(profile.createdAt)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editProfile,
              ),
            ],
          ),

          // Stats Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.flag,
                          label: 'Total Markers',
                          value: _totalMarkers.toString(),
                          color: Colors.blue,
                          isLoading: _isLoading,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.place,
                          label: 'Landmarks',
                          value: _landmarksVisited.toString(),
                          color: Colors.amber,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.location_city,
                          label: 'Delhi',
                          value: _delhiMarkers.toString(),
                          color: Colors.orange,
                          isLoading: _isLoading,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.location_city,
                          label: 'Hyderabad',
                          value: _hydMarkers.toString(),
                          color: Colors.green,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Wallet Section
                  _SectionHeader(
                    icon: Icons.account_balance_wallet,
                    title: 'Wallet',
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _WalletCard(
                    address: profile.walletAddress,
                    balance: _walletBalance,
                    isConnected: _blockchain.isConnected,
                    isLoading: _isLoading,
                    onCopy: () => _copyWalletAddress(profile.walletAddress),
                    onExportKey: _exportPrivateKey,
                  ),

                  const SizedBox(height: 24),

                  // Achievements Section
                  _SectionHeader(
                    icon: Icons.emoji_events,
                    title: 'Achievements',
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  _AchievementsGrid(
                    totalMarkers: _totalMarkers,
                    landmarksVisited: _landmarksVisited,
                    delhiMarkers: _delhiMarkers,
                    hydMarkers: _hydMarkers,
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity Section
                  _SectionHeader(
                    icon: Icons.history,
                    title: 'Recent Activity',
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_recentMarkers.isEmpty)
                    _EmptyState(
                      icon: Icons.directions_run,
                      message: 'No markers yet. Start exploring!',
                    )
                  else
                    ..._recentMarkers.map((marker) => _ActivityTile(marker: marker)),

                  const SizedBox(height: 24),

                  // Account Actions
                  _SectionHeader(
                    icon: Icons.settings,
                    title: 'Account',
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _AccountActions(
                    isGoogle: isGoogle,
                    onChangeName: _changeName,
                    onChangeColor: _changeColor,
                    onSignOut: _signOut,
                    onDeleteAccount: _deleteAccount,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _copyWalletAddress(String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wallet address copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _exportPrivateKey() async {
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
        backgroundColor: Colors.grey.shade900,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Private Key', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                privateKey,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'NEVER share your private key!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Store this safely to recover your wallet on another device.',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: privateKey));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Private key copied!')),
              );
            },
            child: const Text('Copy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Change Name',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _changeName();
              },
            ),
            ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.purple),
              title: const Text('Change Color',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _changeColor();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeName() {
    final controller = TextEditingController(text: _auth.playerName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Change Name', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Runner Name',
            labelStyle: TextStyle(color: Colors.grey.shade400),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
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
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changeColor() {
    final colors = [
      '#2196F3', '#4CAF50', '#F44336', '#FF9800',
      '#9C27B0', '#00BCD4', '#E91E63', '#FFEB3B',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Choose Color', style: TextStyle(color: Colors.white)),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            final isSelected = color == _auth.playerColor;
            return GestureDetector(
              onTap: () {
                _auth.updateColor(color);
                Navigator.pop(context);
                setState(() {});
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(int.parse(color.replaceFirst('#', '0xFF')))
                                .withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Sign Out?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'You will need to sign in again to access your account.',
          style: TextStyle(color: Colors.white70),
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
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Account?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'This will permanently delete your account and all local data. '
          'Blockchain markers will remain on-chain.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _auth.deleteAccount();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}

// Helper Widgets

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isLoading;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String address;
  final double balance;
  final bool isConnected;
  final bool isLoading;
  final VoidCallback onCopy;
  final VoidCallback onExportKey;

  const _WalletCard({
    required this.address,
    required this.balance,
    required this.isConnected,
    required this.isLoading,
    required this.onCopy,
    required this.onExportKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade900, Colors.purple.shade700],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Polygon Amoy',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle : Icons.cloud_off,
                      color: isConnected ? Colors.green : Colors.orange,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isConnected ? 'Connected' : 'Offline',
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.orange,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Address
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.copy, color: Colors.white54, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Balance
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    Text(
                      '${balance.toStringAsFixed(4)} MATIC',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: onExportKey,
                icon: const Icon(Icons.key, size: 16),
                label: const Text('Export Key'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.amber,
                  side: const BorderSide(color: Colors.amber),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementsGrid extends StatelessWidget {
  final int totalMarkers;
  final int landmarksVisited;
  final int delhiMarkers;
  final int hydMarkers;

  const _AchievementsGrid({
    required this.totalMarkers,
    required this.landmarksVisited,
    required this.delhiMarkers,
    required this.hydMarkers,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _Achievement(
        icon: Icons.flag,
        title: 'First Marker',
        description: 'Place your first marker',
        unlocked: totalMarkers >= 1,
      ),
      _Achievement(
        icon: Icons.looks_5,
        title: 'Explorer',
        description: 'Place 5 markers',
        unlocked: totalMarkers >= 5,
      ),
      _Achievement(
        icon: Icons.emoji_events,
        title: 'Champion',
        description: 'Place 20 markers',
        unlocked: totalMarkers >= 20,
      ),
      _Achievement(
        icon: Icons.place,
        title: 'Landmark Hunter',
        description: 'Visit 5 different landmarks',
        unlocked: landmarksVisited >= 5,
      ),
      _Achievement(
        icon: Icons.location_city,
        title: 'Delhi Explorer',
        description: 'Place 5 markers in Delhi',
        unlocked: delhiMarkers >= 5,
      ),
      _Achievement(
        icon: Icons.location_city,
        title: 'Hyd Explorer',
        description: 'Place 5 markers in Hyderabad',
        unlocked: hydMarkers >= 5,
      ),
      _Achievement(
        icon: Icons.public,
        title: 'Dual City Runner',
        description: 'Visit both cities',
        unlocked: delhiMarkers > 0 && hydMarkers > 0,
      ),
      _Achievement(
        icon: Icons.star,
        title: 'Legend',
        description: 'Place 50 markers',
        unlocked: totalMarkers >= 50,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: achievements.map((a) => _AchievementBadge(achievement: a)).toList(),
    );
  }
}

class _Achievement {
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;

  const _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });
}

class _AchievementBadge extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${achievement.title}: ${achievement.description}',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: 70,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: achievement.unlocked
              ? Colors.amber.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: achievement.unlocked
                ? Colors.amber.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              achievement.icon,
              color: achievement.unlocked ? Colors.amber : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.title,
              style: TextStyle(
                color: achievement.unlocked ? Colors.white : Colors.grey,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final GPSMarker marker;

  const _ActivityTile({required this.marker});

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(marker.timestamp);
    final timeAgo = _formatTimeAgo(time);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(int.parse(marker.color.replaceFirst('#', '0xFF'))),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.flag, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marker.landmarkName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${marker.city.toUpperCase()} • $timeAgo',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            marker.syncedToChain ? Icons.verified : Icons.cloud_upload,
            color: marker.syncedToChain ? Colors.green : Colors.orange,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AccountActions extends StatelessWidget {
  final bool isGoogle;
  final VoidCallback onChangeName;
  final VoidCallback onChangeColor;
  final VoidCallback onSignOut;
  final VoidCallback onDeleteAccount;

  const _AccountActions({
    required this.isGoogle,
    required this.onChangeName,
    required this.onChangeColor,
    required this.onSignOut,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.person,
            iconColor: Colors.blue,
            title: 'Change Name',
            onTap: onChangeName,
          ),
          const Divider(height: 1, color: Colors.grey),
          _ActionTile(
            icon: Icons.color_lens,
            iconColor: Colors.purple,
            title: 'Change Color',
            onTap: onChangeColor,
          ),
          const Divider(height: 1, color: Colors.grey),
          _ActionTile(
            icon: Icons.logout,
            iconColor: Colors.orange,
            title: 'Sign Out',
            onTap: onSignOut,
          ),
          const Divider(height: 1, color: Colors.grey),
          _ActionTile(
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            title: 'Delete Account',
            onTap: onDeleteAccount,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
