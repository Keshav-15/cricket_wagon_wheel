import 'package:cricket_wagon_wheel/src/models/wagon_wheel_text_properties.dart';

/// Configuration for labels displayed on the wagon wheel
class WagonWheelLabelConfig {
  /// Text styling properties for labels
  final WagonWheelTextProperties? properties;

  /// Custom labels for each sector. If provided, will override default labels.
  /// Length will be automatically adjusted to match numberOfSectors:
  /// - If too few labels: padded with empty strings
  /// - If too many labels: trimmed to match numberOfSectors
  /// If null, uses default cricket fielding position labels
  final List<String>? labels;

  /// Whether labels should be rendered above the marker.
  /// - `true`: Labels appear above the marker (marker below labels)
  /// - `false`: Marker appears above labels (default, current behavior)
  final bool labelsAboveMarker;

  const WagonWheelLabelConfig({
    this.properties,
    this.labels,
    this.labelsAboveMarker = false,
  });
}
