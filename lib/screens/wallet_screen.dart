import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/blockchain_service.dart';
import '../services/isar_db.dart';
import '../services/rwa_service.dart';
import '../services/game_token_service.dart';
import '../config/chain_config.dart';
import 'staking_screen.dart';
import 'governance_screen.dart';

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
  final GameTokenService _gameTokenService = GameTokenService();

  bool _isLoading = true;
  bool _isClaiming = false;
  double _maticBalance = 0;
  Map<String, double> _collectedCoins = {};
  Map<String, double> _onChainBalances = {};
  int _totalMarkers = 0;
  List<_Transaction> _transactions = [];

  // Token definitions with colors and icons
  static final Map<String, _CryptoCoin> _cryptoCoins = {
    'MATIC': _CryptoCoin('Polygon', 'MATIC', Colors.purple, '⬡', 1.0),
    'MNT': _CryptoCoin('Mantle', 'MNT', Colors.teal, 'M', 1.0),
    'gMNT': _CryptoCoin('Game Mantle', 'gMNT', Colors.teal, 'M', 0.5),
    'gPOL': _CryptoCoin('Game Polygon', 'gPOL', Colors.purple, '⬡', 0.1),
    'gBNB': _CryptoCoin('Game BNB', 'gBNB', Colors.amber, '◆', 0.01),
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
    _initGameTokenService();
    _loadWalletData();
  }

  Future<void> _initGameTokenService() async {
    final privateKey = _auth.privateKey;
    if (privateKey != null && privateKey.isNotEmpty) {
      try {
        await _gameTokenService.initialize(privateKey);
      } catch (e) {
        debugPrint('Failed to init GameTokenService: $e');
      }
    }
  }

  Future<void> _loadWalletData() async {
    setState(() => _isLoading = true);

    try {
      // Get native token balance
      if (_blockchain.isConnected) {
        _maticBalance = await _blockchain.getBalance();
      }

      // Load collected game coins from database
      final collectedCoins = await _db.getGameCoinBalances();

      // Load markers count
      final delhiMarkers = await _db.getCityMarkers('delhi');
      final hydMarkers = await _db.getCityMarkers('hyderabad');
      final myMarkers = [
        ...delhiMarkers.where((m) => m.playerId == _auth.playerId),
        ...hydMarkers.where((m) => m.playerId == _auth.playerId),
      ];

      // Use collected coins from database
      _collectedCoins = collectedCoins;

      // Load on-chain balances for game tokens
      if (_gameTokenService.isInitialized) {
        try {
          final onChainBalance = await _gameTokenService.getOnChainBalance();
          final symbol = _gameTokenService.currentChain?.gameTokenSymbol ?? 'gMNT';
          _onChainBalances[symbol] = onChainBalance.toDouble() / 1e18;
        } catch (e) {
          debugPrint('Failed to get on-chain balance: $e');
        }
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
              GestureDetector(
                onTap: _showChainSelector,
                child: Container(
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
                        _blockchain.currentChain?.shortName ?? 'Mantle Sepolia',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.expand_more,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                    ],
                  ),
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
                icon: Icons.lock,
                label: 'Staking',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StakingScreen()),
                ),
              ),
              _ActionButton(
                icon: Icons.how_to_vote,
                label: 'Vote',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GovernanceScreen()),
                ),
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

    // Add game coins (gMNT, gPOL, gBNB)
    final gameSymbols = ['gMNT', 'gPOL', 'gBNB'];
    for (final symbol in gameSymbols) {
      final coin = _cryptoCoins[symbol]!;
      final pendingBalance = _collectedCoins[symbol] ?? 0.0;
      final onChainBalance = _onChainBalances[symbol] ?? 0.0;

      coinsList.add(_CoinTile(
        coin: coin,
        balance: pendingBalance,
        onChainBalance: onChainBalance,
        isGameCoin: true,
        canClaim: pendingBalance > 0,
        isClaiming: _isClaiming,
        onClaim: () => _claimGameTokens(symbol),
      ));
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
                value: _collectedCoins.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2),
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

        // RWA Yield Card
        _buildRWACard(),
        const SizedBox(height: 16),

        // Disclaimer card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Important Disclaimer',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '⚠️ Testnet Tokens: All tokens on testnet (gMNT, gPOL, gBNB) have NO monetary value. '
                'They are for testing purposes only.\n\n'
                '🔒 Wallet Security: Never share your private key. Keep it secure and backed up.\n\n'
                '⚡ Gas Fees: Blockchain transactions require gas fees in native tokens (MATIC/MNT/BNB).',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

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

  Widget _buildRWACard() {
    return Consumer<RWAService>(
      builder: (context, rwaService, _) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StakingScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.2),
                  Colors.teal.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yield & Staking',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stake markers for ${rwaService.stakingInfo?.formattedAPY ?? '8%'} APY',
                        style: TextStyle(
                          color: Colors.greenAccent.shade200,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.greenAccent,
                  size: 16,
                ),
              ],
            ),
          ),
        );
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

  void _showChainSelector() {
    final deployedChains = SupportedChains.deployedChains;
    final currentChain = _blockchain.currentChain;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Network',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose which blockchain network to use',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ...deployedChains.map((chain) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: chain.type == currentChain?.type
                          ? Colors.greenAccent.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getChainIcon(chain.type),
                      color: chain.type == currentChain?.type
                          ? Colors.greenAccent
                          : Colors.grey,
                    ),
                  ),
                  title: Text(
                    chain.name,
                    style: TextStyle(
                      color: chain.type == currentChain?.type
                          ? Colors.greenAccent
                          : Colors.white,
                      fontWeight: chain.type == currentChain?.type
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    chain.isTestnet ? 'Testnet' : 'Mainnet',
                    style: TextStyle(
                      color: chain.isTestnet ? Colors.amber : Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                  trailing: chain.type == currentChain?.type
                      ? const Icon(Icons.check_circle, color: Colors.greenAccent)
                      : null,
                  onTap: () async {
                    Navigator.pop(context);
                    if (chain.type != currentChain?.type) {
                      await _switchChain(chain.type);
                    }
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  IconData _getChainIcon(ChainType type) {
    switch (type) {
      case ChainType.mantleSepolia:
      case ChainType.mantleMainnet:
        return Icons.layers;
      case ChainType.polygonAmoy:
      case ChainType.polygonMainnet:
        return Icons.hexagon;
      case ChainType.bnbTestnet:
      case ChainType.bnbMainnet:
        return Icons.currency_bitcoin;
    }
  }

  Future<void> _switchChain(ChainType chainType) async {
    setState(() => _isLoading = true);

    try {
      final success = await _blockchain.switchChain(chainType);
      if (success) {
        // Also switch RWA service
        final rwaService = context.read<RWAService>();
        await rwaService.switchChain(chainType);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched to ${SupportedChains.getByType(chainType).name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _loadWalletData();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to switch chain'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _claimGameTokens(String coinSymbol) async {
    if (_isClaiming) return;

    final pendingAmount = _collectedCoins[coinSymbol] ?? 0.0;
    if (pendingAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No coins to claim')),
      );
      return;
    }

    setState(() => _isClaiming = true);

    try {
      // Request signature from backend
      final signatureData = await _gameTokenService.requestClaimSignature(
        coinSymbol,
        pendingAmount,
      );

      if (signatureData == null) {
        throw Exception('Failed to get claim signature from backend');
      }

      // Parse claim data
      final amount = BigInt.parse(signatureData['amount'].toString());
      final claimId = _hexToBytes(signatureData['claimId']);
      final expiry = BigInt.from(signatureData['expiry']);
      final signature = _hexToBytes(signatureData['signature']);

      // Execute claim on-chain
      final txHash = await _gameTokenService.claimTokens(
        amount: amount,
        claimId: claimId,
        expiry: expiry,
        signature: signature,
        db: _db,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Claimed $pendingAmount $coinSymbol!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // Open explorer
              },
            ),
          ),
        );
        await _loadWalletData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Claim failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isClaiming = false);
      }
    }
  }

  Uint8List _hexToBytes(String hex) {
    hex = hex.startsWith('0x') ? hex.substring(2) : hex;
    final bytes = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
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
  final double onChainBalance;
  final bool isNative;
  final bool isGameCoin;
  final bool canClaim;
  final bool isClaiming;
  final VoidCallback? onClaim;

  const _CoinTile({
    required this.coin,
    required this.balance,
    this.onChainBalance = 0,
    this.isNative = false,
    this.isGameCoin = false,
    this.canClaim = false,
    this.isClaiming = false,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final hasBalance = balance > 0 || onChainBalance > 0;
    final totalBalance = balance + onChainBalance;

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
      child: Column(
        children: [
          Row(
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
                        if (isGameCoin) ...[
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
                        ? totalBalance.toStringAsFixed(4)
                        : totalBalance.toStringAsFixed(2),
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

          // Show pending balance and claim button for game coins
          if (isGameCoin && (balance > 0 || onChainBalance > 0)) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'On-chain:',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              onChainBalance.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pending:',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              balance.toStringAsFixed(2),
                              style: TextStyle(
                                color: balance > 0 ? Colors.amber : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (canClaim) ...[
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: isClaiming ? null : onClaim,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: coin.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: isClaiming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Claim'),
                    ),
                  ],
                ],
              ),
            ),
          ],
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
