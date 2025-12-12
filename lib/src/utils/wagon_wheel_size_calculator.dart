import 'package:flutter/material.dart';

/// Utility class for calculating circle and boundary sizes
///
/// Provides methods to transform base sizes into different shapes:
/// - Capsule: Horizontally compressed circles
/// - Oval: Elliptical shapes with configurable aspect ratio
class WagonWheelSizeCalculator {
  /// Calculate capsule-shaped circle size.
  ///
  /// Creates a horizontally compressed circle (capsule shape).
  /// Used for the thirty yards boundary.
  ///
  /// **Parameters:**
  /// - [capsule] - Compression factor (0.0 to 1.0)
  ///   - 0.0 = perfect circle (no compression, width = height)
  ///   - 1.0 = maximum compression (nearly flat, width ≈ 0)
  /// - [size] - Base diameter size (height of the capsule)
  ///
  /// **Returns:** Size with width compressed based on capsule factor
  ///
  /// **Formula:** width = size * (1 - capsule)
  /// - capsule = 0.0 → width = size (circle)
  /// - capsule = 0.5 → width = size * 0.5 (moderate compression)
  /// - capsule = 1.0 → width ≈ 0 (maximum compression)
  static Size calculateCapsuleCircleSize({
    required double capsule,
    required double size,
  }) {
    double adjustedCapsule = capsule;
    // Clamp to valid range [0.0, 1.0)
    if (adjustedCapsule >= 1) {
      adjustedCapsule = 0.99; // Prevent width from becoming zero
    } else if (adjustedCapsule < 0) {
      adjustedCapsule = 0.0; // No compression (perfect circle)
    }

    // Calculate compressed width: size * (1 - compression_factor)
    return Size(size - (size * adjustedCapsule), size);
  }

  /// Calculate oval-shaped circle size.
  ///
  /// Creates an elliptical shape with configurable aspect ratio.
  /// Used for stadium and ground boundaries.
  ///
  /// **Parameters:**
  /// - [oval] - Oval factor (0.0 to 1.0)
  ///   - 0.0 = perfect circle (width = height)
  ///   - 1.0 = maximum oval (highly elliptical, width << height)
  /// - [size] - Base diameter size (height of the ellipse)
  ///
  /// **Returns:** Size with width compressed based on oval factor
  ///
  /// **Note:** The oval factor is inverted internally (1 - oval) so that:
  /// - oval = 0.0 → width = size (circle)
  /// - oval = 1.0 → width ≈ 0 (highly compressed)
  static Size calculateOvalCircleSize({
    required double oval,
    required double size,
  }) {
    double adjustedOval = oval;
    // Clamp to valid range [0.0, 1.0)
    if (adjustedOval >= 1) {
      adjustedOval = 0.99; // Prevent division by zero
    } else if (adjustedOval <= 0) {
      adjustedOval = 0.0; // Perfect circle
    } else {
      // Invert: higher oval factor = more compression
      // oval = 0.0 → adjustedOval = 1.0 (no compression)
      // oval = 0.5 → adjustedOval = 0.5 (moderate compression)
      // oval = 1.0 → adjustedOval = 0.0 (maximum compression)
      adjustedOval = 1 - adjustedOval;
    }
    return Size(size * adjustedOval, size);
  }
}
