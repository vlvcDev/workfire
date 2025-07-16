import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workfire/workfire.dart';

void main() {
  group('Firework Widget Tests', () {
    testWidgets('Firework completes without early termination', (WidgetTester tester) async {
      bool completed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Firework(
              particleFadeSpeed: 1.0,
              particleFadeVariance: 0.2,
              onComplete: () {
                completed = true;
              },
            ),
          ),
        ),
      );
      
      // Pump until the firework completes
      await tester.pumpAndSettle(const Duration(seconds: 10));
      
      // Verify that the firework completed
      expect(completed, true);
    });
    
    testWidgets('FireworkShow completes all fireworks', (WidgetTester tester) async {
      bool completed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FireworkShow(
              fireworks: [
                const FireworkConfig(
                  delay: Duration.zero,
                  particleFadeSpeed: 2.0,
                ),
                const FireworkConfig(
                  delay: Duration(milliseconds: 500),
                  particleFadeSpeed: 2.0,
                ),
              ],
              onComplete: () {
                completed = true;
              },
            ),
          ),
        ),
      );
      
      // Pump until the firework show completes
      await tester.pumpAndSettle(const Duration(seconds: 10));
      
      // Verify that the firework show completed
      expect(completed, true);
    });
    
    testWidgets('Particles fade out properly without getting stuck', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Firework(
              particleFadeSpeed: 3.0,
              particleFadeVariance: 0.0,
              particleCount: 5,
            ),
          ),
        ),
      );
      
      // Let the rocket launch
      await tester.pump(const Duration(milliseconds: 900));
      
      // Start explosion
      await tester.pump();
      
      // Check that particles are visible initially
      expect(find.byType(Firework), findsOneWidget);
      
      // Wait for particles to fade out
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // Firework should be gone after completion
      expect(find.byType(Firework), findsNothing);
    });
  });
}
