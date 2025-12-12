import 'dart:math' as math;

import 'package:cricket_wagon_wheel/src/draggable_marker.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_animation_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_batsman_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_line_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_ground_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_label_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_marker_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_sector_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_sector_label.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_stadium_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_text_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_thirty_yards_boundary_properties.dart';
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
///   boundary: WagonWheelBoundaryProperties(
///     stadium: WagonWheelStadiumBoundaryProperties(size: 20),
///     ground: WagonWheelGroundBoundaryProperties(size: 300),
///     pitch: WagonWheelPitchProperties(
///       batsman: WagonWheelBatsmanProperties(show: true),
///       legOffLabel: WagonWheelLegOffLabelProperties(show: true),
///     ),
///   ),
///   label: WagonWheelLabelConfig(
///     properties: WagonWheelTextProperties(textColor: Colors.white),
///   ),
///   sector: WagonWheelSectorConfig(
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
/// - Use [customWidgetBuilder] for complete UI override
/// - Use [WagonWheelPitchPropertiesConfig.customBuilder] for custom pitch UI
/// - All visual properties are configurable through respective property classes
class WagonWheel extends StatefulWidget {
  /// Configuration for boundaries (stadium, ground, thirty yards) and pitch
  final WagonWheelBoundaryProperties? boundary;

  /// Configuration for labels (text properties, custom labels, and positioning)
  final WagonWheelLabelConfig? label;

  /// Configuration for sector/partition settings (base start angle, number of sectors, boundary lines)
  final WagonWheelSectorConfig? sector;

  /// Configuration for animations and splash effects
  final WagonWheelAnimationProperties? animation;

  /// Configuration for the draggable marker
  final WagonWheelMarkerProperties? marker;

  /// List of static (non-draggable) markers to display
  /// These markers will be rendered but cannot be moved by user interaction
  /// Uses WagonWheelMarkerProperties with initialPhi and initialT set
  final List<WagonWheelMarkerProperties>? staticMarkers;

  /// Whether the batsman is left-handed (affects label mirroring)
  final bool isLeftHanded;

  /// Custom widget builder for complete wagon wheel customization.
  /// If provided, this will be used instead of the default widget implementation.
  /// This allows users to completely override the rendering logic.
  ///
  /// Parameters:
  /// - [context] - BuildContext for the widget
  /// - [onMarkerPositionChanged] - Callback for marker position changes
  ///
  /// Returns: A custom Widget that replaces the entire wagon wheel UI
  final Widget Function(
    BuildContext context,
    void Function(double phi, double t, WagonWheelSectorLabel label)?
        onMarkerPositionChanged,
  )? customWidgetBuilder;

  /// Callback called when the marker position changes.
  /// Provides the angle (phi) in radians, the normalized radius (t) from 0.0 to 1.0,
  /// and the sector label for the current position.
  /// - phi: angle in radians (0 to 2π)
  /// - t: normalized distance from center (0.0 = center, 1.0 = border)
  /// - label: the sector label for the current position
  final void Function(double phi, double t, WagonWheelSectorLabel label)?
      onMarkerPositionChanged;

  const WagonWheel({
    super.key,
    this.boundary,
    this.label,
    this.sector,
    this.animation,
    this.marker,
    this.staticMarkers,
    this.isLeftHanded = false,
    this.customWidgetBuilder,
    this.onMarkerPositionChanged,
  });

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

  /// Get effective number of sectors with default fallback
  int _getNumberOfSectors() =>
      widget.sector?.numberOfSectors ?? WagonWheelConstants.numberOfSectors;

  /// Get effective base start angle with default fallback
  double _getBaseStartAngle() =>
      widget.sector?.baseStartAngle ??
      WagonWheelConstants.defaultBaseStartAngle;

  /// Get effective labels, ensuring they match numberOfSectors
  List<WagonWheelSectorLabel> _getLabels(int numberOfSectors) {
    if (widget.label?.labels != null) {
      final providedLabels = widget.label!.labels!;
      // Ensure labels list matches numberOfSectors (trim or pad if needed)
      if (providedLabels.length < numberOfSectors) {
        // Pad with empty label objects if too few labels
        return [
          ...providedLabels,
          ...List.generate(
            numberOfSectors - providedLabels.length,
            (index) => WagonWheelSectorLabel(
              id: 'empty_${providedLabels.length + index}',
              name: '',
            ),
          ),
        ];
      } else if (providedLabels.length > numberOfSectors) {
        // Trim if too many labels
        return providedLabels.sublist(0, numberOfSectors);
      }
      return providedLabels;
    }
    return WagonWheelConstants.getLabels(widget.isLeftHanded);
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
    final animation = widget.animation ?? const WagonWheelAnimationProperties();
    final marker = widget.marker ?? const WagonWheelMarkerProperties();

    splashController = AnimationController(
      vsync: this,
      duration: animation.splashAnimationDuration ??
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
    final baseStartAngle = _getBaseStartAngle();
    final numberOfSectors = _getNumberOfSectors();

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
    // Allow custom widget builder if provided (fallback for complete customization)
    if (widget.customWidgetBuilder != null) {
      return widget.customWidgetBuilder!(
        context,
        widget.onMarkerPositionChanged,
      );
    }

    /// Extract border width from a BoxBorder.
    ///
    /// Returns the width of the top or bottom border, or 0.0 if no border exists.
    /// Used for calculating boundary spacing to account for border thickness.
    double getBorderWidth(BoxBorder? border) {
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
            widget.boundary ?? const WagonWheelBoundaryProperties();
        final pitch = boundary.pitch ?? const WagonWheelPitchProperties();
        final labelConfig = widget.label ?? const WagonWheelLabelConfig();
        final text = labelConfig.properties ?? const WagonWheelTextProperties();
        final animation =
            widget.animation ?? const WagonWheelAnimationProperties();
        final marker = widget.marker ?? const WagonWheelMarkerProperties();
        final sectorConfig = widget.sector ?? const WagonWheelSectorConfig();
        final boundaryLines = sectorConfig.boundaryLines ??
            const WagonWheelBoundaryLineProperties();

        // Get number of sectors and labels with defaults
        final numberOfSectors = _getNumberOfSectors();
        final labels = _getLabels(numberOfSectors);

        // Ground Boundary - use MediaQuery to get screen width if groundSize not provided
        // Default to 80% of screen width for responsive sizing
        final screenWidth = MediaQuery.of(context).size.width;
        const double defaultGroundSizeFactor = 0.8;
        final groundProps =
            boundary.ground ?? const WagonWheelGroundBoundaryProperties();
        double groundBoundary =
            groundProps.size ?? screenWidth * defaultGroundSizeFactor;

        // Circle must fit inside both → pick the smallest
        if (groundBoundary > availableWidth) {
          groundBoundary = availableWidth;
        } else if (groundBoundary > availableHeight) {
          groundBoundary = availableHeight;
        }

        // Stadium Boundary
        final stadiumProps =
            boundary.stadium ?? const WagonWheelStadiumBoundaryProperties();
        final baseStadiumBoundary = stadiumProps.size;
        double stadiumBoundary = baseStadiumBoundary + groundBoundary;

        // Circle must fit inside both → pick the smallest
        if (stadiumBoundary > availableWidth) {
          stadiumBoundary = availableWidth;
        } else if (stadiumBoundary > availableHeight) {
          stadiumBoundary = availableHeight;
        }

        // Adjust ground boundary to account for stadium boundary size and borders
        // Multiply border width by 2 to account for both sides (inner and outer)
        groundBoundary -= baseStadiumBoundary +
            (getBorderWidth(groundProps.border) * 2) +
            (getBorderWidth(stadiumProps.border) * 2);

        final calculatedStadiumBoundary =
            WagonWheelSizeCalculator.calculateOvalCircleSize(
          oval: groundProps.ovalness,
          size: stadiumBoundary,
        );
        final calculatedGroundBoundary =
            WagonWheelSizeCalculator.calculateOvalCircleSize(
          size: groundBoundary,
          oval: groundProps.ovalness,
        );

        // Thirty Yards Boundary
        // Default to 45% of ground boundary size (standard cricket field proportion)
        const double defaultThirtyYardsFactor = 0.45;
        final thirtyYardsProps = boundary.thirtyYards ??
            const WagonWheelThirtyYardsBoundaryProperties();
        final thirtyYardsBoundary =
            thirtyYardsProps.size ?? groundBoundary * defaultThirtyYardsFactor;
        final calculatedThirtyYardsBoundary =
            WagonWheelSizeCalculator.calculateCapsuleCircleSize(
          size: thirtyYardsBoundary,
          capsule: thirtyYardsProps.capsulness,
        );

        // Build children list based on z-order preference
        final List<Widget> stackChildren = [
          WagonWheelBoundaryWidgets.buildGroundCircle(
            stadiumBoundary: calculatedStadiumBoundary,
            groundBoundary: calculatedGroundBoundary,
            thirtyYardsBoundary: calculatedThirtyYardsBoundary,
            boundaryProperties: boundary,
            pitchProperties: pitch,
            isLeftHanded: widget.isLeftHanded,
          ),
        ];

        // Only show animations and highlighting if marker is enabled
        final effectiveSelectedSection =
            marker.enableMarker ? selectedSection : -1;
        final effectiveSplashAnimation =
            marker.enableMarker ? splashController : null;

        final labelsWidget = Center(
          child: CustomPaint(
            size: calculatedGroundBoundary,
            painter: WagonWheelPartitionPainter(
              radiusX: calculatedGroundBoundary.width / 2,
              radiusY: calculatedGroundBoundary.height / 2,
              isLeftHanded: widget.isLeftHanded,
              highlightedSection: effectiveSelectedSection,
              splashAnimation: effectiveSplashAnimation,
              textProperties: text,
              animationProperties: animation,
              boundaryLineProperties: boundaryLines,
              baseStartAngle: _getBaseStartAngle(),
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
        if (widget.staticMarkers != null && widget.staticMarkers!.isNotEmpty) {
          staticMarkersWidget = Stack(
            children: widget.staticMarkers!
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

        // Get batsman properties
        final batsman = pitch.batsman ?? const WagonWheelBatsmanProperties();

        // Build batsman widget if it should be above grid lines
        Widget? standaloneBatsmanWidget;
        if (batsman.aboveGridLines && batsman.show) {
          standaloneBatsmanWidget = Center(
            child: WagonWheelBatsmanBuilder.buildBatsman(
              pitchSize: pitchSize,
              batsmanProperties: batsman,
              isLeftHanded: widget.isLeftHanded,
            )!,
          );
        }

        // Build widget list based on z-order preferences
        // Z-order: labels -> static markers -> draggable marker -> batsman
        // Static markers render below draggable marker so draggable marker appears on top
        final labelsAboveMarker = labelConfig.labelsAboveMarker;
        if (batsman.aboveGridLines && standaloneBatsmanWidget != null) {
          // Batsman above grid lines: boundary -> grid -> static markers -> draggable marker -> batsman
          if (labelsAboveMarker) {
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
          if (labelsAboveMarker) {
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
            final numberOfSectors = _getNumberOfSectors();
            final labels = _getLabels(numberOfSectors);
            final label = section >= 0 && section < labels.length
                ? labels[section]
                : labels.isNotEmpty
                    ? labels[0]
                    : const WagonWheelSectorLabel(id: 'unknown', name: '');

            setState(() {
              _currentPhi = phi;
              _currentT = t;
              selectedSection = section;
            });
            splashController.forward(from: 0);

            // Notify user of marker position change
            widget.onMarkerPositionChanged?.call(phi, t, label);
          },
        ),
      ),
    );
  }
}
