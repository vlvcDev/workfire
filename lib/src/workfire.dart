import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A customizable firework widget that creates beautiful firework animations.
///
/// The widget is completely click-through and designed for performance.
/// It consists of two phases: a rocket phase and an explosion phase.
///
/// ## Example Usage
/// ```dart
/// // Basic firework
/// Firework(
///   startingPosition: Offset(100, 500),
///   endingPosition: Offset(200, 200),
///   particleColors: [Colors.red, Colors.orange, Colors.yellow],
///   onComplete: () => print('Firework completed!'),
/// )
///
/// // Spiral firework
/// Firework(
///   startingPosition: Offset(100, 500),
///   endingPosition: Offset(200, 200),
///   rocketSpiral: true,
///   rocketSpiralIntensity: 2.0,
///   rocketSpiralFrequency: 3.0,
///   particleColors: [Colors.cyan, Colors.blue, Colors.purple],
/// )
/// ```
class Firework extends StatefulWidget {
  /// The starting position of the rocket. If null, defaults to bottom center of screen.
  final Offset? startingPosition;

  /// The ending position where the rocket explodes. If null, defaults to center of screen.
  final Offset? endingPosition;

  /// Whether the rocket trail is visible during the rocket phase.
  final bool rocketIsVisible;

  /// The animation curve for the rocket's movement.
  final Curve curve;

  /// The color of the rocket trail.
  final Color rocketColor;

  /// Whether the rocket follows a spiral path during its flight.
  final bool rocketSpiral;

  /// The intensity of the spiral effect (higher values = wider spiral).
  final double rocketSpiralIntensity;

  /// The frequency of the spiral effect (higher values = more spirals).
  final double rocketSpiralFrequency;

  /// The duration of the rocket phase animation.
  final Duration rocketDuration;

  /// The speed at which the explosion ring expands (pixels per second).
  final double ringSpeed;

  /// The thickness of the explosion ring border.
  final double ringThickness;

  /// The speed at which the explosion ring fades out.
  final double ringFadeSpeed;

  /// The number of particles in the explosion.
  final int particleCount;

  /// The speed at which particles fade out.
  final double particleFadeSpeed;

  /// The variance in particle fade speed (0.0 to 1.0).
  final double particleFadeVariance;

  /// The length of each particle in pixels.
  final double particleLength;

  /// The width of each particle in pixels.
  final double particleWidth;

  /// Whether particles have a glowing effect.
  final bool particleRingGlow;

  /// The speed at which particles move away from the explosion center.
  final double particleSpeed;

  /// The variance in particle speed (0.0 to 1.0).
  final double particleSpeedVariance;

  /// The colors that particles can have. Colors are randomly assigned to particles.
  final List<Color> particleColors;

  /// The color of the explosion ring.
  final Color ringColor;

  /// The gravity force applied to particles (pixels per second squared).
  /// Higher values make particles fall faster.
  final double gravity;

  /// Called when the entire firework animation completes.
  final VoidCallback? onComplete;

  /// Whether to automatically start the animation when the widget is built.
  final bool autoStart;

  /// Creates a firework widget with customizable properties.
  ///
  /// All parameters are optional and have sensible defaults.
  /// The firework will automatically start animating unless [autoStart] is false.
  const Firework({
    super.key,
    this.startingPosition,
    this.endingPosition,
    this.rocketIsVisible = true,
    this.curve = Curves.easeInOut,
    this.rocketColor = Colors.white,
    this.rocketSpiral = false,
    this.rocketSpiralIntensity = 2.0,
    this.rocketSpiralFrequency = 2.0,
    this.rocketDuration = const Duration(milliseconds: 600),
    this.ringSpeed = 120.0,
    this.ringThickness = 3.0,
    this.ringFadeSpeed = 4.0,
    this.particleCount = 24,
    this.particleFadeSpeed = 2.0,
    this.particleFadeVariance = 0.1,
    this.particleLength = 6.0,
    this.particleWidth = 4.0,
    this.particleRingGlow = true,
    this.particleSpeed = 90.0,
    this.particleSpeedVariance = 0.06,
    this.particleColors = const [Colors.red, Colors.blue, Colors.green],
    this.ringColor = Colors.blue,
    this.gravity = 80.0,
    this.onComplete,
    this.autoStart = true,
  });

  @override
  State<Firework> createState() => _FireworkState();
}

class _FireworkState extends State<Firework> with TickerProviderStateMixin {
  late AnimationController _rocketController;
  late AnimationController _explosionController;
  late Animation<double> _rocketProgress;
  late Animation<Offset> _rocketPosition;
  late Animation<double> _rocketSize;

  bool _isExploding = false;
  bool _isComplete = false;

  late Offset _startPos;
  late Offset _endPos;
  late List<_Particle> _particles;
  late List<Color> _particleColorsList;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startFirework());
    }
  }

  void _initializeControllers() {
    _rocketController = AnimationController(
      duration: widget.rocketDuration,
      vsync: this,
    );

    // Calculate the maximum duration needed for particles to fully fade out
    // We need to ensure even the slowest particle has time to fade completely
    final slowestFadeSpeed = math.max(
      0.1,
      widget.particleFadeSpeed * (1 - widget.particleFadeVariance / 2),
    );
    final baseDuration = 3000; // Base duration in milliseconds
    final calculatedDuration = (baseDuration / slowestFadeSpeed).round();
    final explosionDuration = Duration(
      milliseconds: math.max(1000, calculatedDuration),
    );

    _explosionController = AnimationController(
      duration: explosionDuration,
      vsync: this,
    );

    _rocketProgress = CurvedAnimation(
      parent: _rocketController,
      curve: widget.curve,
    );

    _rocketController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startExplosion();
      }
    });

    _explosionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _complete();
      }
    });
  }

  void _startFirework() {
    if (mounted) {
      _rocketController.forward();
    }
  }

  /// Manually restart the firework animation
  void restart() {
    if (mounted) {
      _resetAnimation();
    }
  }

  void _startExplosion() {
    if (!mounted) return;

    setState(() {
      _isExploding = true;
    });

    _generateParticles();
    _explosionController.forward();
  }

  void _generateParticles() {
    _particles = [];
    _particleColorsList = [];
    final random = math.Random();

    for (int i = 0; i < widget.particleCount; i++) {
      final angle = (2 * math.pi * i) / widget.particleCount;

      // Add variance to speed and fade speed
      final speedVariance = widget.particleSpeedVariance;
      final fadeVariance = widget.particleFadeVariance;

      final speed =
          widget.particleSpeed *
          (1 + (random.nextDouble() - 0.5) * speedVariance);
      final fadeSpeed =
          widget.particleFadeSpeed *
          (1 + (random.nextDouble() - 0.5) * fadeVariance);

      _particles.add(
        _Particle(angle: angle, speed: speed, fadeSpeed: fadeSpeed),
      );

      // Distribute colors evenly
      final colorIndex = i % widget.particleColors.length;
      _particleColorsList.add(widget.particleColors[colorIndex]);
    }
  }

  void _complete() {
    if (!mounted || _isComplete) return;

    setState(() {
      _isComplete = true;
    });

    widget.onComplete?.call();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePositions();
  }

  @override
  void didUpdateWidget(Firework oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if any parameters that affect the animation have changed
    if (widget.rocketDuration != oldWidget.rocketDuration ||
        widget.particleFadeSpeed != oldWidget.particleFadeSpeed ||
        widget.particleFadeVariance != oldWidget.particleFadeVariance ||
        widget.rocketSpiral != oldWidget.rocketSpiral ||
        widget.rocketSpiralIntensity != oldWidget.rocketSpiralIntensity ||
        widget.rocketSpiralFrequency != oldWidget.rocketSpiralFrequency ||
        widget.curve != oldWidget.curve) {
      // Reinitialize controllers with new parameters
      _rocketController.dispose();
      _explosionController.dispose();
      _initializeControllers();
    }

    // Update positions if position-related parameters changed
    if (widget.startingPosition != oldWidget.startingPosition ||
        widget.endingPosition != oldWidget.endingPosition ||
        widget.rocketSpiral != oldWidget.rocketSpiral ||
        widget.rocketSpiralIntensity != oldWidget.rocketSpiralIntensity ||
        widget.rocketSpiralFrequency != oldWidget.rocketSpiralFrequency) {
      _updatePositions();
    }

    // Reset the animation state if not auto-started or if parameters changed significantly
    if (!widget.autoStart || _needsReset(oldWidget)) {
      _resetAnimation();
    }
  }

  bool _needsReset(Firework oldWidget) {
    return widget.rocketSpiral != oldWidget.rocketSpiral ||
        widget.rocketSpiralIntensity != oldWidget.rocketSpiralIntensity ||
        widget.rocketSpiralFrequency != oldWidget.rocketSpiralFrequency ||
        widget.startingPosition != oldWidget.startingPosition ||
        widget.endingPosition != oldWidget.endingPosition;
  }

  void _resetAnimation() {
    if (!mounted) return;

    _rocketController.reset();
    _explosionController.reset();

    setState(() {
      _isExploding = false;
      _isComplete = false;
    });

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startFirework());
    }
  }

  void _updatePositions() {
    final size = MediaQuery.of(context).size;

    _startPos = widget.startingPosition ?? Offset(size.width / 2, size.height);
    _endPos = widget.endingPosition ?? Offset(size.width / 2, size.height / 2);

    if (widget.rocketSpiral) {
      // Create a spiral path animation
      _rocketPosition = _SpiralAnimation(
        begin: _startPos,
        end: _endPos,
        intensity: widget.rocketSpiralIntensity,
        frequency: widget.rocketSpiralFrequency,
      ).animate(_rocketProgress);
    } else {
      _rocketPosition = Tween<Offset>(
        begin: _startPos,
        end: _endPos,
      ).animate(_rocketProgress);
    }

    _rocketSize = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _rocketController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Stack(
        children: [
          // Rocket
          if (widget.rocketIsVisible && !_isExploding)
            AnimatedBuilder(
              animation: _rocketController,
              builder: (context, child) {
                final currentPosition = _rocketPosition.value;
                double angle;

                if (widget.rocketSpiral &&
                    _rocketPosition is _SpiralAnimationWrapper) {
                  // Use the spiral animation's direction calculation
                  final spiralAnimation =
                      _rocketPosition as _SpiralAnimationWrapper;
                  final direction = spiralAnimation.getDirection();
                  angle = math.atan2(direction.dy, direction.dx) + math.pi / 2;
                } else {
                  // Original calculation for non-spiral rockets
                  final direction = _endPos - _startPos;
                  angle = math.atan2(direction.dy, direction.dx) + math.pi / 2;
                }

                return Positioned(
                  left: currentPosition.dx - 2,
                  top: currentPosition.dy - 10,
                  child: Transform.scale(
                    scale: _rocketSize.value,
                    child: Transform.rotate(
                      angle: angle,
                      child: Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: widget.rocketColor,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: widget.particleRingGlow
                              ? [
                                  BoxShadow(
                                    color: widget.rocketColor.withValues(
                                      alpha: 0.6,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Explosion
          if (_isExploding)
            AnimatedBuilder(
              animation: _explosionController,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Ring
                    if (widget.ringThickness > 0) _buildRing(),

                    // Particles
                    ..._buildParticles(),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRing() {
    final progress = _explosionController.value;
    final radius = widget.ringSpeed * progress;
    final fadeProgress = progress * widget.ringFadeSpeed;
    final opacity = (1.0 - fadeProgress).clamp(0.0, 1.0);

    return Positioned(
      left: _endPos.dx - radius,
      top: _endPos.dy - radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.ringColor.withValues(alpha: opacity),
            width: widget.ringThickness,
          ),
          boxShadow: widget.particleRingGlow
              ? [
                  BoxShadow(
                    color: widget.ringColor.withValues(alpha: opacity * 0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    final List<Widget> particleWidgets = [];

    for (int i = 0; i < _particles.length; i++) {
      final particle = _particles[i];
      final color = _particleColorsList[i];
      final progress = _explosionController.value;

      // Calculate fade progress first
      final fadeProgress = progress * particle.fadeSpeed;
      final opacity = (1.0 - fadeProgress).clamp(0.0, 1.0);

      // Only render particles that are still visible
      if (opacity > 0) {
        // Calculate distance based on progress - particles travel continuously until they fade out
        final distance = particle.speed * progress;
        final x = _endPos.dx + math.cos(particle.angle) * distance;

        // Apply gravity effect to y position
        // Gravity affects particles over time, making them fall downward
        final gravityEffect = 0.5 * widget.gravity * progress * progress;
        final y =
            _endPos.dy + math.sin(particle.angle) * distance + gravityEffect;

        particleWidgets.add(
          Positioned(
            left: x - widget.particleWidth / 2,
            top: y - widget.particleLength / 2,
            child: Transform.rotate(
              angle: particle.angle + math.pi / 2,
              child: Container(
                width: widget.particleWidth,
                height: widget.particleLength,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: opacity),
                  borderRadius: BorderRadius.circular(widget.particleWidth / 2),
                  boxShadow: widget.particleRingGlow
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: opacity * 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        );
      }
    }

    return particleWidgets;
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _explosionController.dispose();
    super.dispose();
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double fadeSpeed;

  _Particle({
    required this.angle,
    required this.speed,
    required this.fadeSpeed,
  });
}

/// A custom animation that creates a spiral path between two points.
class _SpiralAnimation extends Animation<Offset> {
  final Offset begin;
  final Offset end;
  final double intensity;
  final double frequency;
  final Animation<double> parent;

  _SpiralAnimation({
    required this.begin,
    required this.end,
    required this.intensity,
    required this.frequency,
  }) : parent = const AlwaysStoppedAnimation(0.0);

  Animation<Offset> animate(Animation<double> parent) {
    return _SpiralAnimationWrapper(
      begin: begin,
      end: end,
      intensity: intensity,
      frequency: frequency,
      parent: parent,
    );
  }

  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      parent.addStatusListener(listener);

  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      parent.removeStatusListener(listener);

  @override
  AnimationStatus get status => parent.status;

  @override
  Offset get value => begin;
}

/// Wrapper class that actually implements the spiral animation logic.
class _SpiralAnimationWrapper extends Animation<Offset> {
  final Offset begin;
  final Offset end;
  final double intensity;
  final double frequency;
  final Animation<double> parent;

  _SpiralAnimationWrapper({
    required this.begin,
    required this.end,
    required this.intensity,
    required this.frequency,
    required this.parent,
  });

  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      parent.addStatusListener(listener);

  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      parent.removeStatusListener(listener);

  @override
  AnimationStatus get status => parent.status;

  @override
  Offset get value {
    final progress = parent.value;

    // Calculate the base linear interpolation
    final baseOffset = Offset.lerp(begin, end, progress)!;

    // Calculate the perpendicular direction for the spiral
    final direction = end - begin;
    final perpendicular = Offset(-direction.dy, direction.dx).normalize();

    // Calculate the spiral offset using sine wave
    final spiralOffset =
        math.sin(progress * 2 * math.pi * frequency) *
        intensity *
        10.0 * // Base scaling factor
        (1.0 - progress); // Fade out spiral effect as rocket approaches target

    // Apply the spiral offset perpendicular to the flight path
    return baseOffset + perpendicular * spiralOffset;
  }

  /// Gets the current direction vector for the spiral animation
  Offset getDirection() {
    final progress = parent.value;
    final deltaTime = 0.01; // Small time step for derivative calculation

    // Calculate current and next positions to determine movement direction
    final nextProgress = math.min(1.0, progress + deltaTime);
    final nextPosition = _getPositionAtProgress(nextProgress);
    final currentPosition = _getPositionAtProgress(progress);

    final movementDirection = nextPosition - currentPosition;
    return movementDirection.normalize();
  }

  /// Helper method to get position at a specific progress
  Offset _getPositionAtProgress(double progress) {
    final baseOffset = Offset.lerp(begin, end, progress)!;
    final direction = end - begin;
    final perpendicular = Offset(-direction.dy, direction.dx).normalize();
    final spiralOffset =
        math.sin(progress * 2 * math.pi * frequency) *
        intensity *
        10.0 *
        (1.0 - progress);
    return baseOffset + perpendicular * spiralOffset;
  }
}

/// Extension to normalize an Offset vector.
extension OffsetExtension on Offset {
  Offset normalize() {
    final length = distance;
    if (length == 0) return this;
    return this / length;
  }
}

/// A widget that manages multiple fireworks and makes them easy to sequence.
///
/// This widget allows you to create complex firework displays by specifying
/// multiple fireworks with different timings and configurations.
///
/// ## Example Usage
/// ```dart
/// FireworkShow(
///   fireworks: [
///     FireworkConfig(
///       delay: Duration.zero,
///       startingPosition: Offset(100, 500),
///       endingPosition: Offset(200, 200),
///       particleColors: [Colors.red, Colors.pink],
///     ),
///     FireworkConfig(
///       delay: Duration(milliseconds: 500),
///       startingPosition: Offset(300, 500),
///       endingPosition: Offset(400, 200),
///       particleColors: [Colors.blue, Colors.cyan],
///     ),
///   ],
///   onComplete: () => print('Show completed!'),
/// )
/// ```
class FireworkShow extends StatefulWidget {
  /// The list of firework configurations to display in sequence.
  final List<FireworkConfig> fireworks;

  /// Called when all fireworks in the show have completed.
  final VoidCallback? onComplete;

  /// Creates a firework show with the specified firework configurations.
  const FireworkShow({super.key, required this.fireworks, this.onComplete});

  @override
  State<FireworkShow> createState() => _FireworkShowState();
}

class _FireworkShowState extends State<FireworkShow> {
  int _currentIndex = 0;
  final List<Widget> _activeFireworks = [];

  @override
  void initState() {
    super.initState();
    _startNext();
  }

  void _startNext() {
    if (_currentIndex >= widget.fireworks.length) {
      return;
    }

    final config = widget.fireworks[_currentIndex];

    Future.delayed(config.delay, () {
      if (mounted) {
        setState(() {
          _activeFireworks.add(
            Firework(
              key: ValueKey(_currentIndex),
              startingPosition: config.startingPosition,
              endingPosition: config.endingPosition,
              rocketIsVisible: config.rocketIsVisible,
              curve: config.curve,
              rocketColor: config.rocketColor,
              rocketSpiral: config.rocketSpiral,
              rocketSpiralIntensity: config.rocketSpiralIntensity,
              rocketSpiralFrequency: config.rocketSpiralFrequency,
              rocketDuration: config.rocketDuration,
              ringSpeed: config.ringSpeed,
              ringThickness: config.ringThickness,
              ringFadeSpeed: config.ringFadeSpeed,
              particleCount: config.particleCount,
              particleFadeSpeed: config.particleFadeSpeed,
              particleFadeVariance: config.particleFadeVariance,
              particleLength: config.particleLength,
              particleWidth: config.particleWidth,
              particleRingGlow: config.particleRingGlow,
              particleSpeed: config.particleSpeed,
              particleSpeedVariance: config.particleSpeedVariance,
              particleColors: config.particleColors,
              ringColor: config.ringColor,
              gravity: config.gravity,
              onComplete: () => _onFireworkComplete(_currentIndex),
            ),
          );
        });

        _currentIndex++;
        _startNext();
      }
    });
  }

  void _onFireworkComplete(int index) {
    if (mounted) {
      setState(() {
        _activeFireworks.removeWhere((widget) {
          return widget.key == ValueKey(index);
        });
      });

      // Check if all fireworks are complete and call onComplete if so
      if (_activeFireworks.isEmpty &&
          _currentIndex >= widget.fireworks.length) {
        Future.microtask(() => widget.onComplete?.call());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _activeFireworks);
  }
}

/// Configuration for a single firework in a show.
///
/// This class contains all the parameters needed to customize a firework's
/// appearance and behavior when used in a [FireworkShow].
///
/// ## Example Usage
/// ```dart
/// // Basic firework configuration
/// FireworkConfig(
///   delay: Duration(milliseconds: 500),
///   startingPosition: Offset(100, 500),
///   endingPosition: Offset(200, 200),
///   particleColors: [Colors.red, Colors.orange],
///   particleCount: 30,
///   gravity: 120.0,
/// )
///
/// // Spiral firework configuration
/// FireworkConfig(
///   delay: Duration(milliseconds: 500),
///   startingPosition: Offset(100, 500),
///   endingPosition: Offset(200, 200),
///   rocketSpiral: true,
///   rocketSpiralIntensity: 1.5,
///   rocketSpiralFrequency: 2.0,
///   particleColors: [Colors.cyan, Colors.blue],
/// )
/// ```
class FireworkConfig {
  /// The delay before this firework starts after the show begins.
  final Duration delay;

  /// The starting position of the rocket. If null, defaults to bottom center of screen.
  final Offset? startingPosition;

  /// The ending position where the rocket explodes. If null, defaults to center of screen.
  final Offset? endingPosition;

  /// Whether the rocket trail is visible during the rocket phase.
  final bool rocketIsVisible;

  /// The animation curve for the rocket's movement.
  final Curve curve;

  /// The color of the rocket trail.
  final Color rocketColor;

  /// Whether the rocket follows a spiral path during its flight.
  final bool rocketSpiral;

  /// The intensity of the spiral effect (higher values = wider spiral).
  final double rocketSpiralIntensity;

  /// The frequency of the spiral effect (higher values = more spirals).
  final double rocketSpiralFrequency;

  /// The duration of the rocket phase animation.
  final Duration rocketDuration;

  /// The speed at which the explosion ring expands (pixels per second).
  final double ringSpeed;

  /// The thickness of the explosion ring border.
  final double ringThickness;

  /// The speed at which the explosion ring fades out.
  final double ringFadeSpeed;

  /// The number of particles in the explosion.
  final int particleCount;

  /// The speed at which particles fade out.
  final double particleFadeSpeed;

  /// The variance in particle fade speed (0.0 to 1.0).
  final double particleFadeVariance;

  /// The length of each particle in pixels.
  final double particleLength;

  /// The width of each particle in pixels.
  final double particleWidth;

  /// Whether particles have a glowing effect.
  final bool particleRingGlow;

  /// The speed at which particles move away from the explosion center.
  final double particleSpeed;

  /// The variance in particle speed (0.0 to 1.0).
  final double particleSpeedVariance;

  /// The colors that particles can have. Colors are randomly assigned to particles.
  final List<Color> particleColors;

  /// The color of the explosion ring.
  final Color ringColor;

  /// The gravity force applied to particles (pixels per second squared).
  /// Higher values make particles fall faster.
  final double gravity;

  /// Creates a firework configuration with customizable properties.
  ///
  /// All parameters are optional and have sensible defaults for typical firework effects.
  const FireworkConfig({
    this.delay = Duration.zero,
    this.startingPosition,
    this.endingPosition,
    this.rocketIsVisible = true,
    this.curve = Curves.easeInOut,
    this.rocketColor = Colors.white,
    this.rocketSpiral = false,
    this.rocketSpiralIntensity = 1.0,
    this.rocketSpiralFrequency = 1.0,
    this.rocketDuration = const Duration(milliseconds: 600),
    this.ringSpeed = 140.0,
    this.ringThickness = 3.0,
    this.ringFadeSpeed = 4.0,
    this.particleCount = 24,
    this.particleFadeSpeed = 1.6,
    this.particleFadeVariance = 0.1,
    this.particleLength = 8.0,
    this.particleWidth = 4.0,
    this.particleRingGlow = true,
    this.particleSpeed = 120.0,
    this.particleSpeedVariance = 0.06,
    this.particleColors = const [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
    ],
    this.ringColor = Colors.white,
    this.gravity = 100.0,
  });
}
