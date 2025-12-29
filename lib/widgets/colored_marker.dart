import 'dart:math';
import 'package:flutter/material.dart';

/// Colored pulsing flag marker for map display
class ColoredMarkerWidget extends StatefulWidget {
  final String playerName;
  final String color;
  final bool isCurrentUser;
  final String? landmarkName;
  final bool showPulse;

  const ColoredMarkerWidget({
    super.key,
    required this.playerName,
    required this.color,
    this.isCurrentUser = false,
    this.landmarkName,
    this.showPulse = true,
  });

  @override
  State<ColoredMarkerWidget> createState() => _ColoredMarkerWidgetState();
}

class _ColoredMarkerWidgetState extends State<ColoredMarkerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.showPulse && widget.isCurrentUser) {
      _controller.repeat(reverse: true);
    }
  }

  Color get markerColor {
    try {
      return Color(int.parse(widget.color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isCurrentUser ? _pulseAnimation.value : 1.0,
          child: Transform.rotate(
            angle: widget.isCurrentUser ? _rotationAnimation.value : 0,
            child: _buildMarker(),
          ),
        );
      },
    );
  }

  Widget _buildMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Flag pole
        Container(
          width: widget.isCurrentUser ? 4 : 2,
          height: widget.isCurrentUser ? 30 : 20,
          decoration: BoxDecoration(
            color: Colors.brown.shade700,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),

        // Flag
        Transform.translate(
          offset: Offset(widget.isCurrentUser ? 15 : 10, -25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: markerColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: markerColor.withOpacity(0.5),
                  blurRadius: widget.isCurrentUser ? 8 : 4,
                  spreadRadius: widget.isCurrentUser ? 2 : 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player name
                Text(
                  _shortenName(widget.playerName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isCurrentUser ? 10 : 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Landmark name (if provided)
                if (widget.landmarkName != null)
                  Text(
                    '@${_shortenName(widget.landmarkName!, maxLen: 8)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: widget.isCurrentUser ? 8 : 6,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Pulse ring (for current user)
        if (widget.isCurrentUser && widget.showPulse)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 20 * _pulseAnimation.value,
                height: 10 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  color: markerColor.withOpacity(0.3 / _pulseAnimation.value),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
      ],
    );
  }

  String _shortenName(String name, {int maxLen = 6}) {
    if (name.length <= maxLen) return name;
    return '${name.substring(0, maxLen)}...';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Simple marker for quick rendering (no animation)
class SimpleMarkerWidget extends StatelessWidget {
  final String color;
  final bool isLive;

  const SimpleMarkerWidget({
    super.key,
    required this.color,
    this.isLive = false,
  });

  Color get markerColor {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow for live markers
        if (isLive)
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: markerColor.withOpacity(0.3),
            ),
          ),

        // Main marker
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        // Live indicator dot
        if (isLive)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }
}

/// Animated celebration marker when placing new marker
class CelebrationMarkerWidget extends StatefulWidget {
  final String color;
  final String landmarkName;
  final VoidCallback? onComplete;

  const CelebrationMarkerWidget({
    super.key,
    required this.color,
    required this.landmarkName,
    this.onComplete,
  });

  @override
  State<CelebrationMarkerWidget> createState() => _CelebrationMarkerWidgetState();
}

class _CelebrationMarkerWidgetState extends State<CelebrationMarkerWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Generate particles
    final random = Random();
    for (int i = 0; i < 12; i++) {
      _particles.add(_Particle(
        angle: (i / 12) * 2 * pi,
        speed: 50 + random.nextDouble() * 50,
        color: HSLColor.fromAHSL(
          1,
          random.nextDouble() * 360,
          0.8,
          0.6,
        ).toColor(),
      ));
    }

    // Start animations
    _scaleController.forward();
    _particleController.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  Color get markerColor {
    try {
      return Color(int.parse(widget.color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Particles
          ..._particles.map((p) => AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  final progress = _particleController.value;
                  final x = cos(p.angle) * p.speed * progress;
                  final y = sin(p.angle) * p.speed * progress;
                  final opacity = 1.0 - progress;

                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: p.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              )),

          // Main marker
          ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: markerColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: markerColor.withOpacity(0.5),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.landmarkName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

class _Particle {
  final double angle;
  final double speed;
  final Color color;

  _Particle({
    required this.angle,
    required this.speed,
    required this.color,
  });
}
