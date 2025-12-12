import 'package:cricket_wagon_wheel/src/models/wagon_wheel_sector_label.dart';
import 'package:flutter/material.dart';

/// Constants used throughout the wagon wheel implementation
class WagonWheelConstants {
  // Label order for RIGHT-HANDED batsman (matching reference image)
  // Starting from top-left, going clockwise
  static const List<WagonWheelSectorLabel> labelsRightHanded = [
    WagonWheelSectorLabel(
        id: 'third_man', name: 'Third Man'), // Sector 0: Top-Left
    WagonWheelSectorLabel(
        id: 'deep_fine_leg', name: 'Deep Fine Leg'), // Sector 1: Top-Right
    WagonWheelSectorLabel(
        id: 'deep_square_leg', name: 'Deep Square Leg'), // Sector 2: Mid-Right
    WagonWheelSectorLabel(
        id: 'deep_mid_wicket',
        name: 'Deep Mid Wicket'), // Sector 3: Bottom-Right
    WagonWheelSectorLabel(
        id: 'long_on', name: 'Long On'), // Sector 4: Bottom-Center-Right
    WagonWheelSectorLabel(
        id: 'long_off', name: 'Long Off'), // Sector 5: Bottom-Center-Left
    WagonWheelSectorLabel(
        id: 'deep_cover', name: 'Deep Cover'), // Sector 6: Bottom-Left
    WagonWheelSectorLabel(
        id: 'deep_point', name: 'Deep Point'), // Sector 7: Mid-Left
  ];

  // For left-handed batsman, mirror horizontally (swap left/right sides)
  // Mapping: 0↔1, 2↔3, 4↔5, 6↔7
  static const List<int> leftHandedMapping = [1, 0, 7, 6, 5, 4, 3, 2];

  // Number of sectors
  static const int numberOfSectors = 8;

  // Text defaults
  static const Color defaultTextColor = Colors.white;
  static const FontWeight defaultTextFontWeight = FontWeight.w600;
  static const double defaultTextRadiusFactor = 0.75; // Closer to outer edge
  static const double defaultTextMinRadiusFactor =
      0.45; // Minimum distance from center to avoid inner boundaries

  // Animation defaults
  static const Color defaultSplashColor = Colors.white;
  static const double defaultSplashMaxRadius = 1;
  static const Curve defaultSplashAnimationCurve = Curves.easeOut;
  static const double defaultSplashOpacity = 0.3;
  static const Color defaultSelectedSectorBackgroundColor = Colors.white;
  static const double defaultSelectedSectorBackgroundOpacity = 0.15;

  // Angle calculation
  // Default base start angle: -3π/4 (-135 degrees) starts from top-left
  static const double defaultBaseStartAngle =
      -3 * 3.141592653589793 / 4; // -3π/4

  /// Get labels for the specified batsman orientation
  static List<WagonWheelSectorLabel> getLabels(bool isLeftHanded) {
    if (isLeftHanded) {
      return leftHandedMapping
          .map((index) => labelsRightHanded[index])
          .toList();
    }
    return labelsRightHanded;
  }
}
