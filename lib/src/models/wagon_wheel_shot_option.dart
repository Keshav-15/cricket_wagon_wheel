import 'package:flutter/material.dart';

/// Represents a shot option that can be selected in the bottom sheet.
///
/// Each shot option has a unique [id] for identification and a [name] for display.
/// Optionally, you can provide an [imagePath] for a custom icon, or use a
/// [customBuilder] to completely customize the shot option's UI.
///
/// **Usage:**
/// ```dart
/// const shotOption = WagonWheelShotOption(
///   id: 'flick',
///   name: 'Flick',
///   imagePath: 'assets/icons/flick.svg',
/// );
///
/// // Or with custom builder
/// final customShot = WagonWheelShotOption(
///   id: 'custom',
///   name: 'Custom Shot',
///   customBuilder: (context) => YourCustomWidget(),
/// );
/// ```
class WagonWheelShotOption {
  /// Unique identifier for the shot option
  final String id;

  /// Display name of the shot (e.g., "Flick", "Pull", "Drive")
  final String name;

  /// Optional image path for the shot icon
  /// If null, a default placeholder will be shown
  final String? imagePath;

  /// Optional custom widget builder for this shot option
  /// If provided, will be used instead of default shot card UI
  final Widget Function(BuildContext context)? customBuilder;

  const WagonWheelShotOption({
    required this.id,
    required this.name,
    this.imagePath,
    this.customBuilder,
  });
}
