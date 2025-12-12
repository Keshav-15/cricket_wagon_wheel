import 'package:flutter/material.dart';

/// Configuration for the ground boundary (middle boundary)
class WagonWheelGroundBoundaryProperties {
  /// Size of the ground boundary
  /// If null, defaults to 80% of screen width
  final double? size;

  /// Oval shape factor (0.0 = circle, 1.0 = highly elliptical)
  final double ovalness;

  /// Color of the ground boundary
  final Color? color;

  /// Border styling for the ground boundary
  final Border? border;

  const WagonWheelGroundBoundaryProperties({
    this.size,
    this.ovalness = 0.0,
    this.color,
    this.border,
  });
}
