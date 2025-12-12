import 'package:flutter/material.dart';

/// Configuration for text customization in the bottom sheet
class WagonWheelBottomSheetTextConfig {
  /// Text style for the bottom sheet title
  final TextStyle? titleStyle;

  /// Text style for shot option names
  final TextStyle? shotNameStyle;

  /// Text style for "None Of The Above" button
  final TextStyle? noneButtonStyle;

  const WagonWheelBottomSheetTextConfig({
    this.titleStyle,
    this.shotNameStyle,
    this.noneButtonStyle,
  });
}
