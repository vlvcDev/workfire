import 'package:flutter/material.dart';
import 'package:workfire/workfire.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workfire Demo - Interactive Fireworks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FireworksDemoPage(),
    );
  }
}

class FireworksDemoPage extends StatefulWidget {
  const FireworksDemoPage({super.key});

  @override
  State<FireworksDemoPage> createState() => _FireworksDemoPageState();
}

class _FireworksDemoPageState extends State<FireworksDemoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Single firework state
  bool _showSingleFirework = false;
  bool _singleRocketVisible = true;
  bool _singleRocketSpiral = false;
  bool _singleParticleGlow = true;
  double _singleParticleCount = 24;
  double _singleParticleSpeed = 120;
  double _singleParticleFadeSpeed = 2;
  double _singleRingSpeed = 140;
  double _singleRingThickness = 3;
  double _singleGravity = 100;
  double _singleRocketSpiralIntensity = 2.0;
  double _singleRocketSpiralFrequency = 2.0;
  Color _singleRocketColor = Colors.white;
  Color _singleRingColor = Colors.white;
  final List<Color> _singleParticleColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
  ];

  // Firework show state
  bool _showFireworkShow = false;
  List<FireworkConfig> _fireworkConfigs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeFireworkShow();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeFireworkShow() {
    // Create 10 fireworks with different configurations
    _fireworkConfigs = List.generate(10, (index) {
      final colors = [
        [Colors.red, Colors.pink],
        [Colors.blue, Colors.cyan],
        [Colors.yellow, Colors.orange],
        [Colors.green, Colors.lime],
        [Colors.purple, Colors.deepPurple],
        [Colors.indigo, Colors.blue],
        [Colors.teal, Colors.cyan],
        [Colors.amber, Colors.orange],
        [Colors.red, Colors.deepOrange],
        [Colors.pink, Colors.purple],
      ];

      return FireworkConfig(
        delay: Duration(milliseconds: index * 150),
        startingPosition: Offset(
          100 + (index % 5) * 80.0, // Spread across bottom
          1000, // Bottom of screen
        ),
        endingPosition: Offset(
          120 + (index % 5) * 80.0, // Spread across middle
          200 + (index % 3) * 80.0, // Vary height
        ),
        particleColors: colors[index % colors.length],
        particleCount: 15 + (index % 3) * 5,
        particleLength: index % 3 == 0 ? 12.0 : 8.0,
        ringColor: colors[index % colors.length].first,
        gravity: 80 + (index % 3) * 20.0,
        rocketSpiral: index % 3 == 0, // Every third firework has spiral
        rocketSpiralIntensity: 2.0 + (index % 2) * 0.5,
        rocketSpiralFrequency: 2.0 + (index % 2) * 1.0,
      );
    });
  }

  void _launchSingleFirework() {
    setState(() {
      _showSingleFirework = true;
    });
  }

  void _launchFireworkShow() {
    setState(() {
      _showFireworkShow = true;
    });
  }

  void _resetSingleFirework() {
    setState(() {
      _showSingleFirework = false;
    });
  }

  void _resetFireworkShow() {
    setState(() {
      _showFireworkShow = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        title: const Text(
          'Workfire Demo - Interactive Fireworks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1a1a1a),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: 'Single Firework'),
            Tab(text: 'Firework Show'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Main content
          TabBarView(
            controller: _tabController,
            children: [_buildSingleFireworkTab(), _buildFireworkShowTab()],
          ),

          // Single firework overlay
          if (_showSingleFirework)
            Firework(
              startingPosition: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height - 100,
              ),
              endingPosition: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 3,
              ),
              rocketIsVisible: _singleRocketVisible,
              rocketSpiral: _singleRocketSpiral,
              rocketSpiralIntensity: _singleRocketSpiralIntensity,
              rocketSpiralFrequency: _singleRocketSpiralFrequency,
              rocketColor: _singleRocketColor,
              particleCount: _singleParticleCount.round(),
              particleSpeed: _singleParticleSpeed,
              particleFadeSpeed: _singleParticleFadeSpeed,
              particleRingGlow: _singleParticleGlow,
              ringSpeed: _singleRingSpeed,
              ringThickness: _singleRingThickness,
              ringColor: _singleRingColor,
              gravity: _singleGravity,
              particleColors: _singleParticleColors,
              onComplete: () {
                setState(() {
                  _showSingleFirework = false;
                });
              },
            ),

          // Firework show overlay
          if (_showFireworkShow)
            FireworkShow(
              fireworks: _fireworkConfigs,
              onComplete: () {
                setState(() {
                  _showFireworkShow = false;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSingleFireworkTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            '🎆 Single Firework Controls',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Customize all aspects of a single firework and launch it to see the effects.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Launch button
          Center(
            child: ElevatedButton(
              onPressed: _showSingleFirework
                  ? _resetSingleFirework
                  : _launchSingleFirework,
              style: ElevatedButton.styleFrom(
                backgroundColor: _showSingleFirework
                    ? Colors.red
                    : Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _showSingleFirework ? 'Reset Firework' : 'Launch Firework',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Rocket controls
          _buildSectionHeader('Rocket Properties'),
          _buildCheckboxTile('Show Rocket Trail', _singleRocketVisible, (
            value,
          ) {
            setState(() {
              _singleRocketVisible = value;
            });
          }),
          _buildCheckboxTile('Spiral Rocket Path', _singleRocketSpiral, (
            value,
          ) {
            setState(() {
              _singleRocketSpiral = value;
            });
          }),

          if (_singleRocketSpiral) ...[
            _buildSlider(
              'Spiral Intensity',
              _singleRocketSpiralIntensity,
              0.1,
              3.0,
              (value) {
                setState(() {
                  _singleRocketSpiralIntensity = value;
                });
              },
            ),
            _buildSlider(
              'Spiral Frequency',
              _singleRocketSpiralFrequency,
              0.1,
              5.0,
              (value) {
                setState(() {
                  _singleRocketSpiralFrequency = value;
                });
              },
            ),
          ],

          _buildColorPicker('Rocket Color', _singleRocketColor, (color) {
            setState(() {
              _singleRocketColor = color;
            });
          }),

          const SizedBox(height: 24),

          // Explosion controls
          _buildSectionHeader('Explosion Properties'),
          _buildSlider('Particle Count', _singleParticleCount, 5, 50, (value) {
            setState(() {
              _singleParticleCount = value;
            });
          }),
          _buildSlider('Particle Speed', _singleParticleSpeed, 50, 200, (
            value,
          ) {
            setState(() {
              _singleParticleSpeed = value;
            });
          }),
          _buildSlider(
            'Particle Fade Speed',
            _singleParticleFadeSpeed,
            0.5,
            5.0,
            (value) {
              setState(() {
                _singleParticleFadeSpeed = value;
              });
            },
          ),
          _buildSlider('Ring Speed', _singleRingSpeed, 50, 300, (value) {
            setState(() {
              _singleRingSpeed = value;
            });
          }),
          _buildSlider('Ring Thickness', _singleRingThickness, 0, 10, (value) {
            setState(() {
              _singleRingThickness = value;
            });
          }),
          _buildSlider('Gravity', _singleGravity, 0, 200, (value) {
            setState(() {
              _singleGravity = value;
            });
          }),
          _buildCheckboxTile('Particle Glow Effect', _singleParticleGlow, (
            value,
          ) {
            setState(() {
              _singleParticleGlow = value;
            });
          }),

          _buildColorPicker('Ring Color', _singleRingColor, (color) {
            setState(() {
              _singleRingColor = color;
            });
          }),

          const SizedBox(height: 16),

          // Particle colors
          _buildParticleColorSelector(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFireworkShowTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            '🎇 Firework Show Controls',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Launch a spectacular show with 10 different fireworks, each with unique properties.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Launch button
          Center(
            child: ElevatedButton(
              onPressed: _showFireworkShow
                  ? _resetFireworkShow
                  : _launchFireworkShow,
              style: ElevatedButton.styleFrom(
                backgroundColor: _showFireworkShow ? Colors.red : Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _showFireworkShow ? 'Stop Show' : 'Launch Show (10 Fireworks)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Show details
          _buildSectionHeader('Show Details'),
          const Text(
            'This show includes:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          ...List.generate(_fireworkConfigs.length, (index) {
            final config = _fireworkConfigs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  // Firework number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: config.particleColors.first,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Firework details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Firework ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Delay: ${config.delay.inMilliseconds}ms • '
                          'Particles: ${config.particleCount} • '
                          'Gravity: ${config.gravity.toStringAsFixed(0)} • '
                          '${config.rocketSpiral ? 'Spiral' : 'Straight'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Color chips
                        Row(
                          children: config.particleColors.map((color) {
                            return Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white24),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 32),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.withAlpha(76),
              ), // 0.3 * 255 ≈ 76
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Tips for Best Experience',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Each firework launches with a different delay\n'
                  '• Some fireworks have spiral rocket paths\n'
                  '• Different colors and particle counts for variety\n'
                  '• Varying gravity effects create unique patterns',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.orange,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.orange,
              overlayColor: Colors.orange.withAlpha(76),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) * 10).round(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (newValue) => onChanged(newValue ?? false),
            activeColor: Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(
    String label,
    Color currentColor,
    Function(Color) onChanged,
  ) {
    final colors = [
      Colors.white,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.teal,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) {
              final isSelected = color == currentColor;
              return GestureDetector(
                onTap: () => onChanged(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white24,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildParticleColorSelector() {
    final availableColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.teal,
      Colors.lime,
      Colors.indigo,
      Colors.amber,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Particle Colors',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          'Selected Colors:',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _singleParticleColors.map((color) {
            return Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Available Colors (tap to toggle):',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableColors.map((color) {
            final isSelected = _singleParticleColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    if (_singleParticleColors.length > 1) {
                      _singleParticleColors.remove(color);
                    }
                  } else {
                    _singleParticleColors.add(color);
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
