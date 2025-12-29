import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How to Play screen with game instructions for users
class HowToPlayScreen extends StatefulWidget {
  final bool isFirstTime;

  const HowToPlayScreen({super.key, this.isFirstTime = false});

  /// Check if this is user's first time opening the app
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_seen_tutorial') != true;
  }

  /// Mark tutorial as seen
  static Future<void> markTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_tutorial', true);
  }

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_TutorialPage> _pages = [
    _TutorialPage(
      icon: Icons.directions_run,
      iconColor: Colors.blue,
      title: 'Welcome to GPS Runner!',
      subtitle: 'A real-world crypto collection game',
      content:
          'Walk or run to real landmarks in Delhi and Hyderabad to collect markers and earn points!\n\n'
          'Your movements are verified on the Polygon blockchain, making your achievements permanent and tamper-proof.',
    ),
    _TutorialPage(
      icon: Icons.location_on,
      iconColor: Colors.green,
      title: 'How to Play',
      subtitle: 'Collect markers at landmarks',
      content: 'Follow these simple steps to start playing:',
      bulletPoints: [
        'Open the app and allow location permissions',
        'Walk or run to any landmark shown on the map',
        'When you reach a landmark, a marker is automatically placed',
        'Your marker is verified and stored on the blockchain',
        'Compete with others on the leaderboard!',
      ],
    ),
    _TutorialPage(
      icon: Icons.place,
      iconColor: Colors.amber,
      title: 'Landmarks',
      subtitle: 'Visit famous places',
      content: 'Earn points by visiting landmarks in two cities:',
      bulletPoints: [
        'Delhi: India Gate, Red Fort, Qutub Minar, Lotus Temple, and more',
        'Hyderabad: Charminar, Golconda Fort, HITEC City, Hussain Sagar, and more',
        'Major landmarks: 50 points',
        'Medium landmarks: 40 points',
        'Minor landmarks: 20-30 points',
      ],
    ),
    _TutorialPage(
      icon: Icons.catching_pokemon,
      iconColor: Colors.purple,
      title: 'Collect Crypto Coins',
      subtitle: 'Pokemon Go-style collection',
      content:
          'Tap "Collect Crypto" button to enter coin collection mode!\n\nWalk around to find spawned crypto coins on the map:',
      bulletPoints: [
        'BTC - Bitcoin (rare, high value)',
        'ETH - Ethereum',
        'MATIC - Polygon',
        'SOL - Solana',
        'DOGE - Dogecoin',
        'ADA, XRP, LTC and more!',
      ],
    ),
    _TutorialPage(
      icon: Icons.security,
      iconColor: Colors.red,
      title: 'Anti-Cheat System',
      subtitle: 'Fair play guaranteed',
      content: 'Our AI anti-cheat system (92% accuracy) ensures fair play:',
      bulletPoints: [
        'Speed Check: Maximum 28.8 km/h (no vehicles!)',
        'Step Counter: Must be actively walking/running',
        'Activity Detection: ML-powered movement verification',
        'GPS Accuracy: High precision location required',
        'Teleport Detection: No GPS spoofing allowed',
      ],
      warning: '3 violations = 15 minute suspension',
    ),
    _TutorialPage(
      icon: Icons.account_balance_wallet,
      iconColor: Colors.teal,
      title: 'Your Wallet',
      subtitle: 'Blockchain integration',
      content: 'A crypto wallet is automatically created for you:',
      bulletPoints: [
        'Google Sign-In: Deterministic wallet (same across devices)',
        'Guest Mode: Random wallet (make sure to backup!)',
        'Export your private key from Settings',
        'Never share your private key with anyone!',
        'Get free testnet MATIC from faucet.polygon.technology',
      ],
    ),
    _TutorialPage(
      icon: Icons.emoji_events,
      iconColor: Colors.orange,
      title: 'Tips for Success',
      subtitle: 'Maximize your score',
      content: 'Pro tips to dominate the leaderboard:',
      bulletPoints: [
        'Visit high-value landmarks (50 pts) first',
        'Keep your phone GPS on high accuracy mode',
        'Walk at a steady pace (not too fast!)',
        'Check the map for nearby landmarks',
        'Collect crypto coins while walking between landmarks',
        'Markers sync automatically when connected to internet',
        'Rate limit: 1 marker per 30 seconds',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with skip/close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.isFirstTime)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    )
                  else
                    const SizedBox(width: 48),
                  Text(
                    '${_currentPage + 1} / ${_pages.length}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  if (widget.isFirstTime)
                    TextButton(
                      onPressed: _skipTutorial,
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: _pages.length,
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),

            // Page indicator dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _pages[_currentPage].iconColor
                          : Colors.white30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back, size: 18),
                            SizedBox(width: 8),
                            Text('Previous'),
                          ],
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _currentPage < _pages.length - 1
                          ? () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                          : _completeTutorial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].iconColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage < _pages.length - 1
                                ? 'Next'
                                : widget.isFirstTime
                                    ? "Let's Go!"
                                    : 'Done',
                          ),
                          if (_currentPage < _pages.length - 1) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18),
                          ] else ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.play_arrow, size: 18),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_TutorialPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: page.iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: page.iconColor.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              page.icon,
              size: 50,
              color: page.iconColor,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Subtitle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: page.iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              page.subtitle,
              style: TextStyle(
                color: page.iconColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Content
          Text(
            page.content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),

          // Bullet points
          if (page.bulletPoints != null) ...[
            const SizedBox(height: 16),
            ...page.bulletPoints!.map(
              (point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle,
                        color: page.iconColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Warning box
          if (page.warning != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      page.warning!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _skipTutorial() {
    HowToPlayScreen.markTutorialSeen();
    Navigator.pop(context);
  }

  void _completeTutorial() {
    if (widget.isFirstTime) {
      HowToPlayScreen.markTutorialSeen();
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _TutorialPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String content;
  final List<String>? bulletPoints;
  final String? warning;

  const _TutorialPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.content,
    this.bulletPoints,
    this.warning,
  });
}

/// Quick reference card that can be shown as a dialog
class QuickReferenceCard extends StatelessWidget {
  const QuickReferenceCard({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const QuickReferenceCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: const Row(
        children: [
          Icon(Icons.help_outline, color: Colors.blue),
          SizedBox(width: 8),
          Text('Quick Reference', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Game Rules',
              [
                'Walk/run to landmarks to place markers',
                'Maximum speed: 28.8 km/h',
                'Minimum steps: 40/minute while moving',
                'Rate limit: 1 marker per 30 seconds',
              ],
              Colors.blue,
            ),
            const Divider(color: Colors.white24, height: 24),
            _buildSection(
              'Point Values',
              [
                'Major landmarks: 50 points',
                'Medium landmarks: 40 points',
                'Minor landmarks: 20-30 points',
              ],
              Colors.amber,
            ),
            const Divider(color: Colors.white24, height: 24),
            _buildSection(
              'Anti-Cheat Rules',
              [
                'No vehicles allowed',
                'No GPS spoofing',
                '3 violations = 15 min suspension',
              ],
              Colors.red,
            ),
            const Divider(color: Colors.white24, height: 24),
            _buildSection(
              'Supported Cities',
              [
                'Delhi (10 landmarks)',
                'Hyderabad (10 landmarks)',
              ],
              Colors.green,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it!'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HowToPlayScreen(),
              ),
            );
          },
          child: const Text('Full Guide'),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(color: color, fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
