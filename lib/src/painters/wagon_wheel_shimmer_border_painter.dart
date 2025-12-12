import 'package:flutter/material.dart';

/// Custom painter for drawing an animated shimmer border effect
///
/// Creates a border that animates around the perimeter of a rectangle
/// following the path: top-left → top-right → bottom-right → bottom-left → top-left
class WagonWheelShimmerBorderPainter extends CustomPainter {
  /// Animation progress (0.0 to 1.0)
  final double progress;

  /// Width of the border
  final double borderWidth;

  /// Colors for the shimmer gradient effect
  /// If null, uses a single color
  final List<Color>? shimmerColors;

  /// Base border color (used if shimmerColors is null)
  final Color borderColor;

  /// Size of the rectangle to draw border around
  final Size size;

  WagonWheelShimmerBorderPainter({
    required this.progress,
    required this.borderWidth,
    required this.size,
    this.shimmerColors,
    Color? borderColor,
  }) : borderColor = borderColor ?? Colors.teal;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final width = size.width;
    final height = size.height;

    // Offset by half border width to center the border on the edge
    final halfBorder = borderWidth / 2;
    final drawWidth = width - borderWidth;
    final drawHeight = height - borderWidth;
    final perimeter = 2 * (drawWidth + drawHeight);

    // Calculate current position along the perimeter
    final currentDistance = progress * perimeter;

    // Create path from top-left, going clockwise around the perimeter
    // Start at top-left corner, offset by half border width
    final path = Path();
    path.moveTo(halfBorder, halfBorder);

    if (currentDistance <= drawWidth) {
      // Top edge: left to right
      path.lineTo(halfBorder + currentDistance, halfBorder);
    } else if (currentDistance <= drawWidth + drawHeight) {
      // Top + Right edge
      path.lineTo(halfBorder + drawWidth, halfBorder); // Complete top edge
      final y = currentDistance - drawWidth;
      path.lineTo(halfBorder + drawWidth,
          halfBorder + y); // Right edge (top to current position)
    } else if (currentDistance <= 2 * drawWidth + drawHeight) {
      // Top + Right + Bottom edge
      path.lineTo(halfBorder + drawWidth, halfBorder); // Complete top edge
      path.lineTo(halfBorder + drawWidth,
          halfBorder + drawHeight); // Complete right edge
      final x = drawWidth - (currentDistance - drawWidth - drawHeight);
      path.lineTo(halfBorder + x,
          halfBorder + drawHeight); // Bottom edge (right to current position)
    } else {
      // All edges + part of left edge
      path.lineTo(halfBorder + drawWidth, halfBorder); // Complete top edge
      path.lineTo(halfBorder + drawWidth,
          halfBorder + drawHeight); // Complete right edge
      path.lineTo(halfBorder, halfBorder + drawHeight); // Complete bottom edge
      final y = drawHeight - (currentDistance - 2 * drawWidth - drawHeight);
      path.lineTo(
          halfBorder, halfBorder + y); // Left edge (bottom to current position)
    }

    // If progress is 1.0, complete the border by closing the path
    if (progress >= 1.0) {
      path.lineTo(halfBorder, halfBorder); // Close the path
    }

    // Create paint with shimmer effect or solid color
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (shimmerColors != null && shimmerColors!.isNotEmpty) {
      // Create gradient for shimmer effect
      final gradient = _createShimmerGradient();
      paint.shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, width, height),
      );
    } else {
      paint.color = borderColor;
    }

    canvas.drawPath(path, paint);
  }

  /// Create a gradient for shimmer effect based on current animation position
  LinearGradient? _createShimmerGradient() {
    if (shimmerColors == null || shimmerColors!.isEmpty) return null;

    // Create stops for smooth gradient transition
    final stops = shimmerColors!.length > 1
        ? List.generate(
            shimmerColors!.length,
            (index) => index / (shimmerColors!.length - 1),
          )
        : null;

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: shimmerColors!,
      stops: stops,
    );
  }

  @override
  bool shouldRepaint(WagonWheelShimmerBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.size != size ||
        oldDelegate.shimmerColors != shimmerColors ||
        oldDelegate.borderColor != borderColor;
  }
}
