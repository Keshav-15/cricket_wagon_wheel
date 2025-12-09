import 'package:cricket_wagon_wheel/src/models/wagon_wheel_batsman_properties.dart';
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
  /// - Icon path (uses default or user-provided SVG asset)
  /// - Icon size (default: pitchSize.width / 1.2)
  /// - Color filter (optional tinting)
  /// - Vertical offset (for fine-tuning position)
  /// - Horizontal mirroring (when isLeftHanded is true)
  ///
  /// Returns null if [show] is false.
  static Widget? buildBatsman({
    required Size pitchSize,
    required WagonWheelBatsmanProperties batsmanProperties,
    bool isLeftHanded = false,
  }) {
    if (!batsmanProperties.show) return null;

    final batsmanIconPath = batsmanProperties.effectiveIconPath;

    final defaultIconSize = pitchSize.width / 1.2;
    final iconSizeWidth =
        batsmanProperties.iconSize?.width ?? defaultIconSize;
    final iconSizeHeight =
        batsmanProperties.iconSize?.height ?? defaultIconSize;

    Widget batsmanWidget = SvgPicture.asset(
      batsmanIconPath,
      width: iconSizeWidth,
      height: iconSizeHeight,
      colorFilter: batsmanProperties.iconColorFilter,
      fit: BoxFit.contain,
    );

    // Mirror horizontally if left-handed
    if (isLeftHanded) {
      batsmanWidget = Transform.flip(flipX: true, child: batsmanWidget);
    }

    // Apply vertical offset (slightly above center by default when inside pitch)
    final effectiveVerticalOffset = batsmanProperties.verticalOffset ?? 0;

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
