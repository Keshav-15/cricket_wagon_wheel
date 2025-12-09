import 'package:cricket_wagon_wheel/src/utils/package_constants.dart';
import 'package:flutter/material.dart';

/// Configuration for the circle indicator above the pitch
class WagonWheelCircleIndicatorProperties {
  /// Whether to show the circle indicator above the pitch
  final bool show;

  /// Color of the circle indicator
  final Color? color;

  /// Size of the circle indicator (width and height)
  final Size? size;

  /// Spacing between circle indicator and pitch rectangle
  /// If null, will use the pitch border spacing
  final double? spacing;

  const WagonWheelCircleIndicatorProperties({
    this.show = true,
    this.color,
    this.size,
    this.spacing,
  });

  /// Get effective color with default fallback
  Color get effectiveColor =>
      color ?? WagonWheelPackageConstants.defaultWhatsAppColor;

  /// Get effective size with default fallback
  Size get effectiveSize => size ?? const Size(8, 8);
}

