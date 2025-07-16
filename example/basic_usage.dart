import 'package:flutter/material.dart';
import 'package:workfire/workfire.dart';

void main() {
  runApp(const BasicFireworkExample());
}

class BasicFireworkExample extends StatelessWidget {
  const BasicFireworkExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Firework Example',
      theme: ThemeData.dark(),
      home: const FireworkExampleScreen(),
    );
  }
}

class FireworkExampleScreen extends StatefulWidget {
  const FireworkExampleScreen({super.key});

  @override
  State<FireworkExampleScreen> createState() => _FireworkExampleScreenState();
}

class _FireworkExampleScreenState extends State<FireworkExampleScreen> {
  bool _showFirework = false;

  void _launchFirework() {
    setState(() {
      _showFirework = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Basic Firework Example'),
        backgroundColor: Colors.grey[900],
      ),
      body: Stack(
        children: [
          // Your app content goes here
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _launchFirework,
                  child: const Text('Launch Firework'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'The firework is completely click-through!\nYou can interact with everything normally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          
          // Firework overlay - completely click-through
          if (_showFirework)
            Firework(
              onComplete: () {
                setState(() {
                  _showFirework = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
