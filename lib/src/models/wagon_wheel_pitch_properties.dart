import 'package:cricket_wagon_wheel/src/utils/package_constants.dart';
import 'package:flutter/material.dart';

/// Configuration for the pitch at the center of the wagon wheel
class WagonWheelPitchProperties {
  /// Size of the pitch. If null, will be calculated based on thirtyYardsBoundary.
  /// You can provide explicit size or use `pitchSizeFactor` for relative sizing.
  final Size? pitchSize;

  /// Factor to calculate pitch size relative to thirty yards boundary.
  /// Defaults to 0.25 for width and 1.0 for height if pitchSize is not provided.
  final double? pitchSizeWidthFactor;
  final double? pitchSizeHeightFactor;

  /// Border spacing around the pitch. If null, will be calculated as 10% of pitch height.
  /// You can provide explicit spacing or use `pitchBorderSpacingFactor` for relative spacing.
  final double? pitchBorderSpacing;

  /// Factor to calculate border spacing relative to pitch height.
  /// Defaults to 0.1 if pitchBorderSpacing is not provided.
  final double? pitchBorderSpacingFactor;

  final Color? pitchColor;
  final Border? pitchBorder;

  /// Whether to show the batsman icon on the pitch
  final bool showBatsman;

  /// Path to the batsman icon asset. If null, user must provide their own
  final String? batsmanIconPath;

  /// Size of the batsman icon
  final Size? batsmanIconSize;

  /// Color filter for the batsman icon (optional)
  final ColorFilter? batsmanIconColorFilter;

  /// Whether to show LEG and OFF labels
  final bool showLegOffLabels;

  /// Text for the leg side label (left side)
  final String? legLabelText;

  /// Text for the off side label (right side)
  final String? offLabelText;

  /// Color of LEG/OFF labels
  final Color? legOffLabelColor;

  /// Font size of LEG/OFF labels
  final double? legOffLabelFontSize;

  /// Font weight of LEG/OFF labels
  final FontWeight? legOffLabelFontWeight;

  /// Whether to show the circle indicator above the pitch
  final bool showCircleIndicator;

  /// Color of the circle indicator above the pitch
  final Color? circleIndicatorColor;

  /// Size of the circle indicator (width and height)
  final Size? circleIndicatorSize;

  /// Spacing between circle indicator and pitch rectangle
  final double? circleIndicatorSpacing;

  /// Whether batsman should be rendered above the grid lines (sector lines)
  /// If true, batsman will be rendered after grid lines (on top)
  /// If false, batsman will be rendered before grid lines (below)
  final bool batsmanAboveGridLines;

  /// Vertical offset for the batsman icon position
  /// Positive values move icon down, negative values move icon up
  /// Default: null (uses default positioning slightly above center)
  /// Useful for fine-tuning batsman position within the pitch
  final double? iconVerticalOffset;

  /// Custom pitch widget builder. If provided, this will be used instead of default pitch UI
  /// This allows complete customization of the pitch appearance
  /// Parameters: pitchSize, groundBoundarySize (for text sizing)
  final Widget Function(Size pitchSize, Size groundBoundarySize)?
      customPitchBuilder;

  const WagonWheelPitchProperties({
    this.pitchSize,
    this.pitchSizeWidthFactor,
    this.pitchSizeHeightFactor,
    this.pitchBorderSpacing,
    this.pitchBorderSpacingFactor,
    this.pitchColor,
    this.pitchBorder,
    this.showBatsman = true,
    this.batsmanIconPath = WagonWheelPackageConstants.defaultBatsmanIconPath,
    this.batsmanIconSize,
    this.batsmanIconColorFilter,
    this.showLegOffLabels = true,
    this.legLabelText,
    this.offLabelText,
    this.legOffLabelColor,
    this.legOffLabelFontSize,
    this.legOffLabelFontWeight,
    this.showCircleIndicator = true,
    this.circleIndicatorColor,
    this.circleIndicatorSize,
    this.circleIndicatorSpacing,
    this.batsmanAboveGridLines = false,
    this.customPitchBuilder,
    this.iconVerticalOffset,
  });

  /// Calculate pitch size based on thirty yards boundary if not explicitly provided
  Size calculatePitchSize(double thirtyYardsBoundary) {
    if (pitchSize != null) {
      return pitchSize!;
    }

    final basePitchSize =
        thirtyYardsBoundary * 0.4; // Increased from 0.4 for better visibility
    final widthFactor = pitchSizeWidthFactor ?? 0.5; // Increased from 0.4
    final heightFactor = pitchSizeHeightFactor ?? 1.0;

    return Size(basePitchSize * widthFactor, basePitchSize * heightFactor);
  }

  /// Calculate border spacing based on pitch height if not explicitly provided
  double calculateBorderSpacing(Size pitchSize) {
    if (pitchBorderSpacing != null) {
      return pitchBorderSpacing!;
    }

    final spacingFactor = pitchBorderSpacingFactor ?? 0.1;
    return pitchSize.height * spacingFactor;
  }
}
