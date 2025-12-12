import 'package:cricket_wagon_wheel/src/models/wagon_wheel_ground_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_stadium_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_thirty_yards_boundary_properties.dart';

/// Configuration for all boundaries (stadium, ground, thirty yards) and pitch
///
/// This class groups boundary configurations into logical categories
/// for better organization and clarity. The pitch is included here as it
/// is positioned within the boundary structure.
class WagonWheelBoundaryProperties {
  /// Configuration for the stadium boundary (outermost)
  final WagonWheelStadiumBoundaryProperties? stadium;

  /// Configuration for the ground boundary (middle)
  final WagonWheelGroundBoundaryProperties? ground;

  /// Configuration for the thirty yards boundary (innermost)
  final WagonWheelThirtyYardsBoundaryProperties? thirtyYards;

  /// Configuration for the pitch (positioned at the center, inside boundaries)
  final WagonWheelPitchProperties? pitch;

  const WagonWheelBoundaryProperties({
    this.stadium,
    this.ground,
    this.thirtyYards,
    this.pitch,
  });
}
