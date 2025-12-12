/// Configuration for bottom sheet layout and grid properties
class WagonWheelBottomSheetLayoutConfig {
  /// Initial child size for DraggableScrollableSheet (0.0 to 1.0)
  /// Default: 0.6
  final double? initialChildSize;

  /// Minimum child size for DraggableScrollableSheet (0.0 to 1.0)
  /// Default: 0.3
  final double? minChildSize;

  /// Maximum child size for DraggableScrollableSheet (0.0 to 1.0)
  /// Default: 0.9
  final double? maxChildSize;

  /// Number of columns in the grid
  /// Default: 2
  final int? crossAxisCount;

  /// Spacing between columns
  /// Default: 12
  final double? crossAxisSpacing;

  /// Spacing between rows
  /// Default: 16
  final double? mainAxisSpacing;

  /// Aspect ratio for grid items (width / height)
  /// Default: 0.75
  final double? childAspectRatio;

  const WagonWheelBottomSheetLayoutConfig({
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
  });
}
