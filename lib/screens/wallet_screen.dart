import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/blockchain_service.dart';
import '../services/isar_db.dart';

/// Wallet screen displaying user's crypto coins and tokens
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AuthService _auth;
  late BlockchainService _blockchain;
  late IsarDBService _db;

  bool _isLoading = true;
  double _maticBalance = 0;
  Map<String, int> _collectedCoins = {};
  int _totalMarkers = 0;
  List<_Transaction> _transactions = [];

  // Crypto coin definitions with colors and icons
  static final Map<String, _CryptoCoin> _cryptoCoins = {
    'BTC': _CryptoCoin('Bitcoin', 'BTC', Colors.orange, '₿', 0.00001),
    'ETH': _CryptoCoin('Ethereum', 'ETH', Colors.blue.shade700, 'Ξ', 0.0001),
    'MATIC': _CryptoCoin('Polygon', 'MATIC', Colors.purple, '⬡', 1.0),
    'SOL': _CryptoCoin('Solana', 'SOL', Colors.teal, '◎', 0.001),
    'DOGE': _CryptoCoin('Dogecoin', 'DOGE', Colors.amber, 'Ð', 0.1),
    'ADA': _CryptoCoin('Cardano', 'ADA', Colors.blue, '₳', 0.01),
    'XRP': _CryptoCoin('Ripple', 'XRP', Colors.grey.shade700, '✕', 0.01),
    'LTC': _CryptoCoin('Litecoin', 'LTC', Colors.grey, 'Ł', 0.001),
  };

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
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    setState(() => _isLoading = true);

    try {
      // Get MATIC balance
      if (_blockchain.isConnected) {
        _maticBalance = await _blockchain.getBalance();
      }

      // Load collected coins from database
      final collectedCoins = await _db.getCollectedCoins();

      // Load markers count
      final delhiMarkers = await _db.getCityMarkers('delhi');
      final hydMarkers = await _db.getCityMarkers('hyderabad');
      final myMarkers = [
        ...delhiMarkers.where((m) => m.playerId == _auth.playerId),
        ...hydMarkers.where((m) => m.playerId == _auth.playerId),
      ];

      // Generate some demo coins based on markers if no coins collected
      if (collectedCoins.isEmpty && myMarkers.isNotEmpty) {
        // Award coins based on markers placed
        _collectedCoins = {
          'MATIC': myMarkers.length * 10,
          'DOGE': myMarkers.length * 5,
        };
        if (myMarkers.length >= 5) {
          _collectedCoins['ETH'] = myMarkers.length ~/ 5;
        }
        if (myMarkers.length >= 10) {
          _collectedCoins['BTC'] = myMarkers.length ~/ 10;
        }
      } else {
        _collectedCoins = collectedCoins;
      }

      _totalMarkers = myMarkers.length;

      // Build transaction history from markers
      _transactions = myMarkers
          .take(10)
          .map((m) => _Transaction(
                type: TransactionType.reward,
                coin: 'MATIC',
                amount: 10,
                description: 'Marker at ${m.landmarkName}',
                timestamp: DateTime.fromMillisecondsSinceEpoch(m.timestamp),
                txHash: m.txHash,
              ))
          .toList();

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading wallet: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _auth.profile;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWalletData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Assets', icon: Icon(Icons.account_balance_wallet)),
            Tab(text: 'Activity', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Wallet Header
          _buildWalletHeader(profile),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssetsTab(),
                _buildActivityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletHeader(PlayerProfile? profile) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade900,
            Colors.purple.shade700,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Network badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _blockchain.isConnected
                            ? Colors.green
                            : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Polygon Amoy',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.qr_code, color: Colors.white70),
                onPressed: _showQRCode,
                tooltip: 'Show QR Code',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Total Balance
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _maticBalance.toStringAsFixed(4),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, left: 8),
                  child: Text(
                    'MATIC',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 20),

          // Wallet Address
          GestureDetector(
            onTap: () => _copyAddress(profile?.walletAddress ?? ''),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white54,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _shortenAddress(profile?.walletAddress ?? ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.copy,
                    color: Colors.white54,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.arrow_downward,
                label: 'Receive',
                onTap: _showReceive,
              ),
              _ActionButton(
                icon: Icons.arrow_upward,
                label: 'Send',
                onTap: _showSend,
              ),
              _ActionButton(
                icon: Icons.swap_horiz,
                label: 'Swap',
                onTap: _showSwap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Build list of coins with balances
    final coinsList = <Widget>[];

    // Always show MATIC first
    coinsList.add(_CoinTile(
      coin: _cryptoCoins['MATIC']!,
      balance: _maticBalance,
      isNative: true,
    ));

    // Add collected game coins
    for (final entry in _collectedCoins.entries) {
      if (entry.key != 'MATIC' && _cryptoCoins.containsKey(entry.key)) {
        final coin = _cryptoCoins[entry.key]!;
        coinsList.add(_CoinTile(
          coin: coin,
          balance: entry.value.toDouble(),
          isGameCoin: true,
        ));
      }
    }

    // Show empty coins with 0 balance
    for (final coin in _cryptoCoins.values) {
      if (coin.symbol != 'MATIC' && !_collectedCoins.containsKey(coin.symbol)) {
        coinsList.add(_CoinTile(
          coin: coin,
          balance: 0,
          isGameCoin: true,
        ));
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats row
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Markers Placed',
                value: _totalMarkers.toString(),
                icon: Icons.flag,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Coins Collected',
                value: _collectedCoins.values.fold(0, (a, b) => a + b).toString(),
                icon: Icons.monetization_on,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section header
        const Row(
          children: [
            Icon(Icons.toll, color: Colors.white54, size: 20),
            SizedBox(width: 8),
            Text(
              'Your Assets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Coins list
        ...coinsList,

        const SizedBox(height: 24),

        // Info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Earn More Coins',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Walk to landmarks and collect crypto coins spawned on the map!',
                      style: TextStyle(
                        color: Colors.blue.shade200,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade700),
            const SizedBox(height: 16),
            const Text(
              'No transactions yet',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Start collecting markers to earn rewards!',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        return _TransactionTile(transaction: tx);
      },
    );
  }

  void _copyAddress(String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _shortenAddress(String address) {
    if (address.length < 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  void _showQRCode() {
    final address = _auth.profile?.walletAddress ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Your Wallet Address',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, size: 120, color: Colors.grey.shade800),
                    const SizedBox(height: 8),
                    const Text(
                      'QR Code',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                address,
                style: const TextStyle(
                  color: Colors.green,
                  fontFamily: 'monospace',
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _copyAddress(address);
              Navigator.pop(context);
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

  void _showReceive() {
    _showQRCode(); // Same as QR code for receiving
  }

  void _showSend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Send Tokens', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 48, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'Coming Soon!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Token transfers will be available in a future update.',
              style: TextStyle(color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSwap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Swap Tokens', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_horiz, size: 48, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'Coming Soon!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Token swaps will be available in a future update.',
              style: TextStyle(color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Helper Classes

class _CryptoCoin {
  final String name;
  final String symbol;
  final Color color;
  final String icon;
  final double valueMultiplier;

  const _CryptoCoin(
    this.name,
    this.symbol,
    this.color,
    this.icon,
    this.valueMultiplier,
  );
}

class _CoinTile extends StatelessWidget {
  final _CryptoCoin coin;
  final double balance;
  final bool isNative;
  final bool isGameCoin;

  const _CoinTile({
    required this.coin,
    required this.balance,
    this.isNative = false,
    this.isGameCoin = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasBalance = balance > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasBalance
            ? coin.color.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasBalance
              ? coin.color.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Coin icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: hasBalance ? coin.color : Colors.grey.shade800,
              shape: BoxShape.circle,
              boxShadow: hasBalance
                  ? [
                      BoxShadow(
                        color: coin.color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                coin.icon,
                style: TextStyle(
                  color: hasBalance ? Colors.white : Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Coin info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      coin.name,
                      style: TextStyle(
                        color: hasBalance ? Colors.white : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isNative) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NATIVE',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (isGameCoin && hasBalance) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'GAME',
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  coin.symbol,
                  style: TextStyle(
                    color: hasBalance ? Colors.grey.shade400 : Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isNative
                    ? balance.toStringAsFixed(4)
                    : balance.toInt().toString(),
                style: TextStyle(
                  color: hasBalance ? Colors.white : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!hasBalance)
                Text(
                  'Collect to earn',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
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
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum TransactionType { reward, send, receive }

class _Transaction {
  final TransactionType type;
  final String coin;
  final double amount;
  final String description;
  final DateTime timestamp;
  final String? txHash;

  const _Transaction({
    required this.type,
    required this.coin,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.txHash,
  });
}

class _TransactionTile extends StatelessWidget {
  final _Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isReward = transaction.type == TransactionType.reward;
    final color = isReward ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
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
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isReward ? Icons.add : Icons.remove,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatTimeAgo(transaction.timestamp),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isReward ? '+' : '-'}${transaction.amount.toInt()} ${transaction.coin}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transaction.txHash != null && transaction.txHash!.isNotEmpty)
                Text(
                  'On-chain',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
            ],
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
