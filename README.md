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
  boundary: WagonWheelBoundaryProperties(
    ground: WagonWheelGroundBoundaryProperties(size: 300),
    stadium: WagonWheelStadiumBoundaryProperties(size: 20),
  ),
  pitch: WagonWheelPitchProperties(
    batsman: WagonWheelBatsmanProperties(show: true),
  ),
  onMarkerPositionChanged: (phi, t, label) {
    print('Marker position: phi=$phi, t=$t, sector: ${label.name}');
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
  marker: WagonWheelMarkerProperties(
    enableMarker: true,
    initialPhi: 0.92,  // Angle in radians
    initialT: 0.6,     // 60% from center
  ),
  onMarkerPositionChanged: (phi, t, label) {
    print('Marker moved: phi=$phi, t=$t, sector: ${label.name}');
  },
)
```

### With Bottom Sheet for Shot Selection

The package includes a built-in bottom sheet for shot selection with pre-configured shot options for each sector:

```dart
WagonWheel(
  marker: WagonWheelMarkerProperties(enableMarker: true),
  onMarkerPositionChanged: (phi, t, label) {
    // Get default shot options for this sector
    final shotOptions = WagonWheelShotOptionsProvider.getShotOptionsForLabel(label);
    
    WagonWheelBottomSheet.show(
      context: context,
      config: WagonWheelBottomSheetConfig(
        title: 'Select Shot Type (${label.name})',
        shotOptions: shotOptions,
        onShotSelected: (selectedOption) async {
          print('Selected: ${selectedOption.name} (${selectedOption.id})');
          // Handle shot selection
        },
      ),
    );
  },
)
```

### Complete Customization Example

```dart
WagonWheel(
  isLeftHanded: false,
  boundary: WagonWheelBoundaryProperties(
    ground: WagonWheelGroundBoundaryProperties(
      size: 300,
      ovalness: 0.1,
      color: Colors.amber,
      border: Border.all(color: Colors.white, width: 2),
    ),
    stadium: WagonWheelStadiumBoundaryProperties(
      size: 20,
      color: Colors.green,
      border: Border.all(color: Colors.black, width: 3),
    ),
    thirtyYards: WagonWheelThirtyYardsBoundaryProperties(
      color: Colors.blue,
      border: Border.all(color: Colors.white),
    ),
  ),
  pitch: WagonWheelPitchProperties(
    pitchConfig: WagonWheelPitchRectangleProperties(
      color: Colors.brown,
      border: Border.all(color: Colors.black, width: 2),
    ),
    batsman: WagonWheelBatsmanProperties(
      show: true,
      iconPath: 'assets/icons/ic_batsman.svg',
    ),
    legOffLabel: WagonWheelLegOffLabelProperties(
      show: true,
      legText: 'LEG',
      offText: 'OFF',
    ),
    circleIndicator: WagonWheelCircleIndicatorProperties(
      show: true,
      color: Colors.green,
    ),
  ),
  label: WagonWheelLabelConfig(
    properties: WagonWheelTextProperties(
      textColor: Colors.white,
      baseFontSize: 14,
      textFontWeight: FontWeight.bold,
    ),
  ),
  sector: WagonWheelSectorConfig(
    boundaryLines: WagonWheelBoundaryLineProperties(
      lineColor: Colors.white,
      lineOpacity: 0.4,
      lineWidth: 1.5,
    ),
  ),
  marker: WagonWheelMarkerProperties(
    enableMarker: true,
    initialPhi: 0.5,
    initialT: 0.8,
    markerLineColor: Colors.red,
    markerCircleColor: Colors.red,
    markerCircleSize: 6.0,
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
  onMarkerPositionChanged: (phi, t, label) {
    // Handle marker position changes
    print('Sector: ${label.name} (${label.id})');
  },
)
```

## Shot Options Provider

The package includes `WagonWheelShotOptionsProvider` which provides pre-built shot options for each sector label. This makes it easy to show relevant shot options based on the selected sector.

### Using Default Shot Options

```dart
// Get default shot options for a sector label
final shotOptions = WagonWheelShotOptionsProvider.getShotOptionsForLabel(label);

WagonWheelBottomSheet.show(
  context: context,
  config: WagonWheelBottomSheetConfig(
    shotOptions: shotOptions,
    onShotSelected: (option) async {
      // Handle selection
    },
  ),
);
```

### Overriding with Custom Options

```dart
// Completely replace defaults with custom options
final customOptions = [
  WagonWheelShotOption(id: 'custom1', name: 'Custom Shot 1'),
  WagonWheelShotOption(id: 'custom2', name: 'Custom Shot 2'),
];

final shotOptions = WagonWheelShotOptionsProvider.getShotOptionsForLabel(
  label,
  customOptions: customOptions,
);
```

### Merging Defaults with Custom Options

```dart
// Append custom options to defaults
final merged = WagonWheelShotOptionsProvider.mergeShotOptions(
  label,
  customOptions: [
    WagonWheelShotOption(id: 'extra', name: 'Extra Shot'),
  ],
);

// Or replace defaults when IDs match
final merged = WagonWheelShotOptionsProvider.mergeShotOptions(
  label,
  customOptions: [
    WagonWheelShotOption(id: 'defence', name: 'Custom Defence'),
  ],
  preferCustom: true, // Replace default 'defence' with custom
);
```

### Validating Shot Options

```dart
final shotOptions = WagonWheelShotOptionsProvider.getShotOptionsForLabel(label);

// Check for duplicate IDs
final duplicates = WagonWheelShotOptionsProvider.validateUniqueIds(shotOptions);
if (duplicates.isNotEmpty) {
  print('Warning: Duplicate IDs found: $duplicates');
}
```

## Configuration

All configuration is done through properties directly on the `WagonWheel` widget, organized into logical groups:

### Boundary Properties

Configure the three circular boundaries using `WagonWheelBoundaryProperties`:

- `stadium` - `WagonWheelStadiumBoundaryProperties` - Outermost stadium boundary
- `ground` - `WagonWheelGroundBoundaryProperties` - Ground boundary (defaults to 80% of screen width)
- `thirtyYards` - `WagonWheelThirtyYardsBoundaryProperties` - Thirty yards boundary
- `pitch` - `WagonWheelPitchProperties` - Central pitch area

Each boundary has configurable size, color, border, and shape properties.

### Pitch Properties

Customize the central pitch area using `WagonWheelPitchProperties`:

- `pitchConfig` - `WagonWheelPitchRectangleProperties` - Pitch rectangle styling
- `batsman` - `WagonWheelBatsmanProperties` - Batsman icon configuration
- `legOffLabel` - `WagonWheelLegOffLabelProperties` - LEG/OFF label configuration
- `circleIndicator` - `WagonWheelCircleIndicatorProperties` - Circle indicator configuration

### Label Properties

Configure label appearance using `WagonWheelLabelConfig`:

- `properties` - `WagonWheelTextProperties` - Text styling (color, font size, weight, etc.)
- `labels` - `List<WagonWheelSectorLabel>?` - Custom sector labels (optional)
- `labelsAboveMarker` - Whether labels render above the marker

### Marker Properties

Configure the draggable marker using `WagonWheelMarkerProperties`:

- `enableMarker` - Enable/disable marker functionality
- `initialPhi` - Initial angle in radians (null = hidden)
- `initialT` - Initial radius (0.0 = center, 1.0 = border)
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
    markerCircleColor: Colors.red,
  ),
]
```

### Sector Configuration

Configure sectors using `WagonWheelSectorConfig`:

- `numberOfSectors` - Number of sectors (default: 8)
- `baseStartAngle` - Starting angle for first sector (default: -3π/4)
- `boundaryLines` - `WagonWheelBoundaryLineProperties` - Sector divider line styling
  - `lineColor` - Line color
  - `lineOpacity` - Line opacity (0.0 to 1.0)
  - `lineWidth` - Line width
  - `strokeCap` - Stroke cap style

## Bottom Sheet for Shot Selection

The package includes a customizable bottom sheet for shot selection with animated shimmer borders.

### Basic Bottom Sheet Usage

```dart
WagonWheelBottomSheet.show(
  context: context,
  config: WagonWheelBottomSheetConfig(
    title: 'Select Shot Type',
    shotOptions: [
      WagonWheelShotOption(id: 'flick', name: 'Flick'),
      WagonWheelShotOption(id: 'pull', name: 'Pull'),
      // ... more options
    ],
    onShotSelected: (selectedOption) async {
      print('Selected: ${selectedOption.name}');
      // Modal closes automatically after callback completes
    },
  ),
);
```

### Using with Shot Options Provider

```dart
WagonWheel(
  marker: WagonWheelMarkerProperties(enableMarker: true),
  onMarkerPositionChanged: (phi, t, label) {
    // Get default shot options for this sector
    final shotOptions = WagonWheelShotOptionsProvider.getShotOptionsForLabel(label);
    
    WagonWheelBottomSheet.show(
      context: context,
      config: WagonWheelBottomSheetConfig(
        title: 'Select Shot Type (${label.name})',
        shotOptions: shotOptions,
        onShotSelected: (option) async {
          // Handle selection - modal closes automatically
        },
      ),
    );
  },
)
```

### Customizing Bottom Sheet

The bottom sheet is highly customizable:

```dart
WagonWheelBottomSheet.show(
  context: context,
  config: WagonWheelBottomSheetConfig(
    title: 'Custom Title',
    shotOptions: shotOptions,
    isDismissible: true, // Allow tap outside to dismiss
    showNoneOption: true, // Show "None Of The Above" button
    layoutConfig: WagonWheelBottomSheetLayoutConfig(
      crossAxisCount: 3, // 3 columns instead of 2
      initialChildSize: 0.5, // Start at 50% height
    ),
    cardConfig: WagonWheelBottomSheetCardConfig(
      layoutDirection: WagonWheelCardLayoutDirection.vertical, // Image above text
    ),
    borderConfig: WagonWheelBottomSheetBorderConfig(
      shimmerColors: [Colors.blue, Colors.purple, Colors.blue],
      animationDuration: Duration(milliseconds: 800),
    ),
    imageConfig: WagonWheelBottomSheetImageConfig(
      width: 50,
      height: 50,
    ),
    textConfig: WagonWheelBottomSheetTextConfig(
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
);
```

## Advanced Customization

### Custom Widget Builder

Completely override the widget tree:

```dart
WagonWheel(
  customWidgetBuilder: (context, onMarkerPositionChanged) {
    // Your completely custom implementation
    return YourCustomWidget(...);
  },
)
```

## Sector Labels

The package uses `WagonWheelSectorLabel` objects with `id` and `name` properties for better type safety and easier comparisons.

### Default Labels

Default labels are provided via `WagonWheelConstants.getLabels()`:

```dart
final labels = WagonWheelConstants.getLabels(isLeftHanded: false);
// Returns: [Third Man, Deep Fine Leg, Deep Square Leg, ...]
```

### Custom Labels

Provide custom labels:

```dart
WagonWheel(
  label: WagonWheelLabelConfig(
    labels: [
      WagonWheelSectorLabel(id: 'custom_1', name: 'Custom Sector 1'),
      WagonWheelSectorLabel(id: 'custom_2', name: 'Custom Sector 2'),
      // ...
    ],
  ),
)
```

### Using Labels in Callbacks

The `onMarkerPositionChanged` callback provides the sector label:

```dart
WagonWheel(
  onMarkerPositionChanged: (phi, t, label) {
    // Use label.id for comparisons
    if (label.id == 'deep_mid_wicket') {
      // Handle specific sector
    }
    
    // Use label.name for display
    print('Current sector: ${label.name}');
  },
)
```

## Assets

The package includes a default batsman icon that you can use, or you can provide your own custom icon.

### Using the Package-Provided Icon

The package includes a default batsman icon. It's used automatically if no custom path is provided.

### Using Your Own Custom Icon

To use your own batsman SVG icon, add it to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/icons/ic_batsman.svg
```

Then reference it in the config:

```dart
WagonWheel(
  pitch: WagonWheelPitchProperties(
    batsman: WagonWheelBatsmanProperties(
      iconPath: 'assets/icons/ic_batsman.svg',
    ),
  ),
)
```

## API Reference

See the [API documentation](https://pub.dev/documentation/cricket_wagon_wheel) for complete API reference.

## License

This package is provided as-is. Please refer to the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
