/// Represents a sector label in the wagon wheel with a unique identifier and display name.
///
/// This class provides type-safe identification of sectors, allowing for:
/// - Unique identification via [id] (e.g., 'deep_mid_wicket', 'third_man')
/// - Display text via [name] (e.g., 'Deep Mid Wicket', 'Third Man')
/// - Equality comparison based on [id] only
///
/// **Usage:**
/// ```dart
/// const label = WagonWheelSectorLabel(
///   id: 'deep_mid_wicket',
///   name: 'Deep Mid Wicket',
/// );
///
/// // Use id for comparisons
/// if (label.id == 'deep_mid_wicket') {
///   // Handle specific sector
/// }
///
/// // Use name for display
/// Text(label.name); // Displays: "Deep Mid Wicket"
/// ```
class WagonWheelSectorLabel {
  /// Unique identifier for the sector label
  /// Used for comparisons and identification
  final String id;

  /// Display name of the sector label
  /// Shown on the wagon wheel UI
  final String name;

  const WagonWheelSectorLabel({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WagonWheelSectorLabel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}
