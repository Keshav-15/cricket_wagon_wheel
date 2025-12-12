import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_line_properties.dart';

/// Configuration for sector/partition settings
///
/// This class groups all sector-related configurations including:
/// - Sector calculation (base start angle, number of sectors)
/// - Boundary lines (sector divider lines)
class WagonWheelSectorConfig {
  /// Base start angle for sector calculation in radians
  /// Defaults to -3π/4 (-135 degrees) which starts from top-left
  /// This determines where the first sector (sector 0) begins
  final double? baseStartAngle;

  /// Number of sectors/partitions in the circle
  /// Defaults to 8 sectors
  /// If you provide custom labels, ensure they match this count
  final int? numberOfSectors;

  /// Configuration for boundary lines (sector divider lines)
  final WagonWheelBoundaryLineProperties? boundaryLines;

  const WagonWheelSectorConfig({
    this.baseStartAngle,
    this.numberOfSectors,
    this.boundaryLines,
  });
}
