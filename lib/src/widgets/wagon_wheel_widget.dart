import 'dart:math' as math;

import 'package:cricket_wagon_wheel/src/draggable_marker.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_animation_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_line_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_marker_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_text_properties.dart';
import 'package:cricket_wagon_wheel/src/painters/wagon_wheel_partition_painter.dart';
import 'package:cricket_wagon_wheel/src/utils/wagon_wheel_constants.dart';
import 'package:cricket_wagon_wheel/src/utils/wagon_wheel_size_calculator.dart';
import 'package:cricket_wagon_wheel/src/widgets/wagon_wheel_batsman_builder.dart';
import 'package:cricket_wagon_wheel/src/widgets/wagon_wheel_boundary_widgets.dart';
import 'package:flutter/material.dart';

/// Main widget for displaying a cricket wagon wheel diagram
///
/// The wagon wheel is a circular visualization of a cricket field divided into
/// sectors representing different fielding positions. It includes:
/// - Circular boundaries (stadium, ground, thirty yards)
/// - Central pitch with batsman icon
/// - Sector lines dividing the field
/// - Fielding position labels
/// - Draggable marker for shot placement
///
/// **Usage Example:**
/// ```dart
/// WagonWheel(
///   config: WagonWheelConfig(
///     boundary: WagonWheelBoundaryProperties(
///       groundSize: 300,
///       stadiumBoundarySize: 20,
///     ),
///     pitch: WagonWheelPitchProperties(
///       showBatsman: true,
///       showLegOffLabels: true,
///     ),
///     text: WagonWheelTextProperties(
///       textColor: Colors.white,
///     ),
///     boundaryLines: WagonWheelBoundaryLineProperties(
///       lineColor: Colors.white,
///       lineOpacity: 0.4,
///       lineWidth: 1.2,
///     ),
///   ),
///   onMarkerPositionChanged: (phi, t) {
///     print('Marker position: phi=$phi, t=$t');
///   },
/// )
/// ```
///
/// **Customization:**
/// - Use [WagonWheelConfig.customWidgetBuilder] for complete UI override
/// - Use [WagonWheelPitchProperties.customPitchBuilder] for custom pitch UI
/// - All visual properties are configurable through respective property classes
class WagonWheel extends StatefulWidget {
  /// Configuration for the wagon wheel
  ///
  /// Use WagonWheelConfig to organize all properties into logical groups.
  /// If null, uses default configuration.
  final WagonWheelConfig? config;

  /// Callback called when the marker position changes.
  /// Provides the angle (phi) in radians and the normalized radius (t) from 0.0 to 1.0.
  /// - phi: angle in radians (0 to 2π)
  /// - t: normalized distance from center (0.0 = center, 1.0 = border)
  final void Function(double phi, double t)? onMarkerPositionChanged;

  const WagonWheel({super.key, this.config, this.onMarkerPositionChanged});

  @override
  State<WagonWheel> createState() => _WagonWheelState();
}

class _WagonWheelState extends State<WagonWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController splashController;
  int selectedSection = -1;

  // Track marker position when user interacts without initial position
  double? _currentPhi;
  double? _currentT;

  /// Get effective config, using provided config or creating default
  WagonWheelConfig get _effectiveConfig =>
      widget.config ?? const WagonWheelConfig();

  /// Get effective number of sectors from config with default fallback
  int _getNumberOfSectors(WagonWheelConfig config) =>
      config.numberOfSectors ?? WagonWheelConstants.numberOfSectors;

  /// Get effective base start angle from config with default fallback
  double _getBaseStartAngle(WagonWheelConfig config) =>
      config.baseStartAngle ?? WagonWheelConstants.defaultBaseStartAngle;

  /// Get effective labels from config, ensuring they match numberOfSectors
  List<String> _getLabels(WagonWheelConfig config, int numberOfSectors) {
    if (config.labels != null) {
      final providedLabels = config.labels!;
      // Ensure labels list matches numberOfSectors (trim or pad if needed)
      if (providedLabels.length < numberOfSectors) {
        // Pad with empty strings if too few labels
        return [
          ...providedLabels,
          ...List.filled(numberOfSectors - providedLabels.length, ''),
        ];
      } else if (providedLabels.length > numberOfSectors) {
        // Trim if too many labels
        return providedLabels.sublist(0, numberOfSectors);
      }
      return providedLabels;
    }
    return WagonWheelConstants.getLabels(config.isLeftHanded);
  }

  /// Normalize angle to [0, 2π) range
  ///
  /// Ensures angle is within valid range by wrapping around:
  /// - Negative angles: add 2π
  /// - Angles >= 2π: subtract 2π
  double _normalizeAngle(double angle) {
    double normalized = angle;
    if (normalized < 0) normalized += 2 * math.pi;
    if (normalized >= 2 * math.pi) normalized -= 2 * math.pi;
    return normalized;
  }

  @override
  void initState() {
    super.initState();
    final config = _effectiveConfig;
    final animation = config.animation ?? const WagonWheelAnimationProperties();
    final marker = config.marker ?? const WagonWheelMarkerProperties();

    splashController = AnimationController(
      vsync: this,
      duration:
          animation.splashAnimationDuration ??
          const Duration(milliseconds: 400),
    );

    // Set initial selected section and marker position if provided and marker is enabled
    if (marker.enableMarker && marker.initialPhi != null) {
      _currentPhi = marker.initialPhi;
      _currentT = marker.initialT ?? 1.0;
      selectedSection = _detectSection(marker.initialPhi!);
    }
  }

  @override
  void dispose() {
    splashController.dispose();
    super.dispose();
  }

  /// Detect which sector the marker is currently in based on angle
  ///
  /// Calculates which of the numbered sectors (0 to numberOfSectors-1)
  /// contains the given angle phi, accounting for baseStartAngle offset.
  ///
  /// **Returns:** Sector index (0 to numberOfSectors-1) or -1 if invalid
  int _detectSection(double phi) {
    final config = _effectiveConfig;
    final baseStartAngle = _getBaseStartAngle(config);
    final numberOfSectors = _getNumberOfSectors(config);

    // Normalize angle to [0, 2π)
    final normalizedPhi = _normalizeAngle(phi);

    final sectorAngle = (2 * math.pi) / numberOfSectors;

    // Adjust phi to account for the start angle
    double adjustedPhi = normalizedPhi - baseStartAngle;
    adjustedPhi = _normalizeAngle(adjustedPhi);

    // Calculate section index
    int section = (adjustedPhi / sectorAngle).floor();

    // Ensure section is in valid range [0, numberOfSectors-1]
    section = section % numberOfSectors;
    if (section < 0) section += numberOfSectors;

    return section;
  }

  @override
  Widget build(BuildContext context) {
    final config = _effectiveConfig;

    // Allow custom widget builder if provided (fallback for complete customization)
    if (config.customWidgetBuilder != null) {
      return config.customWidgetBuilder!(
        context,
        _effectiveConfig,
        widget.onMarkerPositionChanged,
      );
    }

    getBorderWidth(BoxBorder? border) {
      final borderTop = border?.top;
      final borderBottom = border?.bottom;
      final borderSize = borderTop?.width ?? borderBottom?.width ?? 0.0;
      return borderSize;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Available Space
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final boundary =
            config.boundary ?? const WagonWheelBoundaryProperties();
        final pitch = config.pitch ?? const WagonWheelPitchProperties();
        final text = config.text ?? const WagonWheelTextProperties();
        final animation =
            config.animation ?? const WagonWheelAnimationProperties();
        final marker = config.marker ?? const WagonWheelMarkerProperties();
        final boundaryLines =
            config.boundaryLines ?? const WagonWheelBoundaryLineProperties();

        // Get number of sectors and labels with defaults
        final numberOfSectors = _getNumberOfSectors(config);
        final labels = _getLabels(config, numberOfSectors);

        // Ground Boundary - use MediaQuery to get screen width if groundSize not provided
        final screenWidth = MediaQuery.of(context).size.width;
        double groundBoundary = boundary.groundSize ?? screenWidth * 0.8;

        // Circle must fit inside both → pick the smallest
        if (groundBoundary > availableWidth) {
          groundBoundary = availableWidth;
        } else if (groundBoundary > availableHeight) {
          groundBoundary = availableHeight;
        }

        // Stadium Boundary
        final baseStadiumBoundary = boundary.stadiumBoundarySize;
        double stadiumBoundary = baseStadiumBoundary + groundBoundary;

        // Circle must fit inside both → pick the smallest
        if (stadiumBoundary > availableWidth) {
          stadiumBoundary = availableWidth;
        } else if (stadiumBoundary > availableHeight) {
          stadiumBoundary = availableHeight;
        }

        groundBoundary -=
            baseStadiumBoundary +
            (getBorderWidth(boundary.groundBoundaryBorder) * 2) +
            (getBorderWidth(boundary.stadiumBoundaryBorder) * 2);

        final calculatedStadiumBoundary =
            WagonWheelSizeCalculator.calculateOvalCircleSize(
              oval: boundary.groundBoundaryOvalness,
              size: stadiumBoundary,
            );
        final calculatedGroundBoundary =
            WagonWheelSizeCalculator.calculateOvalCircleSize(
              size: groundBoundary,
              oval: boundary.groundBoundaryOvalness,
            );

        // Thirty Yards Boundary
        final thirtyYardsBoundary =
            boundary.thirtyYardsSize ?? groundBoundary * 0.45;
        final calculatedThirtyYardsBoundary =
            WagonWheelSizeCalculator.calculateCapsuleCircleSize(
              size: thirtyYardsBoundary,
              capsule: boundary.thirtyYardsBoundaryCapsulness,
            );

        // Build children list based on z-order preference
        final List<Widget> stackChildren = [
          WagonWheelBoundaryWidgets.buildGroundCircle(
            stadiumBoundary: calculatedStadiumBoundary,
            groundBoundary: calculatedGroundBoundary,
            thirtyYardsBoundary: calculatedThirtyYardsBoundary,
            boundaryProperties: boundary,
            pitchProperties: pitch,
            isLeftHanded: config.isLeftHanded,
          ),
        ];

        // Only show animations and highlighting if marker is enabled
        final effectiveSelectedSection = marker.enableMarker
            ? selectedSection
            : -1;
        final effectiveSplashAnimation = marker.enableMarker
            ? splashController
            : null;

        final labelsWidget = Center(
          child: CustomPaint(
            size: calculatedGroundBoundary,
            painter: WagonWheelPartitionPainter(
              radiusX: calculatedGroundBoundary.width / 2,
              radiusY: calculatedGroundBoundary.height / 2,
              isLeftHanded: config.isLeftHanded,
              highlightedSection: effectiveSelectedSection,
              splashAnimation: effectiveSplashAnimation,
              textProperties: text,
              animationProperties: animation,
              boundaryLineProperties: boundaryLines,
              baseStartAngle: _getBaseStartAngle(config),
              numberOfSectors: numberOfSectors,
              labels: labels,
            ),
          ),
        );

        final markerWidget = _buildDraggableMarker(
          calculatedGroundBoundary,
          marker,
        );

        // Build static markers widget if provided (reusing DraggableMarker)
        Widget? staticMarkersWidget;
        if (config.staticMarkers != null && config.staticMarkers!.isNotEmpty) {
          staticMarkersWidget = Stack(
            children: config.staticMarkers!
                .where((marker) => marker.initialPhi != null)
                .map(
                  (marker) => Center(
                    child: SizedBox(
                      width: calculatedGroundBoundary.width,
                      height: calculatedGroundBoundary.height,
                      child: DraggableMarker(
                        a: calculatedGroundBoundary.width / 2,
                        b: calculatedGroundBoundary.height / 2,
                        initialPhi: marker.initialPhi,
                        initialT: marker.initialT,
                        lineColor: marker.markerLineColor,
                        lineWidth: marker.markerLineWidth,
                        circleColor: marker.markerCircleColor,
                        circleSize: marker.markerCircleSize,
                        isInteractive:
                            false, // Static markers are not draggable
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }

        // Calculate pitch properties for batsman rendering
        final thirtyYardsDiameter = calculatedThirtyYardsBoundary.height;
        final pitchSize = pitch.calculatePitchSize(thirtyYardsDiameter);

        // Build batsman widget if it should be above grid lines
        Widget? standaloneBatsmanWidget;
        if (pitch.batsmanAboveGridLines && pitch.showBatsman) {
          standaloneBatsmanWidget = Center(
            child: WagonWheelBatsmanBuilder.buildBatsman(
              pitchSize: pitchSize,
              pitchProperties: pitch,
              isLeftHanded: config.isLeftHanded,
            )!,
          );
        }

        // Build widget list based on z-order preferences
        // Z-order: labels -> static markers -> draggable marker -> batsman
        // Static markers render below draggable marker so draggable marker appears on top
        if (pitch.batsmanAboveGridLines && standaloneBatsmanWidget != null) {
          // Batsman above grid lines: boundary -> grid -> static markers -> draggable marker -> batsman
          if (config.labelsAboveMarker) {
            stackChildren.add(IgnorePointer(child: labelsWidget));
            if (staticMarkersWidget != null) {
              stackChildren.add(staticMarkersWidget);
            }
            stackChildren.add(markerWidget);
          } else {
            stackChildren.add(labelsWidget);
            if (staticMarkersWidget != null) {
              stackChildren.add(staticMarkersWidget);
            }
            stackChildren.add(markerWidget);
          }
          stackChildren.add(standaloneBatsmanWidget);
        } else {
          // Batsman inside pitch (below grid lines): normal order
          if (config.labelsAboveMarker) {
            stackChildren.add(IgnorePointer(child: labelsWidget));
            if (staticMarkersWidget != null) {
              stackChildren.add(staticMarkersWidget);
            }
            stackChildren.add(markerWidget);
          } else {
            stackChildren.add(labelsWidget);
            if (staticMarkersWidget != null) {
              stackChildren.add(staticMarkersWidget);
            }
            stackChildren.add(markerWidget);
          }
        }

        return SizedBox(
          width: calculatedStadiumBoundary.width,
          height: calculatedStadiumBoundary.height,
          child: Stack(children: stackChildren),
        );
      },
    );
  }

  Widget _buildDraggableMarker(
    Size calculatedGroundBoundary,
    WagonWheelMarkerProperties markerProperties,
  ) {
    // If marker is disabled, return empty widget
    if (!markerProperties.enableMarker) {
      return const SizedBox.shrink();
    }

    // Use state-tracked position if available, otherwise use from config
    final effectivePhi = _currentPhi ?? markerProperties.initialPhi;
    final effectiveT = _currentT ?? markerProperties.initialT;

    return Center(
      child: SizedBox(
        width: calculatedGroundBoundary.width,
        height: calculatedGroundBoundary.height,
        child: DraggableMarker(
          a: calculatedGroundBoundary.width / 2,
          b: calculatedGroundBoundary.height / 2,
          initialPhi: effectivePhi,
          initialT: effectiveT,
          lineColor: markerProperties.markerLineColor,
          lineWidth: markerProperties.markerLineWidth,
          circleColor: markerProperties.markerCircleColor,
          circleSize: markerProperties.markerCircleSize,
          lockToBorder: markerProperties.lockToBorder,
          isInteractive: markerProperties.enableMarker,
          onDragEndPhiT: (phi, t) {
            final section = _detectSection(phi);
            setState(() {
              _currentPhi = phi;
              _currentT = t;
              selectedSection = section;
            });
            splashController.forward(from: 0);

            // Notify user of marker position change
            if (widget.onMarkerPositionChanged != null) {
              widget.onMarkerPositionChanged!(phi, t);
            }
          },
        ),
      ),
    );
  }
}
