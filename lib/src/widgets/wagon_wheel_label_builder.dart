import 'package:flutter/material.dart';

/// Builder for LEG/OFF labels on the pitch
///
/// Handles positioning of LEG and OFF labels outside the pitch rectangle.
/// Labels are positioned on the sides and swap positions based on batsman handedness.
class WagonWheelLabelBuilder {
  /// Build LEG/OFF labels positioned outside the pitch on left and right sides
  ///
  /// **Positioning Logic:**
  /// - For right-handed batsman: LEG on left side, OFF on right side
  /// - For left-handed batsman: LEG on right side, OFF on left side (mirrored)
  /// - Labels are positioned outside the pitch rectangle boundaries
  /// - Vertically aligned slightly above the horizontal center line
  ///
  /// **Text Sizing:**
  /// Uses the same calculation as partition painter: `averageRadius / 11`
  /// This ensures consistent text sizing across the entire wagon wheel.
  static Widget? buildLegOffLabels({
    required Size pitchSize,
    required Size groundBoundarySize,
    String? legText,
    String? offText,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    required bool isLeftHanded,
    bool showLabels = true,
  }) {
    // Early return if labels should not be shown
    if (!showLabels) {
      return null;
    }

    final legLabel = legText ?? 'LEG';
    final offLabel = offText ?? 'OFF';
    final labelColor = color ?? Colors.white;
    final labelFontWeight = fontWeight ?? FontWeight.bold;

    // Use same text sizing logic as partition painter
    final radiusX = groundBoundarySize.width / 2;
    final radiusY = groundBoundarySize.height / 2;
    final averageRadius = (radiusX + radiusY) / 2;
    final calculatedFontSize = averageRadius / 11;
    final labelFontSize = fontSize ?? calculatedFontSize;

    // For right-handed: LEG on left, OFF on right
    // For left-handed: LEG on right, OFF on left (mirrored)
    final leftLabel = isLeftHanded ? offLabel : legLabel;
    final rightLabel = isLeftHanded ? legLabel : offLabel;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: labelFontSize * 1.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left label (LEG for right-handed, OFF for left-handed)
            Text(
              rightLabel,
              style: TextStyle(
                color: labelColor,
                fontSize: labelFontSize,
                fontWeight: labelFontWeight,
              ),
            ),
            SizedBox(width: pitchSize.width * 1.5),
            // Right label (OFF for right-handed, LEG for left-handed)
            Text(
              leftLabel,
              style: TextStyle(
                color: labelColor,
                fontSize: labelFontSize,
                fontWeight: labelFontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
