import 'package:flutter/material.dart';

/// Configuration for border animation customization in the bottom sheet
class WagonWheelBottomSheetBorderConfig {
  /// Duration of the border animation
  /// Default: 600ms
  final Duration? animationDuration;

  /// Base color for the border (used if shimmerColors is null)
  final Color? borderColor;

  /// Width of the animated border
  /// Default: 2.5
  final double? borderWidth;

  /// Colors for the shimmer effect
  /// If provided, creates a gradient shimmer effect
  /// If null, uses solid borderColor
  /// Default: [Colors.teal, Colors.green, Colors.teal]
  final List<Color>? shimmerColors;

  /// Animation curve for the border animation
  /// Default: Curves.easeInOut
  final Curve? animationCurve;

  const WagonWheelBottomSheetBorderConfig({
    this.animationDuration,
    this.borderColor,
    this.borderWidth,
    this.shimmerColors,
    this.animationCurve,
  });
}
