import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rwa_service.dart';

/// Governance screen for voting on new landmarks and cities
class GovernanceScreen extends StatefulWidget {
  const GovernanceScreen({super.key});

  @override
  State<GovernanceScreen> createState() => _GovernanceScreenState();
}

class _GovernanceScreenState extends State<GovernanceScreen> {
  bool _isLoading = true;
  bool _canPropose = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final rwaService = context.read<RWAService>();
    await rwaService.getActiveProposals();
    _canPropose = await rwaService.canPropose();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Governance',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (_canPropose)
            IconButton(
              onPressed: _showCreateProposalDialog,
              icon: const Icon(Icons.add, color: Colors.greenAccent),
              tooltip: 'Create Proposal',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Colors.greenAccent,
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    return Consumer<RWAService>(
      builder: (context, rwaService, _) {
        final proposals = rwaService.proposals;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            _buildHeader(rwaService),
            const SizedBox(height: 24),

            // Voting Power Card
            _buildVotingPowerCard(rwaService),
            const SizedBox(height: 24),

            // Active Proposals
            const Text(
              'Active Proposals',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (proposals.isEmpty)
              _buildEmptyState()
            else
              ...proposals.map((p) => _buildProposalCard(p, rwaService)),
          ],
        );
      },
    );
  }

  Widget _buildHeader(RWAService rwaService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.indigo.withOpacity(0.3),
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
          Row(
            children: [
              const Icon(Icons.how_to_vote, color: Colors.purpleAccent, size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Governance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Vote on new landmarks and cities',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVotingPowerCard(RWAService rwaService) {
    return FutureBuilder<BigInt>(
      future: rwaService.getRUNBalance(),
      builder: (context, snapshot) {
        final balance = snapshot.data ?? BigInt.zero;
        final balanceFormatted = (balance / BigInt.from(10).pow(18)).toStringAsFixed(0);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Voting Power',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$balanceFormatted RUN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _canPropose
                      ? Colors.greenAccent.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _canPropose ? 'Can Propose' : 'Need 100k RUN',
                  style: TextStyle(
                    color: _canPropose ? Colors.greenAccent : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.ballot_outlined, color: Colors.grey, size: 64),
          SizedBox(height: 16),
          Text(
            'No Active Proposals',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to propose a new landmark or city!',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProposalCard(GovernanceProposal proposal, RWAService rwaService) {
    final forPercent = proposal.forPercentage;
    final againstPercent = 100 - forPercent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: proposal.isActive ? Colors.purpleAccent.withOpacity(0.5) : Colors.grey[800]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getProposalTypeColor(proposal.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getProposalTypeName(proposal.type),
                  style: TextStyle(
                    color: _getProposalTypeColor(proposal.type),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(proposal.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusName(proposal.status),
                  style: TextStyle(
                    color: _getStatusColor(proposal.status),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            proposal.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Vote Progress
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'For: ${forPercent.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                        ),
                        Text(
                          'Against: ${againstPercent.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: forPercent / 100,
                        backgroundColor: Colors.redAccent.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time remaining
          if (proposal.isActive) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ends in: ${_formatDuration(proposal.timeRemaining)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Vote Buttons
          if (proposal.isActive)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _vote(proposal.id, true, rwaService),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Vote For'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _vote(proposal.id, false, rwaService),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                    child: const Text('Vote Against'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _vote(int proposalId, bool support, RWAService rwaService) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          support ? 'Vote For' : 'Vote Against',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to vote ${support ? "for" : "against"} this proposal?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Vote',
              style: TextStyle(color: support ? Colors.greenAccent : Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final txHash = await rwaService.vote(proposalId, support);
      if (txHash != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vote submitted! Tx: ${txHash.substring(0, 10)}...'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    }
  }

  void _showCreateProposalDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create Proposal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.greenAccent),
              title: const Text(
                'Propose Landmark',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text(
                'Add a new landmark to the game',
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show landmark proposal form
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city, color: Colors.blueAccent),
              title: const Text(
                'Propose City',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text(
                'Add a new city to expand the game',
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show city proposal form
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getProposalTypeColor(ProposalType type) {
    switch (type) {
      case ProposalType.newLandmark:
        return Colors.greenAccent;
      case ProposalType.newCity:
        return Colors.blueAccent;
      case ProposalType.parameterChange:
        return Colors.orangeAccent;
      case ProposalType.custom:
        return Colors.purpleAccent;
    }
  }

  String _getProposalTypeName(ProposalType type) {
    switch (type) {
      case ProposalType.newLandmark:
        return 'LANDMARK';
      case ProposalType.newCity:
        return 'CITY';
      case ProposalType.parameterChange:
        return 'PARAMETER';
      case ProposalType.custom:
        return 'CUSTOM';
    }
  }

  Color _getStatusColor(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.active:
        return Colors.purpleAccent;
      case ProposalStatus.passed:
        return Colors.greenAccent;
      case ProposalStatus.failed:
        return Colors.redAccent;
      case ProposalStatus.executed:
        return Colors.blueAccent;
      case ProposalStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusName(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.active:
        return 'ACTIVE';
      case ProposalStatus.passed:
        return 'PASSED';
      case ProposalStatus.failed:
        return 'FAILED';
      case ProposalStatus.executed:
        return 'EXECUTED';
      case ProposalStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }
}
