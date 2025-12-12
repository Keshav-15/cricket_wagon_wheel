import 'package:flutter/material.dart';

/// Configuration for the pitch rectangle itself
class WagonWheelPitchRectangleProperties {
  /// Size of the pitch. If null, will be calculated based on thirtyYardsBoundary.
  /// You can provide explicit size or use `sizeWidthFactor` and `sizeHeightFactor` for relative sizing.
  final Size? size;

  /// Factor to calculate pitch width relative to thirty yards boundary.
  /// Defaults to 0.5 if size is not provided.
  final double? sizeWidthFactor;

  /// Factor to calculate pitch height relative to thirty yards boundary.
  /// Defaults to 1.0 if size is not provided.
  final double? sizeHeightFactor;

  /// Border spacing around the pitch. If null, will be calculated as 10% of pitch height.
  /// You can provide explicit spacing or use `borderSpacingFactor` for relative spacing.
  final double? borderSpacing;

  /// Factor to calculate border spacing relative to pitch height.
  /// Defaults to 0.1 if borderSpacing is not provided.
  final double? borderSpacingFactor;

  /// Color of the pitch rectangle
  final Color? color;

  /// Border styling for the pitch rectangle
  final Border? border;

  /// Custom pitch widget builder. If provided, this will be used instead of default pitch UI
  /// This allows complete customization of the pitch appearance
  /// Parameters: pitchSize, groundBoundarySize (for text sizing)
  final Widget Function(Size pitchSize, Size groundBoundarySize)? customBuilder;

  const WagonWheelPitchRectangleProperties({
    this.size,
    this.sizeWidthFactor,
    this.sizeHeightFactor,
    this.borderSpacing,
    this.borderSpacingFactor,
    this.color,
    this.border,
    this.customBuilder,
  });

  /// Calculate pitch size based on thirty yards boundary if not explicitly provided
  Size calculateSize(double thirtyYardsBoundary) {
    if (size != null) {
      return size!;
    }

    final basePitchSize = thirtyYardsBoundary * 0.4;
    final widthFactor = sizeWidthFactor ?? 0.5;
    final heightFactor = sizeHeightFactor ?? 1.0;

    return Size(basePitchSize * widthFactor, basePitchSize * heightFactor);
  }

  /// Calculate border spacing based on pitch height if not explicitly provided
  double calculateBorderSpacing(Size pitchSize) {
    if (borderSpacing != null) {
      return borderSpacing!;
    }

    final spacingFactor = borderSpacingFactor ?? 0.1;
    return pitchSize.height * spacingFactor;
  }
}
