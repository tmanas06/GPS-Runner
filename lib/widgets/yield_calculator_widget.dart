import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rwa_service.dart';

/// Interactive yield calculator widget
/// Shows estimated passive income based on staked markers
class YieldCalculatorWidget extends StatefulWidget {
  const YieldCalculatorWidget({super.key});

  @override
  State<YieldCalculatorWidget> createState() => _YieldCalculatorWidgetState();
}

class _YieldCalculatorWidgetState extends State<YieldCalculatorWidget> {
  int _markerCount = 10;
  String _selectedCity = 'Delhi';
  int _leaderboardRank = 0;

  final List<String> _cities = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
    'Ahmedabad',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<RWAService>(
      builder: (context, rwaService, _) {
        final estimate = rwaService.calculateYieldEstimate(
          markerCount: _markerCount,
          city: _selectedCity,
          leaderboardRank: _leaderboardRank,
        );

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.purple.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.calculate, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  const Text(
                    'Yield Calculator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showInfoDialog,
                    icon: const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Marker Count Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Staked Markers',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_markerCount',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _markerCount.toDouble(),
                min: 1,
                max: 100,
                divisions: 99,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey[800],
                onChanged: (value) {
                  setState(() => _markerCount = value.round());
                },
              ),

              // City Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'City',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      dropdownColor: Colors.grey[900],
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      items: _cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCity = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Leaderboard Rank
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leaderboard Rank',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      _buildRankChip('None', 0),
                      const SizedBox(width: 8),
                      _buildRankChip('Top 50', 25),
                      const SizedBox(width: 8),
                      _buildRankChip('Top 10', 5),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Results
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // APY Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Effective APY',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Text(
                              '${estimate.baseAPY.toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if (estimate.multiplier > 1) ...[
                              const Text(' x ', style: TextStyle(color: Colors.grey)),
                              Text(
                                '${estimate.multiplier}x',
                                style: const TextStyle(color: Colors.greenAccent),
                              ),
                              const Text(' = ', style: TextStyle(color: Colors.grey)),
                            ],
                            Text(
                              '${estimate.effectiveAPY.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),

                    // Monthly Estimate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Monthly Passive Income',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          estimate.formattedMonthly,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Annual Estimate
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Annual Estimate',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          estimate.formattedAnnual,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Disclaimer
              const Text(
                '* Estimates based on current pool sizes and sponsor rewards. Actual yield may vary.',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRankChip(String label, int rank) {
    final isSelected = _leaderboardRank == rank;

    return GestureDetector(
      onTap: () => setState(() => _leaderboardRank = rank),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent.withOpacity(0.2) : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.greenAccent : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.greenAccent : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'How Yield Works',
          style: TextStyle(color: Colors.white),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Staking Yield',
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Stake your landmark markers to earn passive income from:',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                '- 5% fee from new runners at your landmarks\n'
                '- Seasonal sponsor pool distributions\n'
                '- City-specific bonus pools',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Leaderboard Multipliers',
                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '- Top 10: 2x multiplier\n'
                '- Top 50: 1.5x multiplier\n'
                '- Others: 1x (base rate)',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Anti-Ponzi',
                style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Yield comes from real sponsor pools and game fees, not new deposits. '
                '80% of fees go to buyback/burn, ensuring sustainable tokenomics.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

/// Compact yield display widget for use in other screens
class YieldDisplayCompact extends StatelessWidget {
  final int stakedMarkers;
  final double pendingYield;
  final double apy;

  const YieldDisplayCompact({
    super.key,
    required this.stakedMarkers,
    required this.pendingYield,
    required this.apy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stakedMarkers staked',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                '${pendingYield.toStringAsFixed(4)} ETH',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${apy.toStringAsFixed(1)}% APY',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
