import 'package:flutter/foundation.dart';

/// Global animation manager to ensure only one animation is active at a time.
///
/// This singleton class manages animation state across all bottom sheet items
/// (shot cards and "None Of The Above" button). When a new animation starts,
/// any previously active animation is automatically stopped.
///
/// **Usage:**
/// ```dart
/// final manager = WagonWheelAnimationManager();
///
/// // Start animation
/// manager.startAnimation('shot_1');
///
/// // Check if animating
/// if (manager.isAnimating('shot_1')) {
///   // Animation is active
/// }
///
/// // Stop animation
/// manager.stopAnimation('shot_1');
/// ```
class WagonWheelAnimationManager extends ChangeNotifier {
  static final WagonWheelAnimationManager _instance =
      WagonWheelAnimationManager._internal();

  factory WagonWheelAnimationManager() => _instance;

  WagonWheelAnimationManager._internal();

  /// ID of the currently animating item (null if none)
  String? _activeAnimationId;

  /// Get the currently active animation ID
  String? get activeAnimationId => _activeAnimationId;

  /// Check if a specific item is currently animating
  bool isAnimating(String id) => _activeAnimationId == id;

  /// Check if any animation is active
  bool get hasActiveAnimation => _activeAnimationId != null;

  /// Start animation for a specific item
  /// Returns true if animation was started, false if another animation is active
  bool startAnimation(String id) {
    if (_activeAnimationId != null && _activeAnimationId != id) {
      // Another animation is active, stop it first
      stopAnimation(_activeAnimationId!);
    }
    _activeAnimationId = id;
    notifyListeners();
    return true;
  }

  /// Stop animation for a specific item
  void stopAnimation(String id) {
    if (_activeAnimationId == id) {
      _activeAnimationId = null;
      notifyListeners();
    }
  }

  /// Reset all animations
  void reset() {
    _activeAnimationId = null;
    notifyListeners();
  }
}
