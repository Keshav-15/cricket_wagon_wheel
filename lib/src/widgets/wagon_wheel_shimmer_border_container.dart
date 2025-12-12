import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_border_config.dart';
import 'package:cricket_wagon_wheel/src/painters/wagon_wheel_shimmer_border_painter.dart';
import 'package:cricket_wagon_wheel/src/utils/wagon_wheel_animation_manager.dart';
import 'package:flutter/material.dart';

/// A reusable container widget with animated shimmer border effect
///
/// This widget wraps any child with a container that has an animated border
/// that animates around the perimeter when tapped. Only one animation can be
/// active at a time across all instances (if animationId is provided).
class WagonWheelShimmerBorderContainer extends StatefulWidget {
  /// The child widget to display inside the container
  final Widget child;

  /// Callback when the container is tapped
  /// If this is an async function, the container will wait for it to complete
  /// before calling onComplete
  final Future<void> Function()? onTap;

  /// Callback called after both animation and onTap complete
  /// This is useful for closing modals or performing cleanup
  final VoidCallback? onComplete;

  /// Configuration for the shimmer border animation
  final WagonWheelBottomSheetBorderConfig borderConfig;

  /// Unique ID for animation management
  /// If provided, ensures only one animation is active at a time
  final String? animationId;

  /// Container decoration properties
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  /// Container size properties
  final double? width;
  final double? height;

  /// Static border properties (shown when not animating)
  final Color? staticBorderColor;
  final double? staticBorderWidth;

  const WagonWheelShimmerBorderContainer({
    super.key,
    required this.child,
    this.onTap,
    this.onComplete,
    required this.borderConfig,
    this.animationId,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.width,
    this.height,
    this.staticBorderColor,
    this.staticBorderWidth,
  });

  @override
  State<WagonWheelShimmerBorderContainer> createState() =>
      _WagonWheelShimmerBorderContainerState();
}

class _WagonWheelShimmerBorderContainerState
    extends State<WagonWheelShimmerBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _borderController;
  final _animationManager = WagonWheelAnimationManager();
  bool _isAnimating = false;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    final duration = widget.borderConfig.animationDuration ??
        const Duration(milliseconds: 600);
    _borderController = AnimationController(
      vsync: this,
      duration: duration,
    );
    _borderController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _animationCompleted = true;
          });
        }
      }
    });
    if (widget.animationId != null) {
      _animationManager.addListener(_onAnimationManagerChanged);
    }
  }

  @override
  void dispose() {
    if (widget.animationId != null) {
      _animationManager.removeListener(_onAnimationManagerChanged);
      _animationManager.stopAnimation(widget.animationId!);
    }
    _borderController.dispose();
    super.dispose();
  }

  void _onAnimationManagerChanged() {
    if (mounted && widget.animationId != null) {
      final isActive = _animationManager.isAnimating(widget.animationId!);
      if (!isActive && (_isAnimating || _animationCompleted)) {
        // Another animation started, reset this one
        setState(() {
          _isAnimating = false;
          _animationCompleted = false;
        });
        _borderController.reset();
      }
    }
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;

    // Check if we can start animation (only if no other animation is active or this one is active)
    if (widget.animationId == null ||
        !_animationManager.hasActiveAnimation ||
        _animationManager.isAnimating(widget.animationId!)) {
      // Start this animation
      if (widget.animationId != null) {
        _animationManager.startAnimation(widget.animationId!);
      }

      // Reset animation if already animating or completed
      if (_isAnimating || _animationCompleted) {
        _borderController.reset();
        setState(() {
          _isAnimating = true;
          _animationCompleted = false;
        });
      } else {
        setState(() {
          _isAnimating = true;
        });
      }

      // Wait for both animation and callback to complete
      await Future.wait([
        _borderController.forward(),
        widget.onTap!(),
      ]);

      // Call onComplete after both are done
      if (mounted) {
        widget.onComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderConfig = widget.borderConfig;
    final shouldShowAnimation = (_isAnimating || _animationCompleted) &&
        (widget.animationId == null ||
            _animationManager.isAnimating(widget.animationId!));

    return GestureDetector(
      onTap: () {
        _handleTap();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Container with content
          Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.transparent,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              border: shouldShowAnimation
                  ? null // No static border when animating or completed
                  : Border.all(
                      color: widget.staticBorderColor ?? Colors.grey[300]!,
                      width: widget.staticBorderWidth ?? 1.0,
                    ),
            ),
            child: widget.child,
          ),
          // Animated shimmer border (drawn at container level, not inside padding)
          if (shouldShowAnimation)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedBuilder(
                    animation: _borderController,
                    builder: (context, child) {
                      // Use 1.0 progress if animation is completed
                      final progress =
                          _animationCompleted ? 1.0 : _borderController.value;
                      return CustomPaint(
                        size: Size(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                        painter: WagonWheelShimmerBorderPainter(
                          progress: progress,
                          borderWidth: borderConfig.borderWidth ?? 2.5,
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          shimmerColors: borderConfig.shimmerColors ??
                              [Colors.teal, Colors.green, Colors.teal],
                          borderColor: borderConfig.borderColor,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
