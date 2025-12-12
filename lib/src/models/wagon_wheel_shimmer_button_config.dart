import 'package:flutter/material.dart';

/// Configuration for the shimmer border button widget
class WagonWheelShimmerButtonConfig {
  /// Width of the button
  /// If null, button will expand to fill available width
  final double? width;

  /// Height of the button
  /// If null, button will size based on padding and content
  final double? height;

  /// Background color of the button
  final Color? backgroundColor;

  /// Padding inside the button
  final EdgeInsets? padding;

  /// Margin around the button
  final EdgeInsets? margin;

  /// Border radius of the button
  final BorderRadius? borderRadius;

  /// Text style for the button text
  final TextStyle? textStyle;

  /// Border color when not animating
  final Color? staticBorderColor;

  /// Border width when not animating
  final double? staticBorderWidth;

  const WagonWheelShimmerButtonConfig({
    this.width,
    this.height,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.textStyle,
    this.staticBorderColor,
    this.staticBorderWidth,
  });
}
