import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Unified builder for batsman icon widget
///
/// Consolidates all batsman rendering logic in one place.
/// Handles icon loading, sizing, positioning, and styling.
class WagonWheelBatsmanBuilder {
  /// Build the batsman icon widget
  ///
  /// Creates a centered batsman icon with configurable:
  /// - Icon path (user must provide their own SVG asset)
  /// - Icon size (default: pitchSize.width / 1.2)
  /// - Color filter (optional tinting)
  /// - Vertical offset (for fine-tuning position)
  /// - Horizontal mirroring (when isLeftHanded is true)
  ///
  /// Returns null if [showBatsman] is false.
  static Widget? buildBatsman({
    required Size pitchSize,
    required WagonWheelPitchProperties pitchProperties,
    bool isLeftHanded = false,
  }) {
    if (!pitchProperties.showBatsman) return null;

    // User must provide their own batsman icon path
    final batsmanIconPath = pitchProperties.batsmanIconPath;
    if (batsmanIconPath == null) {
      // Return null if no icon path provided (user needs to add their own asset)
      return null;
    }

    final defaultIconSize = pitchSize.width / 1.2;
    final iconSizeWidth =
        pitchProperties.batsmanIconSize?.width ?? defaultIconSize;
    final iconSizeHeight =
        pitchProperties.batsmanIconSize?.height ?? defaultIconSize;

    Widget batsmanWidget = SvgPicture.asset(
      batsmanIconPath,
      width: iconSizeWidth,
      height: iconSizeHeight,
      colorFilter: pitchProperties.batsmanIconColorFilter,
      fit: BoxFit.contain,
    );

    // Mirror horizontally if left-handed
    if (isLeftHanded) {
      batsmanWidget = Transform.flip(flipX: true, child: batsmanWidget);
    }

    // Apply vertical offset (slightly above center by default when inside pitch)
    final effectiveVerticalOffset = pitchProperties.iconVerticalOffset ?? 0;

    return Center(
      child: effectiveVerticalOffset != 0.0
          ? Transform.translate(
              offset: Offset(0, effectiveVerticalOffset),
              child: batsmanWidget,
            )
          : batsmanWidget,
    );
  }
}
