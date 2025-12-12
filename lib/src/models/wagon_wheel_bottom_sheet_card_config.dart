import 'package:flutter/material.dart';

/// Layout direction for shot option cards
enum WagonWheelCardLayoutDirection {
  /// Image and text arranged horizontally (Row)
  horizontal,

  /// Image and text arranged vertically (Column)
  vertical,
}

/// Configuration for card customization in the bottom sheet
class WagonWheelBottomSheetCardConfig {
  /// Padding inside each shot option card
  final EdgeInsets? padding;

  /// Margin around each shot option card
  final EdgeInsets? margin;

  /// Background color of the shot option cards
  final Color? backgroundColor;

  /// Border radius of the shot option cards
  final BorderRadius? borderRadius;

  /// Spacing between image and text in each card
  final double? spacing;

  /// Border color for cards (when not animated)
  final Color? borderColor;

  /// Border width for cards (when not animated)
  final double? borderWidth;

  /// Layout direction for image and text
  /// Default: horizontal (Row)
  final WagonWheelCardLayoutDirection layoutDirection;

  const WagonWheelBottomSheetCardConfig({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.spacing,
    this.borderColor,
    this.borderWidth,
    this.layoutDirection = WagonWheelCardLayoutDirection.horizontal,
  });
}
