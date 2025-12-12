## 1.0.0-beta.2

- **Bottom Sheet for Shot Selection**: Added customizable bottom sheet with animated shimmer borders
  - Pre-built shot options provider (`WagonWheelShotOptionsProvider`) with default shots for each sector
  - Support for custom shot options, merging defaults with custom options
  - Animated shimmer border effect on shot selection
  - Fully customizable layout, styling, and behavior
- **Enhanced Sector Labels**: Replaced `List<String>` with `WagonWheelSectorLabel` class
  - Type-safe sector identification with `id` and `name` properties
  - Improved `onMarkerPositionChanged` callback now includes sector label
- **Code Quality Improvements**:
  - Enhanced documentation across all public APIs
  - Extracted magic numbers to named constants for better maintainability
  - Improved code comments and algorithm explanations
  - Zero lint errors and warnings

## 1.0.0-beta.1

- Beta release of cricket_wagon_wheel package
- Interactive draggable marker with position callbacks
- Static markers support for historical shot placements
- Fully configurable boundaries, pitch, text, and animations
- Left/right handed batsman support with automatic label mirroring
- Custom widget builders for complete UI customization
- Comprehensive property organization through configuration classes

## 1.0.0 (Coming Soon)

- Official stable release
- Interactive draggable marker with position callbacks
- Static markers support for historical shot placements
- Fully configurable boundaries, pitch, text, and animations
- Left/right handed batsman support with automatic label mirroring
- Custom widget builders for complete UI customization
- Comprehensive property organization through configuration classes
