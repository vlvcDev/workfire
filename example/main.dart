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
      title: 'Workfire - Fireworks Widget Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FireworksDemo(),
    );
  }
}

class FireworksDemo extends StatefulWidget {
  const FireworksDemo({super.key});

  @override
  State<FireworksDemo> createState() => _FireworksDemoState();
}

class _FireworksDemoState extends State<FireworksDemo> {
  bool _showFirework = false;
  bool _showFireworkShow = false;

  void _launchSingleFirework() {
    setState(() {
      _showFirework = true;
    });

    // Reset after animation completes
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showFirework = false;
        });
      }
    });
  }

  void _launchFireworkShow() {
    setState(() {
      _showFireworkShow = true;
    });

    // Reset after show completes
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _showFireworkShow = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1421),
      appBar: AppBar(
        title: const Text(
          'Workfire - Fireworks Widget Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1a1a2e),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Demo controls
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🎆 Workfire Demo 🎆',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _showFirework ? null : _launchSingleFirework,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Launch Single Firework'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showFireworkShow ? null : _launchFireworkShow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Launch Firework Show'),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Click the buttons to see different firework demonstrations.\n'
                    'The fireworks are completely click-through and won\'t interfere with your UI!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Single firework
          if (_showFirework)
            Firework(
              startingPosition: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height,
              ),
              endingPosition: Offset(
                MediaQuery.of(context).size.width / 3,
                MediaQuery.of(context).size.height / 3,
              ),
              particleColors: const [Colors.red, Colors.orange, Colors.yellow],
              ringColor: Colors.red,
              onComplete: () {
                setState(() {
                  _showFirework = false;
                });
              },
            ),

          // Firework show
          if (_showFireworkShow)
            FireworkShow(
              fireworks: [
                FireworkConfig(
                  delay: Duration.zero,
                  startingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height,
                  ),
                  endingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.height * 0.4,
                  ),
                  particleColors: const [Colors.red, Colors.pink],
                  ringColor: Colors.red,
                  particleCount: 12,
                  curve: Curves.easeOut,
                ),
                FireworkConfig(
                  delay: Duration.zero,
                  startingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height,
                  ),
                  endingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.height * 0.5,
                  ),
                  particleColors: const [Colors.blue, Colors.cyan],
                  ringColor: Colors.blue,
                  particleCount: 16,
                  curve: Curves.easeOut,
                ),
                FireworkConfig(
                  delay: Duration.zero,
                  startingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height,
                  ),
                  endingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                  particleColors: const [
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                  ringColor: Colors.orange,
                  particleCount: 20,
                  curve: Curves.easeOut,
                ),
                FireworkConfig(
                  delay: Duration(milliseconds: 600),
                  startingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height,
                  ),
                  endingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.height * 0.4,
                  ),
                  particleColors: const [Colors.red, Colors.pink],
                  ringColor: Colors.red,
                  particleCount: 12,
                  curve: Curves.easeOut,
                ),
                FireworkConfig(
                  delay: const Duration(milliseconds: 600),
                  startingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height,
                  ),
                  endingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.height * 0.5,
                  ),
                  particleColors: const [Colors.blue, Colors.cyan],
                  ringColor: Colors.blue,
                  particleCount: 16,
                  curve: Curves.easeOut,
                ),
                FireworkConfig(
                  delay: const Duration(milliseconds: 600),
                  startingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height,
                  ),
                  endingPosition: Offset(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                  particleColors: const [
                    Colors.yellow,
                    Colors.orange,
                    Colors.red,
                  ],
                  ringColor: Colors.orange,
                  particleCount: 20,
                  curve: Curves.easeOut,
                ),
              ],
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
}
