import 'package:flutter/material.dart';

/// Utility class for calculating circle and boundary sizes
///
/// Provides methods to transform base sizes into different shapes:
/// - Capsule: Horizontally compressed circles
/// - Oval: Elliptical shapes with configurable aspect ratio
class WagonWheelSizeCalculator {
  /// Calculate capsule-shaped circle size
  ///
  /// Creates a horizontally compressed circle (capsule shape).
  /// Used for the thirty yards boundary.
  ///
  /// **Parameters:**
  /// - [capsule] - Compression factor (0.0 to 1.0)
  ///   - 0.0 = perfect circle (no compression)
  ///   - 1.0 = maximum compression (nearly flat)
  /// - [size] - Base diameter size
  ///
  /// **Returns:** Size with width compressed based on capsule factor
  static Size calculateCapsuleCircleSize({
    required double capsule,
    required double size,
  }) {
    double adjustedCapsule = capsule;
    if (adjustedCapsule >= 1) {
      adjustedCapsule = 0.99;
    } else if (adjustedCapsule < 0) {
      adjustedCapsule = 0.0;
    }

    return Size(size - (size * adjustedCapsule), size);
  }

  /// Calculate oval-shaped circle size
  ///
  /// Creates an elliptical shape with configurable aspect ratio.
  /// Used for stadium and ground boundaries.
  ///
  /// **Parameters:**
  /// - [oval] - Oval factor (0.0 to 1.0)
  ///   - 0.0 = perfect circle
  ///   - 1.0 = maximum oval (highly elliptical)
  /// - [size] - Base diameter size
  ///
  /// **Returns:** Size with width adjusted based on oval factor
  static Size calculateOvalCircleSize({
    required double oval,
    required double size,
  }) {
    double adjustedOval = oval;
    if (adjustedOval >= 1) {
      adjustedOval = 0.01;
    } else if (adjustedOval <= 0) {
      adjustedOval = 1;
    } else {
      adjustedOval = 1 - adjustedOval;
    }
    return Size(size * adjustedOval, size);
  }
}
