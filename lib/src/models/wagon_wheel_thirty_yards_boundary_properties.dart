import 'package:flutter/material.dart';

/// Configuration for the thirty yards boundary (innermost boundary)
class WagonWheelThirtyYardsBoundaryProperties {
  /// Size of the thirty yards boundary
  /// If null, defaults to 45% of ground boundary size
  final double? size;

  /// Capsule shape factor for the thirty yards boundary
  final double capsulness;

  /// Color of the thirty yards boundary
  final Color? color;

  /// Border styling for the thirty yards boundary
  final Border? border;

  const WagonWheelThirtyYardsBoundaryProperties({
    this.size,
    this.capsulness = 0.25,
    this.color,
    this.border,
  });
}
