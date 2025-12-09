import 'package:cricket_wagon_wheel/src/models/wagon_wheel_batsman_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_circle_indicator_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_leg_off_label_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_rectangle_properties.dart';
import 'package:flutter/material.dart';

/// Configuration for the pitch at the center of the wagon wheel
///
/// This class groups pitch-related configurations into logical categories:
/// - [pitchConfig] - Pitch rectangle configuration (size, color, border)
/// - [circleIndicator] - Circle indicator above pitch
/// - [batsman] - Batsman icon/widget properties
/// - [legOffLabel] - LEG/OFF labels on sides of pitch
class WagonWheelPitchProperties {
  /// Configuration for the pitch rectangle itself (size, color, border, custom builder)
  final WagonWheelPitchRectangleProperties? pitchConfig;

  /// Configuration for the circle indicator above the pitch
  final WagonWheelCircleIndicatorProperties? circleIndicator;

  /// Configuration for the batsman icon/widget
  final WagonWheelBatsmanProperties? batsman;

  /// Configuration for LEG/OFF labels positioned on the sides of the pitch
  final WagonWheelLegOffLabelProperties? legOffLabel;

  const WagonWheelPitchProperties({
    this.pitchConfig,
    this.circleIndicator,
    this.batsman,
    this.legOffLabel,
  });

  // Helper methods for backward compatibility and convenience
  Size calculatePitchSize(double thirtyYardsBoundary) {
    final config = pitchConfig ?? const WagonWheelPitchRectangleProperties();
    return config.calculateSize(thirtyYardsBoundary);
  }

  double calculateBorderSpacing(Size pitchSize) {
    final config = pitchConfig ?? const WagonWheelPitchRectangleProperties();
    return config.calculateBorderSpacing(pitchSize);
  }
}
