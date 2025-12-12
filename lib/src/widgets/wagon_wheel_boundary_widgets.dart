import 'package:cricket_wagon_wheel/src/models/wagon_wheel_batsman_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_circle_indicator_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_ground_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_leg_off_label_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_pitch_rectangle_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_stadium_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_thirty_yards_boundary_properties.dart';
import 'package:cricket_wagon_wheel/src/utils/package_constants.dart';
import 'package:cricket_wagon_wheel/src/widgets/wagon_wheel_batsman_builder.dart';
import 'package:cricket_wagon_wheel/src/widgets/wagon_wheel_label_builder.dart';
import 'package:flutter/material.dart';

/// Widget builders for wagon wheel boundaries and pitch
///
/// This class provides static methods for building the visual elements
/// of the wagon wheel, including boundaries and the central pitch area.
class WagonWheelBoundaryWidgets {
  /// Build the complete ground circle with all boundaries
  ///
  /// Creates a layered structure with:
  /// - Stadium boundary (outermost)
  /// - Ground boundary (middle)
  /// - Thirty yards boundary (innermost)
  /// - Pitch (center)
  ///
  /// All boundaries are clipped to circular/oval shapes based on their properties.
  static Widget buildGroundCircle({
    required Size stadiumBoundary,
    required Size groundBoundary,
    required Size thirtyYardsBoundary,
    required WagonWheelBoundaryProperties boundaryProperties,
    required WagonWheelPitchProperties pitchProperties,
    required bool isLeftHanded,
  }) {
    // Calculate pitch size and spacing from pitch properties
    // Use height of thirty yards boundary as the reference diameter
    final thirtyYardsDiameter = thirtyYardsBoundary.height;
    final pitchSize = pitchProperties.calculatePitchSize(thirtyYardsDiameter);
    final pitchBorderSpacing = pitchProperties.calculateBorderSpacing(
      pitchSize,
    );
    // Get categorized boundary properties with defaults
    final stadiumProps = boundaryProperties.stadium ??
        const WagonWheelStadiumBoundaryProperties();
    final groundProps =
        boundaryProperties.ground ?? const WagonWheelGroundBoundaryProperties();
    final thirtyYardsProps = boundaryProperties.thirtyYards ??
        const WagonWheelThirtyYardsBoundaryProperties();

    // Build boundaries with borders and ClipOval for proper clipping
    // Borders are applied on containers that wrap ClipOval to ensure borders are visible
    return _buildOvalContainer(
      size: stadiumBoundary,
      color: stadiumProps.size <= 0 ? Colors.transparent : stadiumProps.color,
      border: stadiumProps.border,
      child: _buildOvalContainer(
        size: groundBoundary,
        color: groundProps.color,
        border: groundProps.border,
        child: _buildBaseContainer(
          size: thirtyYardsBoundary,
          color: thirtyYardsProps.color,
          borderRadius: BorderRadius.circular(thirtyYardsBoundary.height / 2),
          border: thirtyYardsProps.border,
          child: _buildPitch(
            thirtyYardsBoundary: thirtyYardsBoundary,
            pitchSize: pitchSize,
            pitchBorderSpacing: pitchBorderSpacing,
            pitchProperties: pitchProperties,
            groundBoundarySize: groundBoundary,
            isLeftHanded: isLeftHanded,
          ),
        ),
      ),
    );
  }

  /// Build pitch widget with borders, batsman, and labels
  ///
  /// Constructs the central pitch area including:
  /// - Circle indicator (optional, above pitch)
  /// - Pitch rectangle (brown/beige colored)
  /// - Batsman icon (if enabled and not above grid lines)
  /// - LEG/OFF labels (positioned outside pitch on sides)
  ///
  /// If [customPitchBuilder] is provided in pitchProperties, it will be used instead.
  static Widget _buildPitch({
    required Size thirtyYardsBoundary,
    required Size pitchSize,
    required double pitchBorderSpacing,
    required WagonWheelPitchProperties pitchProperties,
    required Size groundBoundarySize,
    required bool isLeftHanded,
  }) {
    // Get categorized properties with defaults
    final pitchConfig = pitchProperties.pitchConfig ??
        const WagonWheelPitchRectangleProperties();
    final circleIndicator = pitchProperties.circleIndicator ??
        const WagonWheelCircleIndicatorProperties();
    final batsman =
        pitchProperties.batsman ?? const WagonWheelBatsmanProperties();
    final legOffLabel =
        pitchProperties.legOffLabel ?? const WagonWheelLegOffLabelProperties();

    // If custom builder provided, use it
    if (pitchConfig.customBuilder != null) {
      return pitchConfig.customBuilder!(pitchSize, groundBoundarySize);
    }

    final pitchColor = pitchConfig.color ??
        const Color(0xFFD4A574); // Default beige/brown pitch color

    // Circle indicator spacing
    final circleSpacing = circleIndicator.spacing ?? pitchBorderSpacing;

    return SizedBox(
      width: thirtyYardsBoundary
          .width, // Wider container to accommodate side labels
      height: thirtyYardsBoundary.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pitch structure - circle indicator and rectangle (centered)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle indicator (if enabled)
                if (circleIndicator.show) ...[
                  _buildBaseContainer(
                    color: circleIndicator.effectiveColor,
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    size: circleIndicator.effectiveSize,
                    shape: BoxShape.circle,
                  ),
                  SizedBox(height: circleSpacing * 2),
                ],
                // Pitch rectangle
                _buildBaseContainer(
                  size: pitchSize,
                  color: pitchColor,
                  borderRadius: BorderRadius.circular(4),
                  border: pitchConfig.border,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          // Build batsman widget if it should be below grid lines
          if (batsman.show && !batsman.aboveGridLines)
            Center(
              child: WagonWheelBatsmanBuilder.buildBatsman(
                pitchSize: pitchSize,
                batsmanProperties: batsman,
                isLeftHanded: isLeftHanded,
              ),
            ),
          // LEG/OFF labels - positioned outside pitch on sides (only if enabled)
          if (legOffLabel.show)
            Center(
              child: WagonWheelLabelBuilder.buildLegOffLabels(
                    pitchSize: pitchSize,
                    groundBoundarySize: groundBoundarySize,
                    legText: legOffLabel.legText,
                    offText: legOffLabel.offText,
                    color: legOffLabel.color,
                    fontSize: legOffLabel.fontSize,
                    fontWeight: legOffLabel.fontWeight,
                    isLeftHanded: isLeftHanded,
                    showLabels: legOffLabel.show,
                  ) ??
                  const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  /// Build boundary with border and ClipOval
  /// This ensures borders are visible while content is properly clipped
  /// The border is applied on the outer container, and ClipOval clips the inner content
  static Widget _buildOvalContainer({
    required Size size,
    Color? color,
    BoxBorder? border,
    BorderRadius? borderRadius,
    required Widget child,
    EdgeInsetsGeometry? margin,
    BoxShape shape = BoxShape.rectangle,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final borderTop = border?.top;
    final borderBottom = border?.bottom;

    final borderColor =
        borderTop?.color ?? borderBottom?.color ?? Colors.transparent;
    final borderSize = borderTop?.width ?? borderBottom?.width ?? 0.0;

    return ClipOval(
      child: Container(
        color: borderColor,
        padding: EdgeInsets.all(borderSize),
        child: ClipOval(
          child: _buildBaseContainer(
            alignment: alignment,
            borderRadius: borderRadius,
            child: child,
            color: color,
            margin: margin,
            shape: shape,
            size: size,
          ),
        ),
      ),
    );
  }

  /// Build base container with styling
  static Container _buildBaseContainer({
    Size? size,
    Widget? child,
    BorderRadius? borderRadius,
    Color? color,
    EdgeInsetsGeometry? margin,
    BoxBorder? border,
    BoxShape shape = BoxShape.rectangle,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return Container(
      alignment: alignment,
      width: size?.width,
      height: size?.height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ??
            WagonWheelPackageConstants.defaultPrimaryColor.withValues(
              alpha: 0.2,
            ),
        borderRadius: borderRadius,
        shape: shape,
        border: border,
      ),
      child: child,
    );
  }
}
