import 'package:flutter/material.dart';

/// Configuration for boundary lines (sector lines) in the wagon wheel
/// These are the radial lines that divide the circle into sectors
class WagonWheelBoundaryLineProperties {
  /// Color of the sector lines (radial lines from center)
  /// Default: white with 40% opacity
  final Color? lineColor;

  /// Opacity of the sector lines (0.0 to 1.0)
  /// Only used if lineColor doesn't already have opacity
  /// Default: 0.4
  final double? lineOpacity;

  /// Width of the sector lines
  /// Default: 1.2
  final double? lineWidth;

  /// Stroke cap style for the lines
  /// Default: StrokeCap.round
  final StrokeCap? strokeCap;

  const WagonWheelBoundaryLineProperties({
    this.lineColor,
    this.lineOpacity,
    this.lineWidth,
    this.strokeCap,
  });

  /// Get effective line color with opacity
  Color getEffectiveLineColor() {
    final baseColor = lineColor ?? Colors.white;
    final opacity = lineOpacity ?? 0.4;
    return baseColor.withValues(alpha: opacity);
  }

  /// Get effective line width
  double getEffectiveLineWidth() => lineWidth ?? 1.2;

  /// Get effective stroke cap
  StrokeCap getEffectiveStrokeCap() => strokeCap ?? StrokeCap.round;
}
