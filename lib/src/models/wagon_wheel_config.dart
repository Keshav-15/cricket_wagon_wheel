import 'package:cricket_wagon_wheel/src/models/wagon_wheel_animation_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_line_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_marker_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_text_properties.dart';
import 'package:flutter/material.dart';

/// Complete configuration for the WagonWheel widget
///
/// This class groups all configuration properties into logical sections
/// for better organization and clarity.
///
/// All properties are optional - only specify what you want to customize.
class WagonWheelConfig {
  /// Configuration for boundaries (stadium, ground, thirty yards)
  final WagonWheelBoundaryProperties? boundary;

  /// Configuration for the pitch
  final WagonWheelPitchProperties? pitch;

  /// Configuration for text labels
  final WagonWheelTextProperties? text;

  /// Configuration for animations and splash effects
  final WagonWheelAnimationProperties? animation;

  /// Configuration for the draggable marker
  final WagonWheelMarkerProperties? marker;

  /// Configuration for boundary lines (sector lines)
  final WagonWheelBoundaryLineProperties? boundaryLines;

  /// List of static (non-draggable) markers to display
  /// These markers will be rendered but cannot be moved by user interaction
  /// Uses WagonWheelMarkerProperties with initialPhi and initialT set
  final List<WagonWheelMarkerProperties>? staticMarkers;

  /// Whether the batsman is left-handed (affects label mirroring)
  final bool isLeftHanded;

  /// Base start angle for sector calculation in radians
  /// Defaults to -3π/4 (-135 degrees) which starts from top-left
  /// This determines where the first sector (sector 0) begins
  final double? baseStartAngle;

  /// Number of sectors/partitions in the circle
  /// Defaults to 8 sectors
  /// If you provide custom labels, ensure they match this count
  final int? numberOfSectors;

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

  /// Custom widget builder for complete wagon wheel customization.
  /// If provided, this will be used instead of the default widget implementation.
  /// This allows users to completely override the rendering logic while still
  /// having access to the configuration and callbacks.
  ///
  /// Parameters:
  /// - [context] - BuildContext for the widget
  /// - [config] - The effective WagonWheelConfig
  /// - [onMarkerPositionChanged] - Callback for marker position changes
  ///
  /// Returns: A custom Widget that replaces the entire wagon wheel UI
  final Widget Function(
    BuildContext context,
    WagonWheelConfig config,
    void Function(double phi, double t)? onMarkerPositionChanged,
  )?
  customWidgetBuilder;

  const WagonWheelConfig({
    this.boundary,
    this.pitch,
    this.text,
    this.animation,
    this.marker,
    this.boundaryLines,
    this.staticMarkers,
    this.isLeftHanded = false,
    this.baseStartAngle,
    this.numberOfSectors,
    this.labels,
    this.labelsAboveMarker = false,
    this.customWidgetBuilder,
  });
}
