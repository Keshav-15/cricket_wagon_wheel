# Cricket Wagon Wheel

A highly customizable Flutter package for displaying interactive cricket wagon wheel diagrams with draggable markers, static markers, and extensive configuration options.

## Features

- 🎯 **Interactive Draggable Marker** - Place and drag markers to track shot positions
- 📍 **Static Markers** - Display multiple historical shot placements
- 🎨 **Fully Customizable** - Configure colors, sizes, borders, animations, and more
- 🏏 **Cricket-Specific** - Built-in cricket fielding position labels and sector divisions
- 🖼️ **Flexible Rendering** - Custom widget builders for complete UI control
- 🔄 **Left/Right Handed Support** - Automatic label mirroring based on batsman orientation
- 🎬 **Animations** - Splash effects and sector highlighting on marker placement
- 📐 **Responsive Sizing** - Automatic size calculations based on available space

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  cricket_wagon_wheel: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:cricket_wagon_wheel/cricket_wagon_wheel.dart';

WagonWheel(
  config: WagonWheelConfig(
    boundary: WagonWheelBoundaryProperties(
      groundSize: 300,
      stadiumBoundarySize: 20,
    ),
    pitch: WagonWheelPitchProperties(
      showBatsman: true,
      showLegOffLabels: true,
    ),
  ),
  onMarkerPositionChanged: (phi, t) {
    print('Marker position: phi=$phi, t=$t');
  },
)
```

## Usage

### Basic Usage

```dart
WagonWheel()  // Uses all default configurations
```

### With Marker and Initial Position

```dart
WagonWheel(
  config: WagonWheelConfig(
    marker: WagonWheelMarkerProperties(
      initialPhi: 0.92,  // Angle in radians
      initialT: 0.6,     // 60% from center
    ),
  ),
  onMarkerPositionChanged: (phi, t) {
    print('Marker moved: phi=$phi, t=$t');
  },
)
```

### Complete Customization Example

```dart
WagonWheel(
  config: WagonWheelConfig(
    isLeftHanded: false,
    boundary: WagonWheelBoundaryProperties(
      groundSize: 300,
      groundBoundaryOvalness: 0.1,
      stadiumBoundarySize: 20,
      stadiumBoundaryColor: Colors.green,
      groundBoundaryColor: Colors.amber,
      groundBoundaryBorder: Border.all(color: Colors.white, width: 2),
      stadiumBoundaryBorder: Border.all(color: Colors.black, width: 3),
      thirtyYardsBoundaryColor: Colors.blue,
      thirtyYardsBoundaryBorder: Border.all(color: Colors.white),
    ),
    pitch: WagonWheelPitchProperties(
      pitchColor: Colors.brown,
      pitchBorder: Border.all(color: Colors.black, width: 2),
      showBatsman: true,
      batsmanIconPath: 'assets/icons/ic_batsman.svg',  // Your custom icon
      showLegOffLabels: true,
      legLabelText: 'LEG',
      offLabelText: 'OFF',
      showCircleIndicator: true,
      circleIndicatorColor: Colors.green,
    ),
    text: WagonWheelTextProperties(
      textColor: Colors.white,
      baseFontSize: 14,
      textFontWeight: FontWeight.bold,
    ),
    boundaryLines: WagonWheelBoundaryLineProperties(
      lineColor: Colors.white,
      lineOpacity: 0.4,
      lineWidth: 1.5,
    ),
    marker: WagonWheelMarkerProperties(
      initialPhi: 0.5,
      initialT: 0.8,
      markerLineColor: Colors.red,
      markerCircleColor: Colors.red,
      markerCircleSize: 6.0,
      enableMarker: true,
      lockToBorder: false,
    ),
    staticMarkers: [
      WagonWheelMarkerProperties(
        initialPhi: 0.3,
        initialT: 0.7,
        markerLineColor: Colors.blue,
        markerCircleColor: Colors.blue,
      ),
      WagonWheelMarkerProperties(
        initialPhi: 1.2,
        initialT: 0.6,
        markerLineColor: Colors.orange,
        markerCircleColor: Colors.orange,
      ),
    ],
    animation: WagonWheelAnimationProperties(
      splashColor: Colors.white,
      splashOpacity: 0.3,
      selectedSectorBackgroundColor: Colors.white,
      selectedSectorBackgroundOpacity: 0.15,
    ),
  ),
  onMarkerPositionChanged: (phi, t) {
    // Handle marker position changes
  },
)
```

## Configuration

All configuration is done through `WagonWheelConfig`, which organizes properties into logical groups:

### Boundary Properties

Configure the three circular boundaries:

- `stadiumBoundarySize` - Size of the outermost stadium boundary
- `groundSize` - Size of the ground boundary (defaults to 80% of screen width if not provided)
- `groundBoundaryOvalness` - Oval shape factor (0.0 = circle, 1.0 = highly elliptical)
- `thirtyYardsSize` - Size of the thirty yards boundary
- Colors and borders for each boundary are individually configurable

### Pitch Properties

Customize the central pitch area:

- `pitchColor` - Color of the pitch rectangle
- `pitchBorder` - Border styling
- `showBatsman` - Show/hide batsman icon
- `batsmanIconPath` - Path to your custom SVG icon
- `showLegOffLabels` - Show/hide LEG/OFF labels
- `showCircleIndicator` - Show/hide the circle indicator above pitch
- `batsmanAboveGridLines` - Render batsman above or below sector lines
- `customPitchBuilder` - Complete custom pitch UI builder

### Text Properties

Configure label appearance:

- `textColor` - Color of sector labels
- `baseFontSize` - Base font size for labels
- `textFontWeight` - Font weight
- `textRadiusFactor` - Distance from center (0.0 to 1.0)
- `lineSpacingFactor` - Spacing between multi-line labels

### Marker Properties

Configure the draggable marker:

- `initialPhi` - Initial angle in radians (null = hidden)
- `initialT` - Initial radius (0.0 = center, 1.0 = border)
- `enableMarker` - Enable/disable marker functionality
- `lockToBorder` - Lock marker to border edge
- `markerLineColor`, `markerLineWidth` - Line styling
- `markerCircleColor`, `markerCircleSize` - Circle styling

### Static Markers

Display multiple non-draggable markers:

```dart
staticMarkers: [
  WagonWheelMarkerProperties(
    initialPhi: 0.5,
    initialT: 0.8,
    markerLineColor: Colors.red,
  ),
]
```

### Boundary Line Properties

Configure the sector divider lines:

- `lineColor` - Line color
- `lineOpacity` - Line opacity (0.0 to 1.0)
- `lineWidth` - Line width
- `strokeCap` - Stroke cap style

## Advanced Customization

### Custom Widget Builder

Completely override the widget tree:

```dart
WagonWheelConfig(
  customWidgetBuilder: (context, config, onMarkerPositionChanged) {
    // Your completely custom implementation
    return YourCustomWidget(...);
  },
)
```

### Custom Pitch Builder

Override just the pitch area:

```dart
WagonWheelPitchProperties(
  customPitchBuilder: (pitchSize, groundBoundarySize) {
    // Your custom pitch UI
    return YourCustomPitch(...);
  },
)
```

## Assets

The package includes a default batsman icon that you can use, or you can provide your own custom icon.

### Using the Package-Provided Icon

The package includes a default batsman icon. Simply reference it using the package asset path:

```dart
WagonWheelPitchProperties(
  batsmanIconPath: 'packages/cricket_wagon_wheel/assets/icons/ic_batsman.svg',
)
```

### Using Your Own Custom Icon

To use your own batsman SVG icon, add it to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/icons/ic_batsman.svg
```

Then reference it in the config:

```dart
WagonWheelPitchProperties(
  batsmanIconPath: 'assets/icons/ic_batsman.svg',
)
```

## API Reference

See the [API documentation](https://pub.dev/documentation/cricket_wagon_wheel) for complete API reference.

## License

This package is provided as-is. Please refer to the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
