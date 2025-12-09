import 'package:flutter/material.dart';

/// Configuration for LEG/OFF labels positioned on the sides of the pitch
class WagonWheelLegOffLabelProperties {
  /// Whether to show LEG and OFF labels
  final bool show;

  /// Text for the leg side label (left side)
  final String? legText;

  /// Text for the off side label (right side)
  final String? offText;

  /// Color of LEG/OFF labels
  final Color? color;

  /// Font size of LEG/OFF labels
  final double? fontSize;

  /// Font weight of LEG/OFF labels
  final FontWeight? fontWeight;

  const WagonWheelLegOffLabelProperties({
    this.show = true,
    this.legText,
    this.offText,
    this.color,
    this.fontSize,
    this.fontWeight,
  });
}

