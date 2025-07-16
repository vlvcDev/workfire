import 'package:flutter/material.dart';
import 'package:workfire/workfire.dart';

void main() {
  runApp(const AdvancedFireworkExample());
}

class AdvancedFireworkExample extends StatelessWidget {
  const AdvancedFireworkExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Firework Example',
      theme: ThemeData.dark(),
      home: const AdvancedFireworkScreen(),
    );
  }
}

class AdvancedFireworkScreen extends StatefulWidget {
  const AdvancedFireworkScreen({super.key});

  @override
  State<AdvancedFireworkScreen> createState() => _AdvancedFireworkScreenState();
}

class _AdvancedFireworkScreenState extends State<AdvancedFireworkScreen> {
  bool _showCelebration = false;
  bool _showGrandFinale = false;

  void _launchCelebration() {
    setState(() {
      _showCelebration = true;
    });
    
    // Auto-reset after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showCelebration = false;
        });
      }
    });
  }

  void _launchGrandFinale() {
    setState(() {
      _showGrandFinale = true;
    });
    
    // Auto-reset after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showGrandFinale = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFF001122),
      appBar: AppBar(
        title: const Text('Advanced Firework Features'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Stack(
        children: [
          // App content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.celebration,
                  size: 80,
                  color: Colors.amber,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Advanced Firework Demonstrations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                
                ElevatedButton.icon(
                  onPressed: _showCelebration ? null : _launchCelebration,
                  icon: const Icon(Icons.star),
                  label: const Text('Celebration Fireworks'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                
                ElevatedButton.icon(
                  onPressed: _showGrandFinale ? null : _launchGrandFinale,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Grand Finale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'These examples show advanced features:\n'
                    '• Custom positioning and timing\n'
                    '• Multiple firework sequences\n'
                    '• Varied particle counts and colors\n'
                    '• Different animation curves\n'
                  ),
                ),
              ],
            ),
          ),
          
          // Celebration fireworks
          if (_showCelebration)
            FireworkShow(
              fireworks: [
                // Left firework
                FireworkConfig(
                  delay: Duration.zero,
                  startingPosition: Offset(size.width * 0.2, size.height),
                  endingPosition: Offset(size.width * 0.2, size.height * 0.3),
                  particleColors: const [Colors.red, Colors.pink, Colors.orange],
                  particleCount: 36,
                  particleLength: 12,
                  curve: Curves.easeOut,
                  rocketDuration: const Duration(milliseconds: 600),
                ),
                
                // Right firework
                FireworkConfig(
                  delay: const Duration(milliseconds: 300),
                  startingPosition: Offset(size.width * 0.8, size.height),
                  endingPosition: Offset(size.width * 0.8, size.height * 0.4),
                  particleColors: const [Colors.blue, Colors.cyan, Colors.lightBlue],
                  particleCount: 15,
                  curve: Curves.easeOut,
                  rocketDuration: const Duration(milliseconds: 700),
                ),
                
                // Center firework
                FireworkConfig(
                  delay: const Duration(milliseconds: 600),
                  startingPosition: Offset(size.width * 0.5, size.height),
                  endingPosition: Offset(size.width * 0.5, size.height * 0.25),
                  particleColors: const [Colors.yellow, Colors.amber, Colors.orange],
                  particleCount: 24,
                  curve: Curves.easeOut,
                  rocketDuration: const Duration(milliseconds: 800),
                  ringThickness: 4,
                  ringSpeed: 250,
                ),
              ],
              onComplete: () {
                setState(() {
                  _showCelebration = false;
                });
              },
            ),
          
          // Grand finale
          if (_showGrandFinale)
            FireworkShow(
              fireworks: List.generate(8, (index) {
                final colors = [
                  [Colors.red, Colors.deepOrange],
                  [Colors.blue, Colors.indigo],
                  [Colors.green, Colors.teal],
                  [Colors.purple, Colors.deepPurple],
                  [Colors.yellow, Colors.amber],
                  [Colors.pink, Colors.pinkAccent],
                  [Colors.orange, Colors.deepOrange],
                  [Colors.cyan, Colors.lightBlue],
                ];
                
                return FireworkConfig(
                  delay: Duration(milliseconds: index * 150),
                  startingPosition: Offset(
                    size.width * (0.1 + (index % 4) * 0.25),
                    size.height,
                  ),
                  endingPosition: Offset(
                    size.width * (0.1 + (index % 4) * 0.25),
                    size.height * (0.2 + (index ~/ 4) * 0.3),
                  ),
                  particleColors: colors[index],
                  particleCount: 12 + (index % 3) * 4,
                  particleSpeed: 120 + (index % 2) * 30,
                  curve: index % 2 == 0 ? Curves.easeOut : Curves.easeIn,
                  rocketDuration: Duration(milliseconds: 500 + (index % 3) * 100),
                  particleSpeedVariance: 0.3,
                  particleFadeVariance: 0.3,
                );
              }),
              onComplete: () {
                setState(() {
                  _showGrandFinale = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
