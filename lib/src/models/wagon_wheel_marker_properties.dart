import 'package:flutter/material.dart';

/// Configuration for the draggable marker on the wagon wheel
class WagonWheelMarkerProperties {
  /// Initial angle (phi) in radians for the marker position
  /// If null, marker will not be shown
  final double? initialPhi;

  /// Initial normalized radius (t) from 0.0 to 1.0 for the marker position
  /// Only used if initialPhi is not null. Defaults to 1.0 (border) if not specified
  final double? initialT;

  /// Color of the marker line
  final Color? markerLineColor;

  /// Width of the marker line
  final double? markerLineWidth;

  /// Color of the marker circle (end point)
  final Color? markerCircleColor;

  /// Size of the marker circle (diameter)
  final double? markerCircleSize;

  /// Whether the marker should be locked to the border (t = 1.0)
  final bool lockToBorder;

  /// Whether the draggable marker is enabled and interactive
  /// If false, the marker will not be rendered, cannot be dragged,
  /// and no animations or interactions will occur
  /// Default: true (marker is enabled and interactive)
  final bool enableMarker;

  const WagonWheelMarkerProperties({
    this.initialPhi,
    this.initialT,
    this.markerLineColor,
    this.markerLineWidth,
    this.markerCircleColor,
    this.markerCircleSize,
    this.lockToBorder = false,
    this.enableMarker = true,
  });
}
