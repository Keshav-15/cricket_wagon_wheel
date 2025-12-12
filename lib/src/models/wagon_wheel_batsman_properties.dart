import 'package:cricket_wagon_wheel/src/utils/package_constants.dart';
import 'package:flutter/material.dart';

/// Configuration for the batsman icon/widget
class WagonWheelBatsmanProperties {
  /// Whether to show the batsman icon on the pitch
  final bool show;

  /// Path to the batsman icon asset. If null, uses default package icon
  final String? iconPath;

  /// Size of the batsman icon
  final Size? iconSize;

  /// Color filter for the batsman icon (optional)
  final ColorFilter? iconColorFilter;

  /// Whether batsman should be rendered above the grid lines (sector lines)
  /// If true, batsman will be rendered after grid lines (on top)
  /// If false, batsman will be rendered before grid lines (below)
  final bool aboveGridLines;

  /// Vertical offset for the batsman icon position
  /// Positive values move icon down, negative values move icon up
  /// Default: null (uses default positioning slightly above center)
  /// Useful for fine-tuning batsman position within the pitch
  final double? verticalOffset;

  const WagonWheelBatsmanProperties({
    this.show = true,
    this.iconPath,
    this.iconSize,
    this.iconColorFilter,
    this.aboveGridLines = false,
    this.verticalOffset,
  });

  /// Get effective icon path with default fallback
  String get effectiveIconPath =>
      iconPath ?? WagonWheelPackageConstants.defaultBatsmanIconPath;
}
