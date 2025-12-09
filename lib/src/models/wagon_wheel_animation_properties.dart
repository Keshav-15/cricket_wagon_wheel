import 'package:flutter/material.dart';

/// Configuration for splash animation when a marker is dropped
class WagonWheelAnimationProperties {
  /// Duration of the splash animation
  final Duration? splashAnimationDuration;

  /// Color of the splash/ripple effect
  final Color? splashColor;

  /// Maximum radius factor (0.0 to 1.0) for splash expansion
  final double? splashMaxRadius;

  /// Animation curve for the splash effect
  final Curve? splashAnimationCurve;

  /// Maximum opacity of the splash effect (0.0 to 1.0)
  final double? splashOpacity;

  /// Background color for the selected sector
  final Color? selectedSectorBackgroundColor;

  /// Background opacity for the selected sector (0.0 to 1.0)
  final double? selectedSectorBackgroundOpacity;

  const WagonWheelAnimationProperties({
    this.splashAnimationDuration,
    this.splashColor,
    this.splashMaxRadius,
    this.splashAnimationCurve,
    this.splashOpacity,
    this.selectedSectorBackgroundColor,
    this.selectedSectorBackgroundOpacity,
  });
}
