import 'package:cricket_wagon_wheel/src/models/wagon_wheel_sector_label.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_shot_option.dart';

/// Provides default shot options for each sector label
///
/// This utility class provides pre-built shot options for each sector.
/// Users can override defaults by providing custom options.
class WagonWheelShotOptionsProvider {
  // Private map of default shot options keyed by label ID
  static const Map<String, List<WagonWheelShotOption>> _defaultShotOptions = {
    'deep_point': [
      WagonWheelShotOption(id: 'defence', name: 'Defence'),
      WagonWheelShotOption(id: 'late_cut', name: 'Late Cut'),
      WagonWheelShotOption(id: 'cut_shot', name: 'Cut Shot'),
      WagonWheelShotOption(id: 'backfoot_punch', name: 'Backfoot Punch'),
      WagonWheelShotOption(id: 'square_drive', name: 'Square Drive'),
      WagonWheelShotOption(id: 'slash', name: 'Slash'),
      WagonWheelShotOption(id: 'upper_cut', name: 'Upper Cut'),
      WagonWheelShotOption(id: 'reverse_sweep', name: 'Reverse Sweep'),
    ],
    'third_man': [
      WagonWheelShotOption(id: 'late_cut', name: 'Late Cut'),
      WagonWheelShotOption(id: 'upper_cut', name: 'Upper Cut'),
      WagonWheelShotOption(id: 'outside_edge', name: 'Outside Edge'),
      WagonWheelShotOption(id: 'top_edge', name: 'Top Edge'),
      WagonWheelShotOption(id: 'reverse_sweep', name: 'Reverse Sweep'),
      WagonWheelShotOption(id: 'reverse_scoop', name: 'Reverse Scoop'),
    ],
    'deep_fine_leg': [
      WagonWheelShotOption(id: 'leg_glance', name: 'Leg Glance'),
      WagonWheelShotOption(id: 'inside_edge', name: 'Inside Edge'),
      WagonWheelShotOption(id: 'top_edge', name: 'Top Edge'),
      WagonWheelShotOption(id: 'pull', name: 'Pull'),
      WagonWheelShotOption(id: 'hook', name: 'Hook'),
      WagonWheelShotOption(id: 'dilscoop', name: 'Dilscoop'),
      WagonWheelShotOption(id: 'ramp_shot', name: 'Ramp Shot'),
    ],
    'deep_square_leg': [
      WagonWheelShotOption(id: 'flick', name: 'Flick'),
      WagonWheelShotOption(id: 'pull', name: 'Pull'),
      WagonWheelShotOption(id: 'punch', name: 'Punch'),
      WagonWheelShotOption(id: 'defence', name: 'Defence'),
      WagonWheelShotOption(id: 'inside_edge', name: 'Inside Edge'),
      WagonWheelShotOption(id: 'sweep', name: 'Sweep'),
    ],
    'deep_mid_wicket': [
      WagonWheelShotOption(id: 'flick', name: 'Flick'),
      WagonWheelShotOption(id: 'pull', name: 'Pull'),
      WagonWheelShotOption(id: 'lofted_shot', name: 'Lofted Shot'),
      WagonWheelShotOption(id: 'slog_sweep', name: 'Slog Sweep'),
      WagonWheelShotOption(id: 'drive', name: 'Drive'),
      WagonWheelShotOption(id: 'punch', name: 'Punch'),
      WagonWheelShotOption(id: 'helicopter', name: 'Helicopter'),
      WagonWheelShotOption(id: 'defence', name: 'Defence'),
    ],
    'long_on': [
      WagonWheelShotOption(id: 'defence', name: 'Defence'),
      WagonWheelShotOption(id: 'punch', name: 'Punch'),
      WagonWheelShotOption(id: 'straight_drive', name: 'Straight Drive'),
      WagonWheelShotOption(id: 'on_drive', name: 'On Drive'),
      WagonWheelShotOption(id: 'lofted_shot', name: 'Lofted Shot'),
      WagonWheelShotOption(id: 'helicopter', name: 'Helicopter'),
    ],
    'long_off': [
      WagonWheelShotOption(id: 'defence', name: 'Defence'),
      WagonWheelShotOption(id: 'punch', name: 'Punch'),
      WagonWheelShotOption(id: 'straight_drive', name: 'Straight Drive'),
      WagonWheelShotOption(id: 'off_drive', name: 'Off Drive'),
      WagonWheelShotOption(id: 'lofted_shot', name: 'Lofted Shot'),
      WagonWheelShotOption(id: 'helicopter', name: 'Helicopter'),
    ],
    'deep_cover': [
      WagonWheelShotOption(id: 'defence', name: 'Defence'),
      WagonWheelShotOption(id: 'punch', name: 'Punch'),
      WagonWheelShotOption(id: 'drive', name: 'Drive'),
      WagonWheelShotOption(id: 'backfoot_punch', name: 'Backfoot Punch'),
      WagonWheelShotOption(id: 'inside_out', name: 'Inside Out'),
      WagonWheelShotOption(id: 'switch_hit', name: 'Switch Hit'),
    ],
  };

  /// Get shot options for a given sector label
  ///
  /// If [customOptions] is provided, it will be used instead of defaults.
  /// Otherwise, returns the default shot options for the label.
  ///
  /// Returns an empty list if no defaults exist and no custom options provided.
  ///
  /// Example:
  /// ```dart
  /// // Use defaults
  /// final options = WagonWheelShotOptionsProvider.getShotOptionsForLabel(label);
  ///
  /// // Override with custom options
  /// final customOptions = WagonWheelShotOptionsProvider.getShotOptionsForLabel(
  ///   label,
  ///   customOptions: [WagonWheelShotOption(id: 'custom', name: 'Custom')],
  /// );
  /// ```
  static List<WagonWheelShotOption> getShotOptionsForLabel(
    WagonWheelSectorLabel label, {
    List<WagonWheelShotOption>? customOptions,
  }) {
    // If custom options provided, use those
    if (customOptions != null) {
      return customOptions;
    }

    // Otherwise, return defaults for this label
    return _defaultShotOptions[label.id] ?? [];
  }

  /// Merge default shot options with custom options
  ///
  /// Combines default shot options for a label with custom options.
  /// Custom options are appended to the defaults.
  ///
  /// If [preferCustom] is true, custom options with matching IDs will replace
  /// default options. Otherwise, defaults take precedence.
  ///
  /// Example:
  /// ```dart
  /// // Append custom options to defaults
  /// final merged = WagonWheelShotOptionsProvider.mergeShotOptions(
  ///   label,
  ///   customOptions: [WagonWheelShotOption(id: 'extra', name: 'Extra Shot')],
  /// );
  ///
  /// // Replace defaults with custom when IDs match
  /// final merged = WagonWheelShotOptionsProvider.mergeShotOptions(
  ///   label,
  ///   customOptions: [WagonWheelShotOption(id: 'defence', name: 'Custom Defence')],
  ///   preferCustom: true,
  /// );
  /// ```
  static List<WagonWheelShotOption> mergeShotOptions(
    WagonWheelSectorLabel label, {
    List<WagonWheelShotOption>? customOptions,
    bool preferCustom = false,
  }) {
    final defaults = _defaultShotOptions[label.id] ?? [];

    if (customOptions == null || customOptions.isEmpty) {
      return defaults;
    }

    if (preferCustom) {
      // Create a map of defaults by ID for quick lookup
      final defaultMap = {for (var option in defaults) option.id: option};

      // Separate custom options into replacements and new additions
      final additions = <WagonWheelShotOption>[];

      for (var custom in customOptions) {
        if (defaultMap.containsKey(custom.id)) {
          // Replace existing default
          defaultMap[custom.id] = custom;
        } else {
          // New option not in defaults
          additions.add(custom);
        }
      }

      // Return: defaults (with replacements) + new additions
      return [...defaultMap.values, ...additions];
    } else {
      // Simply append custom options to defaults
      return [...defaults, ...customOptions];
    }
  }

  /// Validate that shot options have unique IDs
  ///
  /// Returns a list of duplicate IDs found, or empty list if all are unique.
  ///
  /// Example:
  /// ```dart
  /// final duplicates = WagonWheelShotOptionsProvider.validateUniqueIds(options);
  /// if (duplicates.isNotEmpty) {
  ///   print('Duplicate IDs found: $duplicates');
  /// }
  /// ```
  static List<String> validateUniqueIds(List<WagonWheelShotOption> options) {
    final idCounts = <String, int>{};
    final duplicates = <String>[];

    for (var option in options) {
      idCounts[option.id] = (idCounts[option.id] ?? 0) + 1;
    }

    idCounts.forEach((id, count) {
      if (count > 1) {
        duplicates.add(id);
      }
    });

    return duplicates;
  }

  /// Get all default shot options as a map
  ///
  /// Useful for debugging or if you need to access all defaults at once.
  /// Returns a copy of the internal map.
  static Map<String, List<WagonWheelShotOption>> getAllDefaultShotOptions() {
    return Map.unmodifiable(_defaultShotOptions);
  }

  /// Check if default shot options exist for a given label ID
  static bool hasDefaultShotOptions(String labelId) {
    return _defaultShotOptions.containsKey(labelId);
  }
}
