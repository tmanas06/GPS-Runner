import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/footprint_service.dart';

/// Analytics screen powered by Footprint Analytics
/// Shows game metrics, NFT stats, and player analytics
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _useMockData = true; // Use mock data until API is verified

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
    final footprint = context.read<FootprintService>();
    await footprint.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.network(
              'https://www.footprint.network/favicon.ico',
              width: 24,
              height: 24,
              errorBuilder: (_, __, ___) => const Icon(Icons.analytics, color: Colors.blueAccent),
            ),
            const SizedBox(width: 8),
            const Text('Analytics', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _useMockData = !_useMockData);
            },
            icon: Icon(
              _useMockData ? Icons.cloud_off : Icons.cloud,
              color: _useMockData ? Colors.orange : Colors.greenAccent,
            ),
            tooltip: _useMockData ? 'Using mock data' : 'Using live data',
          ),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'NFTs', icon: Icon(Icons.token)),
            Tab(text: 'Activity', icon: Icon(Icons.timeline)),
          ],
        ),
      ),
      body: Consumer<FootprintService>(
        builder: (context, footprint, _) {
          if (footprint.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(footprint),
              _buildNFTsTab(footprint),
              _buildActivityTab(footprint),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(FootprintService footprint) {
    final stats = _useMockData ? GameStats.mock() : footprint.gameStats;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.blueAccent,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Powered by Footprint badge
          _buildFootprintBadge(),
          const SizedBox(height: 16),

          // Main stats cards
          _buildMainStatsGrid(stats),
          const SizedBox(height: 24),

          // Daily activity chart
          _buildDailyActivityChart(stats),
          const SizedBox(height: 24),

          // Contract addresses
          _buildContractAddresses(),
        ],
      ),
    );
  }

  Widget _buildFootprintBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, color: Colors.blueAccent, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Powered by Footprint Analytics',
            style: TextStyle(color: Colors.blueAccent, fontSize: 12),
          ),
          const Spacer(),
          if (_useMockData)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'DEMO',
                style: TextStyle(color: Colors.orange, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainStatsGrid(GameStats? stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Players',
          stats?.totalUsers.toString() ?? '---',
          Icons.people,
          Colors.greenAccent,
        ),
        _buildStatCard(
          'Active Today',
          stats?.activeUsersToday.toString() ?? '---',
          Icons.person_pin,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'Transactions',
          _formatNumber(stats?.totalTransactions ?? 0),
          Icons.receipt_long,
          Colors.purpleAccent,
        ),
        _buildStatCard(
          'Volume',
          '\$${_formatNumber(stats?.totalVolumeUSD.round() ?? 0)}',
          Icons.attach_money,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Icon(Icons.trending_up, color: Colors.green, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyActivityChart(GameStats? stats) {
    final dailyStats = stats?.dailyStats ?? [];

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
            'Daily Activity (30 days)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: dailyStats.isEmpty
                ? const Center(
                    child: Text('No data available', style: TextStyle(color: Colors.grey)),
                  )
                : _buildSimpleBarChart(dailyStats.take(14).toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleBarChart(List<DailyStats> data) {
    if (data.isEmpty) return const SizedBox();

    final maxUsers = data.map((d) => d.activeUsers).reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.reversed.map((day) {
        final height = maxUsers > 0 ? (day.activeUsers / maxUsers) * 120 : 0.0;
        return Tooltip(
          message: '${day.date.day}/${day.date.month}: ${day.activeUsers} users',
          child: Container(
            width: 16,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContractAddresses() {
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
            'Tracked Contracts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildContractRow('IndiaRunner', '0x94ec...67b'),
          _buildContractRow('LandmarkYield', '0x2aCF...Ce3'),
          _buildContractRow('MarkerStaking', '0xd4DD...Ab3'),
          _buildContractRow('RUN Token', '0x33c0...d44'),
          _buildContractRow('Governance', '0xFea5...1E9'),
        ],
      ),
    );
  }

  Widget _buildContractRow(String name, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.grey)),
          Text(
            address,
            style: const TextStyle(color: Colors.blueAccent, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildNFTsTab(FootprintService footprint) {
    final nftStats = _useMockData ? NFTStats.mock() : footprint.nftStats;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.blueAccent,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // NFT Collection Stats
          _buildNFTStatsCard(nftStats),
          const SizedBox(height: 24),

          // Recent Transactions
          _buildRecentTransactions(footprint),
        ],
      ),
    );
  }

  Widget _buildNFTStatsCard(NFTStats? stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.blue.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Landmark Yield NFTs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildNFTStatItem('Total Supply', '${stats?.totalSupply ?? 0}')),
              Expanded(child: _buildNFTStatItem('Holders', '${stats?.holders ?? 0}')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildNFTStatItem('Total Sales', '${stats?.totalSales ?? 0}')),
              Expanded(child: _buildNFTStatItem('Volume', '${stats?.totalVolumeETH.toStringAsFixed(2)} ETH')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildNFTStatItem('Total Sales', '${stats?.totalSales ?? 0}')),
              Expanded(child: _buildNFTStatItem('Floor', '${stats?.floorPrice.toStringAsFixed(4)} ETH')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNFTStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(FootprintService footprint) {
    final transactions = footprint.recentTransactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...transactions.take(10).map((tx) => _buildTransactionTile(tx)),
      ],
    );
  }

  Widget _buildTransactionTile(NFTTransaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.swap_horiz, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Token #${tx.tokenId}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${tx.shortSeller} -> ${tx.shortBuyer}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${tx.priceETH.toStringAsFixed(4)} ETH',
                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
              Text(
                tx.platform,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(FootprintService footprint) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.blueAccent,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Week over week comparison
          _buildWoWComparison(),
          const SizedBox(height: 24),

          // City distribution (placeholder)
          _buildCityDistribution(),
          const SizedBox(height: 24),

          // Top players
          _buildTopPlayersSection(footprint),
        ],
      ),
    );
  }

  Widget _buildWoWComparison() {
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
            'Week over Week',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWoWItem('Active Users', '+12%', true),
              ),
              Expanded(
                child: _buildWoWItem('Transactions', '+8%', true),
              ),
              Expanded(
                child: _buildWoWItem('Volume', '-3%', false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWoWItem(String label, String change, bool positive) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              positive ? Icons.arrow_upward : Icons.arrow_downward,
              color: positive ? Colors.green : Colors.red,
              size: 16,
            ),
            Text(
              change,
              style: TextStyle(
                color: positive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildCityDistribution() {
    final cities = [
      {'name': 'Delhi', 'percent': 35, 'color': Colors.blue},
      {'name': 'Mumbai', 'percent': 25, 'color': Colors.green},
      {'name': 'Bangalore', 'percent': 20, 'color': Colors.orange},
      {'name': 'Hyderabad', 'percent': 12, 'color': Colors.purple},
      {'name': 'Others', 'percent': 8, 'color': Colors.grey},
    ];

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
            'Player Distribution by City',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...cities.map((city) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    city['name'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (city['percent'] as int) / 100,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation(city['color'] as Color),
                      minHeight: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${city['percent']}%',
                  style: TextStyle(color: city['color'] as Color),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTopPlayersSection(FootprintService footprint) {
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
                'Top Runners (On-Chain)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Verified',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTopPlayerRow(1, '0xB4cd...864', 156, 45.2),
          _buildTopPlayerRow(2, '0x1234...abc', 134, 38.5),
          _buildTopPlayerRow(3, '0x5678...def', 98, 28.1),
          _buildTopPlayerRow(4, '0x9abc...123', 87, 24.6),
          _buildTopPlayerRow(5, '0xdef0...456', 76, 21.3),
        ],
      ),
    );
  }

  Widget _buildTopPlayerRow(int rank, String address, int markers, double distance) {
    final colors = [Colors.amber, Colors.grey[400]!, Colors.orange[700]!, Colors.grey, Colors.grey];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank <= 3 ? colors[rank - 1].withOpacity(0.2) : Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3 ? colors[rank - 1] : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
            ),
          ),
          Text(
            '$markers markers',
            style: const TextStyle(color: Colors.blueAccent),
          ),
          const SizedBox(width: 16),
          Text(
            '${distance.toStringAsFixed(1)} km',
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
