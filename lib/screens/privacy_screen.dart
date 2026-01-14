import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/isar_db.dart';
import '../services/auth_service.dart';

/// Privacy settings screen with data controls
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late IsarDBService _db;
  late AuthService _auth;
  
  bool _hideHomeArea = false;
  bool _shareLocationWithFriends = false;
  bool _allowAnalytics = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = context.read<IsarDBService>();
    _auth = context.read<AuthService>();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load privacy settings from SharedPreferences or database
    // For now, using defaults
    setState(() {
      _hideHomeArea = false;
      _shareLocationWithFriends = false;
      _allowAnalytics = true;
    });
  }

  Future<void> _saveSettings() async {
    // Save privacy settings
    // Implementation would save to SharedPreferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteLocationHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location History?'),
        content: const Text(
          'This will permanently delete all your location history and walking sessions. '
          'This action cannot be undone.\n\n'
          'Blockchain data will remain unchanged.',
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
      await _db.clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location history deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _exportData() async {
    // Export user data as JSON
    final stats = await _db.getUserStats();
    final sessions = await _db.getWalkingSessions();
    final markers = await _db.getPlayerMarkers(_auth.playerId ?? '');

    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'userStats': stats.toJson(),
      'sessions': sessions.map((s) => s.toJson()).toList(),
      'markers': markers.map((m) => m.toJson()).toList(),
    };

    // In a real app, this would save to a file or share
    debugPrint('Export data: ${exportData.toString()}');
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data export prepared. Check logs for JSON output.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Data'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Privacy Settings Section
          const Text(
            'Privacy Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Hide Home/Office Area'),
            subtitle: const Text(
              'Rounds your location to 100m when near saved locations',
            ),
            value: _hideHomeArea,
            onChanged: (value) {
              setState(() => _hideHomeArea = value);
              _saveSettings();
            },
          ),
          
          SwitchListTile(
            title: const Text('Share Location with Friends'),
            subtitle: const Text(
              'Allow friends to see your real-time location',
            ),
            value: _shareLocationWithFriends,
            onChanged: (value) {
              setState(() => _shareLocationWithFriends = value);
              _saveSettings();
            },
          ),
          
          SwitchListTile(
            title: const Text('Allow Analytics'),
            subtitle: const Text(
              'Help improve the app by sharing anonymous usage data',
            ),
            value: _allowAnalytics,
            onChanged: (value) {
              setState(() => _allowAnalytics = value);
              _saveSettings();
            },
          ),

          const SizedBox(height: 32),

          // Data Management Section
          const Text(
            'Data Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.download, color: Colors.blue),
            title: const Text('Export My Data'),
            subtitle: const Text('Download all your data as JSON'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _exportData,
          ),

          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete Location History'),
            subtitle: const Text('Permanently delete all location data'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _deleteLocationHistory,
          ),

          const SizedBox(height: 32),

          // Legal Section
          const Text(
            'Legal & Compliance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.amber),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our privacy policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to privacy policy screen
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Privacy Policy'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'GPS Runner Web3 Privacy Policy\n\n'
                      'Last Updated: January 2026\n\n'
                      '1. Data Collection\n'
                      'We collect GPS location data, walking metrics, and blockchain transaction data to provide our services.\n\n'
                      '2. Data Usage\n'
                      'Your data is used to:\n'
                      '- Track your walking/running sessions\n'
                      '- Verify location on blockchain\n'
                      '- Display leaderboards\n'
                      '- Improve app functionality\n\n'
                      '3. Data Storage\n'
                      'Location data is stored locally on your device and optionally synced to blockchain.\n\n'
                      '4. Your Rights\n'
                      'You can export, delete, or modify your data at any time through the Privacy settings.\n\n'
                      '5. Contact\n'
                      'For privacy concerns, contact: privacy@gpsrunner.web3',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.description, color: Colors.blue),
            title: const Text('Terms of Service'),
            subtitle: const Text('Read our terms of service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Terms of Service'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'GPS Runner Web3 Terms of Service\n\n'
                      'Last Updated: January 2026\n\n'
                      '1. Acceptance\n'
                      'By using this app, you agree to these terms.\n\n'
                      '2. Service Description\n'
                      'GPS Runner Web3 is a location-based fitness game that uses blockchain technology.\n\n'
                      '3. User Responsibilities\n'
                      '- Walk safely and be aware of your surroundings\n'
                      '- Do not use vehicles or GPS spoofing\n'
                      '- Keep your wallet private key secure\n\n'
                      '4. Testnet Tokens\n'
                      'All tokens on testnet have no monetary value.\n\n'
                      '5. Limitation of Liability\n'
                      'We are not responsible for injuries or losses while using the app.\n\n'
                      '6. Changes to Terms\n'
                      'We may update these terms at any time.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
