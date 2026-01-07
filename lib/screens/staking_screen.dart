import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rwa_service.dart';
import '../widgets/yield_calculator_widget.dart';

/// Staking screen for marker staking and yield management
class StakingScreen extends StatefulWidget {
  const StakingScreen({super.key});

  @override
  State<StakingScreen> createState() => _StakingScreenState();
}

class _StakingScreenState extends State<StakingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<int> _stakedMarkerIds = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final rwaService = context.read<RWAService>();
    await rwaService.getStakingInfo();
    _stakedMarkerIds = await rwaService.getStakedMarkers();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Staking & Yield',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.greenAccent,
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Stake', icon: Icon(Icons.lock)),
            Tab(text: 'Yield', icon: Icon(Icons.attach_money)),
            Tab(text: 'RUN', icon: Icon(Icons.token)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildStakingTab(),
                _buildYieldTab(),
                _buildRUNTokenTab(),
              ],
            ),
    );
  }

  Widget _buildStakingTab() {
    return Consumer<RWAService>(
      builder: (context, rwaService, _) {
        final stakingInfo = rwaService.stakingInfo;

        return RefreshIndicator(
          onRefresh: _loadData,
          color: Colors.greenAccent,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Staking Overview Card
              _buildOverviewCard(stakingInfo),
              const SizedBox(height: 16),

              // Yield Calculator
              const YieldCalculatorWidget(),
              const SizedBox(height: 16),

              // Claim Yield Button
              if (stakingInfo != null && stakingInfo.pendingYield > BigInt.zero)
                _buildClaimButton(rwaService),
              const SizedBox(height: 16),

              // Staked Markers List
              _buildStakedMarkersList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewCard(StakingInfo? info) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.3),
            Colors.teal.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Staking Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  info?.formattedAPY ?? '8%',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Staked Markers',
                  '${info?.totalStakedMarkers ?? 0}',
                  Icons.location_on,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Leaderboard',
                  info?.leaderboardRank != null && info!.leaderboardRank > 0
                      ? '#${info.leaderboardRank}'
                      : 'Unranked',
                  Icons.leaderboard,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Multiplier',
                  info?.formattedMultiplier ?? '1.0x',
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Pending Yield',
                  _formatYield(info?.pendingYield),
                  Icons.savings,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildClaimButton(RWAService rwaService) {
    return ElevatedButton(
      onPressed: () async {
        final txHash = await rwaService.claimStakingYield();
        if (txHash != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yield claimed! Tx: ${txHash.substring(0, 10)}...'),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet),
          SizedBox(width: 8),
          Text(
            'Claim All Yield',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStakedMarkersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Staked Markers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_stakedMarkerIds.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'No staked markers yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Stake your landmark markers to earn yield',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(_stakedMarkerIds.length, (index) {
            return _buildStakedMarkerTile(_stakedMarkerIds[index]);
          }),
      ],
    );
  }

  Widget _buildStakedMarkerTile(int markerId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.location_on, color: Colors.greenAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marker #$markerId',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Earning yield...',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _unstakeMarker(markerId),
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            tooltip: 'Unstake',
          ),
        ],
      ),
    );
  }

  Future<void> _unstakeMarker(int markerId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Unstake Marker', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to unstake this marker? You will stop earning yield from it.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Unstake', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final rwaService = context.read<RWAService>();
      final txHash = await rwaService.unstakeMarker(markerId);
      if (txHash != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Marker unstaked! Tx: ${txHash.substring(0, 10)}...'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadData();
      }
    }
  }

  Widget _buildYieldTab() {
    return Consumer<RWAService>(
      builder: (context, rwaService, _) {
        final yieldTokens = rwaService.yieldTokens;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Yield Tokens Header
            const Text(
              'Landmark Yield Tokens',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Earn yield from sponsor pools when you visit landmarks',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),

            if (yieldTokens.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.token, color: Colors.grey, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'No yield tokens yet',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Visit landmarks while running to earn yield tokens',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...yieldTokens.map((token) => _buildYieldTokenTile(token)),
          ],
        );
      },
    );
  }

  Widget _buildYieldTokenTile(YieldToken token) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                token.landmarkName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${token.balance} YLD',
                  style: const TextStyle(color: Colors.purpleAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pending: ${_formatYield(token.pendingYield)}',
                style: const TextStyle(color: Colors.greenAccent),
              ),
              TextButton(
                onPressed: token.pendingYield > BigInt.zero
                    ? () => _claimTokenYield(token.tokenId)
                    : null,
                child: const Text('Claim'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _claimTokenYield(BigInt tokenId) async {
    final rwaService = context.read<RWAService>();
    final txHash = await rwaService.claimYield(tokenId);
    if (txHash != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yield claimed! Tx: ${txHash.substring(0, 10)}...'),
          backgroundColor: Colors.green,
        ),
      );
      _loadData();
    }
  }

  Widget _buildRUNTokenTab() {
    return Consumer<RWAService>(
      builder: (context, rwaService, _) {
        return FutureBuilder<BigInt>(
          future: rwaService.getRUNBalance(),
          builder: (context, snapshot) {
            final balance = snapshot.data ?? BigInt.zero;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // RUN Token Balance Card
                _buildRUNBalanceCard(balance),
                const SizedBox(height: 16),

                // Boost Section
                _buildBoostSection(rwaService),
                const SizedBox(height: 16),

                // Stake RUN Section
                _buildStakeRUNSection(rwaService),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRUNBalanceCard(BigInt balance) {
    final balanceFormatted = (balance / BigInt.from(10).pow(18)).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.3),
            Colors.red.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Icon(Icons.token, color: Colors.orangeAccent, size: 48),
          const SizedBox(height: 16),
          Text(
            '$balanceFormatted RUN',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Governance & Utility Token',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBoostSection(RWAService rwaService) {
    return FutureBuilder<BoostInfo?>(
      future: rwaService.getActiveBoost(),
      builder: (context, snapshot) {
        final boost = snapshot.data;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Run Boost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (boost != null && boost.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${boost.multiplierValue}x Active',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Burn 10% of your RUN tokens to get a 1.2x run multiplier for 24 hours',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              if (boost != null && boost.isActive)
                Text(
                  'Expires in: ${_formatDuration(boost.timeRemaining)}',
                  style: const TextStyle(color: Colors.orangeAccent),
                )
              else
                ElevatedButton(
                  onPressed: () => _activateBoost(rwaService),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Activate Boost'),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _activateBoost(RWAService rwaService) async {
    final balance = await rwaService.getRUNBalance();
    final boostCost = balance * BigInt.from(10) ~/ BigInt.from(100); // 10%

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Activate Boost', style: TextStyle(color: Colors.white)),
        content: Text(
          'This will burn ${(boostCost / BigInt.from(10).pow(18)).toStringAsFixed(2)} RUN tokens to give you a 1.2x multiplier for 24 hours.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Activate', style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final txHash = await rwaService.activateBoost(boostCost);
      if (txHash != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Boost activated! Tx: ${txHash.substring(0, 10)}...'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {});
      }
    }
  }

  Widget _buildStakeRUNSection(RWAService rwaService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stake RUN for LP Yield',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Stake your RUN tokens to earn a share of game fees',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Show stake dialog
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.greenAccent,
                    side: const BorderSide(color: Colors.greenAccent),
                  ),
                  child: const Text('Stake'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Show unstake dialog
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orangeAccent,
                    side: const BorderSide(color: Colors.orangeAccent),
                  ),
                  child: const Text('Unstake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatYield(BigInt? yield) {
    if (yield == null || yield == BigInt.zero) return '0 ETH';
    final eth = (yield / BigInt.from(10).pow(18));
    return '${eth.toStringAsFixed(6)} ETH';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }
}
