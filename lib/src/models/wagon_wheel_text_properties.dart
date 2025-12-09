import 'package:flutter/material.dart';

/// Configuration for text labels displayed on the wagon wheel sectors
class WagonWheelTextProperties {
  /// Base font size for labels (can be overridden by size-based calculation)
  final double? baseFontSize;

  /// Color of the text labels
  final Color? textColor;

  /// Font weight of the text labels
  final FontWeight? textFontWeight;

  /// Maximum radius factor (0.0 to 1.0) - controls how close to outer edge labels can be
  final double? textRadiusFactor;

  /// Minimum radius factor (0.0 to 1.0) - ensures labels stay outside inner boundaries
  final double? textMinRadiusFactor;

  /// Spacing between lines when label text is split into multiple lines
  /// Expressed as a factor of baseFontSize (e.g., 0.2 means 20% of font size)
  /// Default: 0.2
  final double? lineSpacingFactor;

  const WagonWheelTextProperties({
    this.baseFontSize,
    this.textColor,
    this.textFontWeight,
    this.textRadiusFactor,
    this.textMinRadiusFactor,
    this.lineSpacingFactor,
  });
}
