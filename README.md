# Workfire 🎆

A beautiful, performant, and customizable firework widget for Flutter applications.

**[🚀 Try the Interactive Demo](https://vlvcdev.github.io/workfire/)**

## Features

- **Click-through design**: Fireworks won't interfere with your app's UI
- **Highly customizable**: Control every aspect of the firework animation
- **Performance optimized**: Automatic cleanup and efficient rendering
- **Easy to use**: Simple API for single fireworks or complex shows
- **Cross-platform**: Works on all Flutter-supported platforms
<img src="https://github.com/user-attachments/assets/b9ed747c-c830-4f1c-92a1-d97b138201c2" alt="workfire_demo" width="400"/>


## Installation

Add `workfire` to your `pubspec.yaml`:

```yaml
dependencies:
  workfire: ^1.0.2
```

## Quick Start

### Single Firework

```dart
import 'package:workfire/workfire.dart';

// Basic firework
Firework()

// Customized firework
Firework(
  particleColors: [Colors.red, Colors.blue, Colors.yellow],
  particleCount: 20,
  particleDistance: 150,
  rocketColor: Colors.white,
)
```

### Firework Show

```dart
FireworkShow(
  fireworks: [
    FireworkConfig(
      delay: Duration.zero,
      particleColors: [Colors.red, Colors.pink],
    ),
    FireworkConfig(
      delay: Duration(milliseconds: 500),
      particleColors: [Colors.blue, Colors.cyan],
    ),
    FireworkConfig(
      delay: Duration(seconds: 1),
      particleColors: [Colors.yellow, Colors.orange],
    ),
  ],
)
```

## Customization Options

### Part 1: Rocket Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `startingPosition` | `Offset?` | Bottom center | Starting position of the rocket |
| `endingPosition` | `Offset?` | Screen center | Where the rocket explodes |
| `rocketIsVisible` | `bool` | `true` | Whether to show the rocket |
| `curve` | `Curve` | `Curves.linear` | Animation curve for rocket movement |
| `rocketColor` | `Color` | `Colors.white` | Color of the rocket |
| `rocketDuration` | `Duration` | `800ms` | Time for rocket to reach destination |

### Part 2: Explosion Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ringSpeed` | `double` | `200.0` | Speed of ring expansion |
| `ringThickness` | `double` | `3.0` | Thickness of the ring (0 = no ring) |
| `ringFadeSpeed` | `double` | `1.0` | How fast the ring fades out |
| `particleCount` | `int` | `12` | Number of particles in explosion |
| `particleFadeSpeed` | `double` | `1.0` | How fast particles fade out |
| `particleFadeVariance` | `double` | `0.2` | Variance in particle fade speed |
| `particleLength` | `double` | `20.0` | Length of each particle |
| `particleWidth` | `double` | `3.0` | Width of each particle |
| `particleRingGlow` | `bool` | `true` | Glow effect on particles and ring |
| `particleSpeed` | `double` | `150.0` | Speed of particle movement |
| `particleSpeedVariance` | `double` | `0.2` | Variance in particle speed |
| `particleColors` | `List<Color>` | `[red, blue, yellow, green]` | Colors for particles |
| `ringColor` | `Color` | `Colors.white` | Color of the explosion ring |
| `gravity` | `double` | `50.0` | Gravity effect on particles (downward acceleration) |

**Note:** Particles travel continuously and their final distance is determined by their fade speed. When a particle completely fades out, it's removed from the animation. This creates a more realistic effect where particles don't stop moving while still visible. The gravity parameter adds realistic downward acceleration to particles, making them fall naturally over time.

## Examples

### Celebration Firework
```dart
Firework(
  particleColors: [Colors.gold, Colors.yellow, Colors.orange],
  particleCount: 25,
  particleRingGlow: true,
  ringColor: Colors.amber,
  gravity: 80.0,
)
```

### Subtle Firework
```dart
Firework(
  rocketIsVisible: false,
  ringThickness: 0,
  particleColors: [Colors.white],
  particleCount: 8,
  particleRingGlow: false,
  gravity: 30.0,
)
```

### Zero Gravity Firework
```dart
Firework(
  particleColors: [Colors.cyan, Colors.blue],
  particleCount: 15,
  gravity: 0.0,
)
```

### Grand Finale Show
```dart
FireworkShow(
  fireworks: List.generate(5, (index) => 
    FireworkConfig(
      delay: Duration(milliseconds: index * 200),
      startingPosition: Offset(
        MediaQuery.of(context).size.width * (0.2 + index * 0.15),
        MediaQuery.of(context).size.height,
      ),
      endingPosition: Offset(
        MediaQuery.of(context).size.width * (0.2 + index * 0.15),
        MediaQuery.of(context).size.height * (0.3 + index * 0.1),
      ),
      particleColors: [
        [Colors.red, Colors.pink],
        [Colors.blue, Colors.cyan],
        [Colors.yellow, Colors.orange],
        [Colors.green, Colors.lime],
        [Colors.purple, Colors.deepPurple],
      ][index],
      particleCount: 15 + index * 2,
    ),
  ),
)
```

## API Reference

### Core Classes

- **`Firework`** - The main widget for creating single firework animations
- **`FireworkShow`** - Widget for orchestrating multiple fireworks in sequence  
- **`FireworkConfig`** - Configuration class for customizing firework properties in shows

### Key Features

- **Realistic Physics**: Gravity effects and natural particle movement
- **Spiral Rocket Paths**: Configurable spiral trajectories with intensity and frequency controls
- **Performance Optimized**: Efficient rendering with automatic cleanup
- **Fully Customizable**: Every aspect of the animation can be configured
- **Click-through Design**: Won't interfere with your app's touch interactions

For detailed API documentation, see the [API docs](https://pub.dev/documentation/workfire/latest/).

**[🎆 Interactive Demo](https://vlvcdev.github.io/workfire/)** - Try all features live in your browser!

## Best Practices

1. **Performance**: Always provide an `onComplete` callback to manage widget lifecycle
2. **Positioning**: Use `MediaQuery.of(context).size` for responsive positioning
3. **Colors**: Use contrasting colors for better visibility

## Technical Details

- Uses `IgnorePointer` to ensure click-through behavior
- Automatic cleanup of animation controllers and widgets
- Optimized rendering with conditional widget building
- Memory efficient particle system

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests.
