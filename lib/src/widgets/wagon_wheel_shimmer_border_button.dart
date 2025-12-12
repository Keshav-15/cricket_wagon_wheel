import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_border_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_shimmer_button_config.dart';
import 'package:cricket_wagon_wheel/src/painters/wagon_wheel_shimmer_border_painter.dart';
import 'package:cricket_wagon_wheel/src/utils/wagon_wheel_animation_manager.dart';
import 'package:flutter/material.dart';

/// A reusable button widget with animated shimmer border effect
///
/// This widget can be used independently in any part of your app.
/// It provides a customizable button with an animated border that
/// animates around the perimeter when tapped.
class WagonWheelShimmerBorderButton extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// Callback when the button is tapped
  final VoidCallback? onTap;

  /// Configuration for the shimmer border animation
  final WagonWheelBottomSheetBorderConfig borderConfig;

  /// Configuration for button appearance and layout
  final WagonWheelShimmerButtonConfig? buttonConfig;

  /// Optional custom child widget
  /// If provided, this will be used instead of the default text
  final Widget? child;

  /// Unique ID for animation management
  /// If provided, ensures only one animation is active at a time
  final String? animationId;

  const WagonWheelShimmerBorderButton({
    super.key,
    required this.text,
    this.onTap,
    required this.borderConfig,
    this.buttonConfig,
    this.child,
    this.animationId,
  });

  @override
  State<WagonWheelShimmerBorderButton> createState() =>
      _WagonWheelShimmerBorderButtonState();
}

class _WagonWheelShimmerBorderButtonState
    extends State<WagonWheelShimmerBorderButton>
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

  void _handleTap() {
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

      _borderController.forward().then((_) {
        if (mounted) {
          widget.onTap?.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = widget.buttonConfig;
    final borderConfig = widget.borderConfig;
    final shouldShowAnimation = (_isAnimating || _animationCompleted) &&
        (widget.animationId == null ||
            _animationManager.isAnimating(widget.animationId!));

    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Container with content
          Container(
            width: buttonConfig?.width ?? double.infinity,
            height: buttonConfig?.height,
            margin: buttonConfig?.margin,
            padding: buttonConfig?.padding ??
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: buttonConfig?.backgroundColor ?? Colors.transparent,
              borderRadius:
                  buttonConfig?.borderRadius ?? BorderRadius.circular(8),
              border: shouldShowAnimation
                  ? null // No static border when animating or completed
                  : Border.all(
                      color:
                          buttonConfig?.staticBorderColor ?? Colors.grey[300]!,
                      width: buttonConfig?.staticBorderWidth ?? 1.0,
                    ),
            ),
            child: Center(
              child: widget.child ??
                  Text(
                    widget.text,
                    style: buttonConfig?.textStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                    textAlign: TextAlign.center,
                  ),
            ),
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
