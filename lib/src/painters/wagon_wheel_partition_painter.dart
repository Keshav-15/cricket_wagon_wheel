import 'dart:math' as math;

import 'package:cricket_wagon_wheel/src/models/wagon_wheel_animation_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_boundary_line_properties.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_sector_label.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_text_properties.dart';
import 'package:cricket_wagon_wheel/src/utils/wagon_wheel_constants.dart';
import 'package:flutter/material.dart';

/// Custom painter for drawing the wagon wheel sectors, labels, and animations
class WagonWheelPartitionPainter extends CustomPainter {
  final double radiusX;
  final double radiusY;
  final bool isLeftHanded;
  final int highlightedSection; // -1 means none
  final Animation<double>? splashAnimation;

  final WagonWheelTextProperties textProperties;
  final WagonWheelAnimationProperties animationProperties;
  final WagonWheelBoundaryLineProperties? boundaryLineProperties;
  final double baseStartAngle;
  final int numberOfSectors;
  final List<WagonWheelSectorLabel> labels;

  WagonWheelPartitionPainter({
    required this.radiusX,
    required this.radiusY,
    required this.isLeftHanded,
    required this.highlightedSection,
    required this.splashAnimation,
    required this.textProperties,
    required this.animationProperties,
    this.boundaryLineProperties,
    required this.baseStartAngle,
    required this.numberOfSectors,
    required this.labels,
  }) : super(repaint: splashAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final sectorAngle = (2 * math.pi) / numberOfSectors;

    for (int i = 0; i < numberOfSectors; i++) {
      final start = baseStartAngle + sectorAngle * i;
      final end = start + sectorAngle;

      // Draw background highlight for selected sector
      if (highlightedSection == i) {
        _drawSectorBackground(canvas, center, start, end);
      }

      _drawWedgeLines(canvas, center, start, end);
      _drawLabel(canvas, center, start, end, labels[i].name, i);

      if (highlightedSection == i) {
        _drawSplash(canvas, center, start, end);
      }
    }
  }

  // ------------------------------------------------------------
  // DRAW WEDGE LINES (SECTOR DIVIDERS)
  // ------------------------------------------------------------
  /// Draws the radial lines that divide the circle into sectors
  /// Lines are drawn from center to the boundary edge
  void _drawWedgeLines(Canvas canvas, Offset center, double start, double end) {
    // Calculate line endpoints on the ellipse boundary
    final p1 = Offset(
      center.dx + radiusX * math.cos(start),
      center.dy + radiusY * math.sin(start),
    );
    final p2 = Offset(
      center.dx + radiusX * math.cos(end),
      center.dy + radiusY * math.sin(end),
    );

    // Use configurable line properties or defaults
    final lineProps =
        boundaryLineProperties ?? const WagonWheelBoundaryLineProperties();
    final paint = Paint()
      ..color = lineProps.getEffectiveLineColor()
      ..strokeWidth = lineProps.getEffectiveLineWidth()
      ..strokeCap = lineProps.getEffectiveStrokeCap();

    // Draw lines from center to boundary
    canvas.drawLine(center, p1, paint);
    canvas.drawLine(center, p2, paint);
  }

  // ------------------------------------------------------------
  // LABEL RENDERING
  // ------------------------------------------------------------

  void _drawLabel(
    Canvas canvas,
    Offset center,
    double start,
    double end,
    String label,
    int index,
  ) {
    final midAngle = (start + end) / 2;

    // Position for label center (configurable)
    final minRadiusFactor = textProperties.textMinRadiusFactor ??
        WagonWheelConstants.defaultTextMinRadiusFactor;
    final maxRadiusFactor = textProperties.textRadiusFactor ??
        WagonWheelConstants.defaultTextRadiusFactor;

    // Ensure min is less than max, and clamp to valid range
    final effectiveMin = minRadiusFactor.clamp(0.0, 1.0);
    final effectiveMax = maxRadiusFactor.clamp(effectiveMin, 1.0);

    // Position label at max radius (outer positioning)
    final labelRadiusFactor = effectiveMax;

    final textRadiusX = radiusX * labelRadiusFactor;
    final textRadiusY = radiusY * labelRadiusFactor;

    final cx = center.dx + textRadiusX * math.cos(midAngle);
    final cy = center.dy + textRadiusY * math.sin(midAngle);
    final labelCenter = Offset(cx, cy);

    // Calculate base font size based on average radius
    // Formula: fontSize = averageRadius / fontSizeDivisor
    // The divisor (11) provides a reasonable default scaling factor
    final averageRadius = (radiusX + radiusY) / 2;
    const double fontSizeDivisor = 11.0;
    double baseFontSize = averageRadius / fontSizeDivisor;

    // Override with configurable value if provided
    baseFontSize = textProperties.baseFontSize ?? baseFontSize;

    // Split label into words for multi-line rendering
    // Each word becomes a separate line to prevent word breaking
    final words = label.split(' ');

    // Simple line breaking: one word per line
    // This ensures labels like "Deep Mid Wicket" render as:
    //   Deep
    //   Mid
    //   Wicket
    // Instead of breaking words mid-character
    final lines = <String>[];
    if (words.isEmpty) {
      return; // Skip rendering empty labels
    }
    lines.addAll(words);

    // Render each line separately at base font size - prevents any word breaking
    double totalHeight = 0;
    final linePainters = <TextPainter>[];

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;

      final linePainter = TextPainter(
        text: TextSpan(
          text: trimmedLine,
          style: _createTextStyle(baseFontSize),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 1, // CRITICAL: Single line prevents any word breaking
      );
      linePainter.layout(); // No maxWidth constraint - natural width

      totalHeight += linePainter.height;
      if (linePainters.isNotEmpty) {
        // Use configurable line spacing factor or default
        final lineSpacingFactor = textProperties.lineSpacingFactor ?? 0.2;
        totalHeight += baseFontSize * lineSpacingFactor;
      }

      linePainters.add(linePainter);
    }

    // Render all lines vertically centered
    double yOffset = -(totalHeight / 2);

    for (final linePainter in linePainters) {
      linePainter.paint(
        canvas,
        Offset(
          labelCenter.dx - linePainter.width / 2,
          labelCenter.dy + yOffset,
        ),
      );
      // Use configurable line spacing factor or default
      final lineSpacingFactor = textProperties.lineSpacingFactor ?? 0.2;
      yOffset += linePainter.height + baseFontSize * lineSpacingFactor;
    }
  }

  // ------------------------------------------------------------
  // TEXT STYLE HELPER
  // ------------------------------------------------------------

  TextStyle _createTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      color: textProperties.textColor ?? WagonWheelConstants.defaultTextColor,
      fontWeight: textProperties.textFontWeight ??
          WagonWheelConstants.defaultTextFontWeight,
    );
  }

  // ------------------------------------------------------------
  // SELECTED SECTOR BACKGROUND
  // ------------------------------------------------------------

  void _drawSectorBackground(
    Canvas canvas,
    Offset center,
    double start,
    double end,
  ) {
    final bgColor = animationProperties.selectedSectorBackgroundColor ??
        WagonWheelConstants.defaultSelectedSectorBackgroundColor;
    final bgOpacity = animationProperties.selectedSectorBackgroundOpacity ??
        WagonWheelConstants.defaultSelectedSectorBackgroundOpacity;

    final paint = Paint()
      ..color = bgColor.withValues(alpha: bgOpacity)
      ..style = PaintingStyle.fill;

    // Draw entire sector as background
    final path = Path();
    path.moveTo(center.dx, center.dy);

    // Draw arc along the sector edge
    // Use small angle increment (0.02 radians ≈ 1.15 degrees) for smooth curve
    const double angleIncrement = 0.02;
    for (double a = start; a <= end; a += angleIncrement) {
      final x = center.dx + radiusX * math.cos(a);
      final y = center.dy + radiusY * math.sin(a);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  // ------------------------------------------------------------
  // SPLASH ANIMATION
  // ------------------------------------------------------------

  void _drawSplash(Canvas canvas, Offset center, double start, double end) {
    if (splashAnimation == null) return;

    final curve = animationProperties.splashAnimationCurve ??
        WagonWheelConstants.defaultSplashAnimationCurve;
    final animatedProgress = curve.transform(splashAnimation!.value);

    final splashCol = animationProperties.splashColor ??
        WagonWheelConstants.defaultSplashColor;
    final maxRadiusFactor = animationProperties.splashMaxRadius ??
        WagonWheelConstants.defaultSplashMaxRadius;
    final maxOpacity = animationProperties.splashOpacity ??
        WagonWheelConstants.defaultSplashOpacity;

    // Material-like ripple: Fill entire sector with expanding/fading effect
    final currentRadiusFactor = animatedProgress * maxRadiusFactor;
    final currentOpacity = maxOpacity * (1 - animatedProgress);

    final paint = Paint()
      ..color = splashCol.withValues(alpha: currentOpacity)
      ..style = PaintingStyle.fill;

    // Create wedge-shaped path that fills the entire sector
    final path = Path();
    path.moveTo(center.dx, center.dy);

    // Draw arc from center to sector edge, expanding with animation progress
    // Use small angle increment for smooth curve rendering
    const double angleIncrement = 0.02;
    for (double a = start; a <= end; a += angleIncrement) {
      final x = center.dx + (radiusX * currentRadiusFactor) * math.cos(a);
      final y = center.dy + (radiusY * currentRadiusFactor) * math.sin(a);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WagonWheelPartitionPainter oldDelegate) => true;
}
