import 'package:flutter/material.dart';

/// Configuration for image customization in the bottom sheet
class WagonWheelBottomSheetImageConfig {
  /// Width of the shot option images
  final double? width;

  /// Height of the shot option images
  final double? height;

  /// How the image should be fitted within its bounds
  final BoxFit? fit;

  /// Path to the placeholder image when shot option doesn't have imagePath
  /// Default: 'assets/icons/ic_batsman.svg'
  final String? placeholderPath;

  /// Color filter for the placeholder image
  final ColorFilter? placeholderColorFilter;

  const WagonWheelBottomSheetImageConfig({
    this.width,
    this.height,
    this.fit,
    this.placeholderPath,
    this.placeholderColorFilter,
  });
}
