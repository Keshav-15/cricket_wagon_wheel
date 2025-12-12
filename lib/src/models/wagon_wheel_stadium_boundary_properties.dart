import 'package:flutter/material.dart';

/// Configuration for the stadium boundary (outermost boundary)
class WagonWheelStadiumBoundaryProperties {
  /// Size of the stadium boundary (additional size beyond ground boundary)
  final double size;

  /// Color of the stadium boundary
  final Color? color;

  /// Border styling for the stadium boundary
  final Border? border;

  const WagonWheelStadiumBoundaryProperties({
    this.size = 0.0,
    this.color,
    this.border,
  });
}
