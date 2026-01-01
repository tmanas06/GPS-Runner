import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/city_bounds.dart';

/// City selection screen with auto-detection
class CitySelectorScreen extends StatefulWidget {
  final Function(CityConfig) onCitySelected;

  const CitySelectorScreen({
    super.key,
    required this.onCitySelected,
  });

  @override
  State<CitySelectorScreen> createState() => _CitySelectorScreenState();
}

class _CitySelectorScreenState extends State<CitySelectorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  CityConfig? _detectedCity;
  bool _isDetecting = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _detectCity();
  }

  Future<void> _detectCity() async {
    setState(() {
      _isDetecting = true;
      _error = null;
    });

    try {
      // Check location permission
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Location timeout'),
      );

      // Detect city
      final city = CityBounds.detect(position.latitude, position.longitude);

      setState(() {
        _detectedCity = city;
        _isDetecting = false;
      });

      // Auto-select if city detected
      if (city != null) {
        await Future.delayed(const Duration(seconds: 1));
        widget.onCitySelected(city);
      }
    } catch (e) {
      setState(() {
        _isDetecting = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Title
              const Text(
                'GPS RUNNER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const Text(
                'Web3 Edition',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 48),

              // Detection status
              if (_isDetecting) _buildDetecting(),
              if (!_isDetecting && _detectedCity != null) _buildDetected(),
              if (!_isDetecting && _detectedCity == null) _buildNotDetected(),

              const Spacer(),

              // Manual selection
              const Text(
                'Or select manually:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // City cards - show major cities from different states
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _CityCard(
                        city: CityBounds.delhi.cities.first, // New Delhi
                        isSelected: _detectedCity?.stateId == 'delhi',
                        onTap: () => widget.onCitySelected(CityBounds.delhi.cities.first),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _CityCard(
                        city: CityBounds.telangana.cities.first, // Hyderabad
                        isSelected: _detectedCity?.stateId == 'telangana',
                        onTap: () => widget.onCitySelected(CityBounds.telangana.cities.first),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Error retry
              if (_error != null)
                TextButton.icon(
                  onPressed: _detectCity,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Retry Detection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetecting() {
    return Column(
      children: [
        RotationTransition(
          turns: _controller,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              gradient: RadialGradient(
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Icon(
              Icons.location_searching,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Detecting your city...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDetected() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.2),
            border: Border.all(color: Colors.green, width: 3),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.green,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '${_detectedCity!.emoji} ${_detectedCity!.name}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'City detected! Starting game...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildNotDetected() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange.withOpacity(0.2),
            border: Border.all(color: Colors.orange, width: 3),
          ),
          child: const Icon(
            Icons.location_off,
            color: Colors.orange,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'City Not Detected',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            _error ?? 'You appear to be outside supported cities in India.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => widget.onCitySelected(CityBounds.delhi.cities.first),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          icon: const Icon(Icons.arrow_forward),
          label: const Text(
            'Continue with New Delhi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CityCard extends StatelessWidget {
  final CityConfig city;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityCard({
    required this.city,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(int.parse(city.defaultColor.replaceFirst('#', '0xFF')))
                  .withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Color(int.parse(city.defaultColor.replaceFirst('#', '0xFF')))
                : Colors.white24,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              city.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              city.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${city.landmarks.length} Landmarks',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
