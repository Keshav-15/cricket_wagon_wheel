import 'dart:math';

import 'package:flutter/material.dart';

/// Draggable marker widget for the wagon wheel
///
/// Allows users to place and drag a marker on the circular field.
/// The marker position is represented in polar coordinates (phi, t):
/// - phi: angle in radians (0 to 2π)
/// - t: normalized radius from center (0.0 = center, 1.0 = border)
class DraggableMarker extends StatefulWidget {
  /// Horizontal radius of the ellipse (half of width)
  final double a;

  /// Vertical radius of the ellipse (half of height)
  final double b;

  /// Initial angle (phi) in radians for marker position
  /// If null, marker will not be visible until user interacts
  final double? initialPhi;

  /// Initial normalized radius (t) from 0.0 to 1.0
  /// 0.0 = center, 1.0 = border edge
  final double? initialT;

  /// Callback fired when marker drag ends
  /// Provides final (phi, t) coordinates
  final void Function(double phi, double t)? onDragEndPhiT;

  /// Whether marker should be locked to the border (t = 1.0)
  /// When true, marker can only move along the boundary edge
  final bool lockToBorder;

  /// Whether the marker is interactive (can be dragged)
  /// If false, marker will be rendered but cannot be dragged
  /// Useful for static/non-interactive markers
  final bool isInteractive;

  /// Color of the marker line (from center to marker position)
  final Color? lineColor;

  /// Width of the marker line
  final double? lineWidth;

  /// Color of the marker circle (end point handle)
  final Color? circleColor;

  /// Size (diameter) of the marker circle
  final double? circleSize;

  const DraggableMarker({
    super.key,
    required this.a,
    required this.b,
    this.initialPhi,
    this.initialT,
    this.onDragEndPhiT,
    this.lockToBorder = false,
    this.isInteractive = true,
    this.lineColor,
    this.lineWidth,
    this.circleColor,
    this.circleSize,
  });

  @override
  State<DraggableMarker> createState() => _DraggableMarkerState();
}

class _DraggableMarkerState extends State<DraggableMarker> {
  double? phi; // angle
  double t = 1; // radius factor

  @override
  void initState() {
    super.initState();

    // Only initialize if initialPhi is provided
    if (widget.initialPhi != null) {
      phi = widget.initialPhi;
      t = widget.initialT?.clamp(0.0, 1.0) ?? 1.0;
      if (widget.lockToBorder) t = 1.0;
    }
    // If initialPhi is null, phi remains null and marker won't render
  }

  /// Convert pixel drag point -> normalized (phi, t)
  void _setFromPoint(Offset p, {bool clampToBorder = false}) {
    final x = p.dx;
    final y = p.dy;

    // robust ellipse angle conversion
    phi = atan2(widget.a * y, widget.b * x);

    // ellipse boundary point at same phi
    final bx = widget.a * cos(phi!);
    final by = widget.b * sin(phi!);

    double computedT;
    if (bx.abs() > by.abs() && bx.abs() > 1e-9) {
      computedT = x / bx;
    } else if (by.abs() > 1e-9) {
      computedT = y / by;
    } else {
      computedT = 0.0;
    }

    t = computedT.isNaN ? 0.0 : computedT.clamp(0.0, 1.0);
    if (clampToBorder) t = 1.0;
  }

  /// Convert (phi,t) -> pixel Offset
  Offset? _currentOffset() {
    if (phi == null) return null;
    final px = widget.a * t * cos(phi!);
    final py = widget.b * t * sin(phi!);
    return Offset(px, py);
  }

  @override
  void didUpdateWidget(covariant DraggableMarker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle when initialPhi changes from null to a value or vice versa
    if (widget.initialPhi == null && oldWidget.initialPhi != null) {
      // Marker was hidden externally - clear phi
      if (phi != null) {
        setState(() => phi = null);
      }
    } else if (widget.initialPhi != null && oldWidget.initialPhi == null) {
      // Marker was shown externally - set initial position
      setState(() {
        phi = widget.initialPhi;
        t = widget.initialT?.clamp(0.0, 1.0) ?? 1.0;
        if (widget.lockToBorder) t = 1.0;
      });
    } else if (widget.initialPhi != null && oldWidget.initialPhi != null) {
      // Marker exists, update if values changed (but don't override user dragging)
      if (widget.initialPhi != oldWidget.initialPhi ||
          widget.initialT != oldWidget.initialT) {
        // Only update if user hasn't interacted (phi matches old initialPhi)
        if (phi == oldWidget.initialPhi) {
          setState(() {
            phi = widget.initialPhi;
            t = widget.initialT?.clamp(0.0, 1.0) ?? 1.0;
            if (widget.lockToBorder) t = 1.0;
          });
        }
      }
    }

    // if border lock toggled ON
    if (widget.lockToBorder && !oldWidget.lockToBorder && phi != null) {
      setState(() => t = 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final center = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );

        final markerWidget = phi == null
            ? SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              )
            : CustomPaint(
                size: Size.infinite,
                painter: _LinePainter(
                  center: center,
                  relativeEnd: _currentOffset(),
                  lineColor: widget.lineColor,
                  lineWidth: widget.lineWidth,
                  circleColor: widget.circleColor,
                  circleSize: widget.circleSize,
                ),
              );

        // Wrap with GestureDetector only if interactive
        if (widget.isInteractive) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) {
              final local = details.localPosition - center;
              setState(
                () => _setFromPoint(local, clampToBorder: widget.lockToBorder),
              );
            },
            onPanUpdate: (details) {
              final local = details.localPosition - center;
              setState(
                () => _setFromPoint(local, clampToBorder: widget.lockToBorder),
              );
            },
            onPanEnd: (_) {
              if (widget.onDragEndPhiT != null && phi != null) {
                widget.onDragEndPhiT!(phi!, t);
              }
            },
            child: markerWidget,
          );
        }

        // Non-interactive: just return the marker widget without gesture handling
        return markerWidget;
      },
    );
  }
}

/// Custom painter for drawing the marker line and circle
class _LinePainter extends CustomPainter {
  final Offset center;
  final Offset? relativeEnd;
  final Color? lineColor;
  final double? lineWidth;
  final Color? circleColor;
  final double? circleSize;

  /// Default styling values (used when properties not provided)
  static const Color _defaultLineColor = Colors.black;
  static const double _defaultLineWidth = 1.5;
  static const Color _defaultCircleColor = Colors.black;
  static const double _defaultCircleSize = 5.0;

  _LinePainter({
    required this.center,
    required this.relativeEnd,
    this.lineColor,
    this.lineWidth,
    this.circleColor,
    this.circleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (relativeEnd == null) return;

    final end = center + relativeEnd!;

    final finalLineColor = lineColor ?? _defaultLineColor;
    final finalLineWidth = lineWidth ?? _defaultLineWidth;
    final finalCircleColor = circleColor ?? _defaultCircleColor;
    final finalCircleSize = circleSize ?? _defaultCircleSize;

    final linePaint = Paint()
      ..color = finalLineColor
      ..strokeWidth = finalLineWidth
      ..strokeCap = StrokeCap.round;

    final handlePaint = Paint()
      ..color = finalCircleColor
      ..style = PaintingStyle.fill;

    // Draw line from center to marker position
    canvas.drawLine(center, end, linePaint);

    // Draw circle at marker position
    canvas.drawCircle(end, finalCircleSize / 2, handlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
