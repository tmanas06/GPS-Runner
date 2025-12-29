import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/anti_cheat.dart';
import '../services/gps_service.dart';

/// Anti-cheat status HUD widget with animated indicators
class AntiCheatHUD extends StatelessWidget {
  const AntiCheatHUD({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AntiCheatService, GPSService>(
      builder: (context, antiCheat, gps, child) {
        final gpsData = gps.currentData;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: antiCheat.allChecksPass ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    antiCheat.allChecksPass ? Icons.verified_user : Icons.shield,
                    color: antiCheat.allChecksPass ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    antiCheat.allChecksPass ? 'Anti-Cheat: OK' : 'Anti-Cheat: Warning',
                    style: TextStyle(
                      color: antiCheat.allChecksPass ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Status indicators
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusIndicator(
                    icon: Icons.speed,
                    label: 'Speed',
                    value: '${(gpsData?.speedKmh ?? 0).toStringAsFixed(1)}',
                    unit: 'km/h',
                    isOk: antiCheat.speedOk,
                  ),
                  const SizedBox(width: 12),
                  _StatusIndicator(
                    icon: Icons.directions_walk,
                    label: 'Steps',
                    value: '${gpsData?.stepsPerMin ?? 0}',
                    unit: '/min',
                    isOk: antiCheat.stepsOk,
                  ),
                  const SizedBox(width: 12),
                  _StatusIndicator(
                    icon: Icons.fitness_center,
                    label: 'Activity',
                    value: _shortenActivity(gpsData?.activityType.label ?? '?'),
                    unit: '',
                    isOk: antiCheat.activityOk,
                  ),
                  const SizedBox(width: 12),
                  _StatusIndicator(
                    icon: Icons.gps_fixed,
                    label: 'GPS',
                    value: '${(gpsData?.position.accuracy ?? 0).toStringAsFixed(0)}',
                    unit: 'm',
                    isOk: antiCheat.gpsOk,
                  ),
                ],
              ),

              // Warning message
              if (!antiCheat.allChecksPass && antiCheat.lastResult != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    antiCheat.lastResult!.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                  ),
                ),

              // Suspension warning
              if (antiCheat.isSuspended)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'ACCOUNT SUSPENDED',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _shortenActivity(String activity) {
    if (activity.length <= 6) return activity;
    return activity.substring(0, 6);
  }
}

class _StatusIndicator extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final bool isOk;

  const _StatusIndicator({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.isOk,
  });

  @override
  State<_StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<_StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_StatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isOk && oldWidget.isOk) {
      _controller.repeat(reverse: true);
    } else if (widget.isOk && !oldWidget.isOk) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isOk ? Colors.green : Colors.red;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon with pulse animation for warnings
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isOk ? 1.0 : _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: color,
                  size: 14,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 2),

        // Value
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            if (widget.unit.isNotEmpty)
              Text(
                widget.unit,
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 9,
                ),
              ),
          ],
        ),

        // Status checkmark/x
        Icon(
          widget.isOk ? Icons.check : Icons.close,
          color: color,
          size: 10,
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

/// Compact inline anti-cheat indicator
class AntiCheatIndicator extends StatelessWidget {
  const AntiCheatIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AntiCheatService>(
      builder: (context, antiCheat, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (antiCheat.allChecksPass ? Colors.green : Colors.red)
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: antiCheat.allChecksPass ? Colors.green : Colors.red,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                antiCheat.allChecksPass
                    ? Icons.verified_user
                    : Icons.warning,
                color: antiCheat.allChecksPass ? Colors.green : Colors.red,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                antiCheat.allChecksPass ? 'VALID' : 'ALERT',
                style: TextStyle(
                  color: antiCheat.allChecksPass ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Full-screen cheat detection overlay
class CheatDetectionOverlay extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const CheatDetectionOverlay({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning icon with animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 3),
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: 64,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'CHEAT DETECTED',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 32),

              if (onDismiss != null)
                ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'I UNDERSTAND',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
