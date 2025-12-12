import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_border_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_card_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_image_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_layout_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_text_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_shot_option.dart';

/// Configuration for the bottom sheet that appears for shot selection
class WagonWheelBottomSheetConfig {
  /// List of shot options to display in the grid
  final List<WagonWheelShotOption> shotOptions;

  /// Title for the bottom sheet
  /// If null, uses default: "Select Shot Type"
  final String? title;

  /// Callback when a shot option is selected
  /// Provides the selected WagonWheelShotOption
  /// This is an async function - the modal will close after both this callback
  /// and the animation complete
  final Future<void> Function(WagonWheelShotOption selectedOption)?
      onShotSelected;

  /// Whether to show "None Of The Above" option
  /// Default: true
  final bool showNoneOption;

  /// Callback when "None Of The Above" is tapped
  /// This is an async function - the modal will close after both this callback
  /// and the animation complete
  final Future<void> Function()? onNoneSelected;

  /// Text for "None Of The Above" button
  /// Default: "None Of The Above"
  final String? noneOptionText;

  /// Configuration for image customization
  final WagonWheelBottomSheetImageConfig? imageConfig;

  /// Configuration for text customization
  final WagonWheelBottomSheetTextConfig? textConfig;

  /// Configuration for card customization
  final WagonWheelBottomSheetCardConfig? cardConfig;

  /// Configuration for border animation customization
  final WagonWheelBottomSheetBorderConfig? borderConfig;

  /// Configuration for layout and grid properties
  final WagonWheelBottomSheetLayoutConfig? layoutConfig;

  /// Whether the bottom sheet can be dismissed by tapping outside
  /// Default: true
  final bool isDismissible;

  const WagonWheelBottomSheetConfig({
    required this.shotOptions,
    this.title,
    this.onShotSelected,
    this.showNoneOption = true,
    this.onNoneSelected,
    this.noneOptionText,
    this.imageConfig,
    this.textConfig,
    this.cardConfig,
    this.borderConfig,
    this.layoutConfig,
    this.isDismissible = true,
  });
}
