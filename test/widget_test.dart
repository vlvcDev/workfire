import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workfire/workfire.dart';

void main() {
  group('Firework Widget Tests', () {
    testWidgets('Firework widget can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Firework(
              startingPosition: const Offset(100, 500),
              endingPosition: const Offset(200, 200),
              particleColors: const [Colors.red, Colors.blue],
            ),
          ),
        ),
      );
      
      expect(find.byType(Firework), findsOneWidget);
    });

    testWidgets('Firework widget with custom properties can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Firework(
              startingPosition: const Offset(100, 500),
              endingPosition: const Offset(200, 200),
              particleColors: const [Colors.red, Colors.blue, Colors.green],
              ringColor: Colors.yellow,
              particleCount: 15,
              gravity: 75.0,
            ),
          ),
        ),
      );
      
      expect(find.byType(Firework), findsOneWidget);
    });
  });

  group('FireworkConfig Tests', () {
    test('FireworkConfig can be created with default values', () {
      final config = FireworkConfig(
        delay: Duration.zero,
        startingPosition: const Offset(100, 500),
        endingPosition: const Offset(200, 200),
        particleColors: const [Colors.red, Colors.blue],
      );
      
      expect(config.delay, Duration.zero);
      expect(config.startingPosition, const Offset(100, 500));
      expect(config.endingPosition, const Offset(200, 200));
      expect(config.particleColors, const [Colors.red, Colors.blue]);
      expect(config.gravity, 100.0); // Default gravity from FireworkConfig
    });

    test('FireworkConfig can be created with custom gravity', () {
      final config = FireworkConfig(
        delay: Duration.zero,
        startingPosition: const Offset(100, 500),
        endingPosition: const Offset(200, 200),
        particleColors: const [Colors.red, Colors.blue],
        gravity: 75.0,
      );
      
      expect(config.gravity, 75.0);
    });
  });
}
