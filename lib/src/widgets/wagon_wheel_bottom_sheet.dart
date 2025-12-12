import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_border_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_card_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_image_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_layout_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_bottom_sheet_text_config.dart';
import 'package:cricket_wagon_wheel/src/models/wagon_wheel_shot_option.dart';
import 'package:cricket_wagon_wheel/src/utils/package_constants.dart';
import 'package:cricket_wagon_wheel/src/widgets/wagon_wheel_shimmer_border_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Bottom sheet widget for shot selection with shimmer border animation
class WagonWheelBottomSheet {
  /// Show the bottom sheet with shot options
  static Future<void> show({
    required BuildContext context,
    required WagonWheelBottomSheetConfig config,
  }) {
    final layoutConfig =
        config.layoutConfig ?? const WagonWheelBottomSheetLayoutConfig();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: config.isDismissible,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) => _BottomSheetContent(
        config: config,
        layoutConfig: layoutConfig,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// Main content of the bottom sheet
class _BottomSheetContent extends StatelessWidget {
  final WagonWheelBottomSheetConfig config;
  final WagonWheelBottomSheetLayoutConfig layoutConfig;
  final VoidCallback onClose;

  const _BottomSheetContent({
    required this.config,
    required this.layoutConfig,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final imageConfig =
        config.imageConfig ?? const WagonWheelBottomSheetImageConfig();
    final textConfig =
        config.textConfig ?? const WagonWheelBottomSheetTextConfig();
    final cardConfig =
        config.cardConfig ?? const WagonWheelBottomSheetCardConfig();
    final borderConfig =
        config.borderConfig ?? const WagonWheelBottomSheetBorderConfig();

    // Calculate the maximum height (90% of screen or use maxChildSize)
    final maxHeight =
        MediaQuery.of(context).size.height * (layoutConfig.maxChildSize ?? 0.9);

    final isCardLayoutHorizontal =
        cardConfig.layoutDirection == WagonWheelCardLayoutDirection.horizontal;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 20),
            child: Text(
              config.title ?? 'Select Shot Type',
              style: textConfig.titleStyle ??
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          // Shot options grid - with internal scroll if needed
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: layoutConfig.crossAxisCount ?? 2,
                  crossAxisSpacing: layoutConfig.crossAxisSpacing ?? 12,
                  mainAxisSpacing: layoutConfig.mainAxisSpacing ?? 16,
                  childAspectRatio: layoutConfig.childAspectRatio ??
                      (isCardLayoutHorizontal ? 2 : 1.5),
                ),
                itemCount: config.shotOptions.length,
                itemBuilder: (context, index) {
                  final shotOption = config.shotOptions[index];
                  return _ShotOptionCard(
                    key: ValueKey('shot_${shotOption.id}'),
                    shotOption: shotOption,
                    imageConfig: imageConfig,
                    textConfig: textConfig,
                    cardConfig: cardConfig,
                    borderConfig: borderConfig,
                    animationId: 'shot_${shotOption.id}',
                    onTap: () async {
                      if (config.onShotSelected != null) {
                        await config.onShotSelected!(shotOption);
                      }
                    },
                    onComplete: onClose,
                  );
                },
              ),
            ),
          ),
          // None Of The Above button
          if (config.showNoneOption)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: WagonWheelShimmerBorderContainer(
                width: double.maxFinite,
                key: const ValueKey('none_button'),
                animationId: 'none_button',
                borderConfig: borderConfig,
                padding: const EdgeInsets.symmetric(vertical: 14),
                staticBorderColor: Colors.grey[300],
                staticBorderWidth: 1.0,
                onTap: () async {
                  if (config.onNoneSelected != null) {
                    await config.onNoneSelected!();
                  }
                },
                onComplete: onClose,
                child: Text(
                  config.noneOptionText ?? 'None of the above',
                  style: textConfig.noneButtonStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

/// Individual shot option card with shimmer border animation
class _ShotOptionCard extends StatelessWidget {
  final WagonWheelShotOption shotOption;
  final WagonWheelBottomSheetImageConfig imageConfig;
  final WagonWheelBottomSheetTextConfig textConfig;
  final WagonWheelBottomSheetCardConfig cardConfig;
  final WagonWheelBottomSheetBorderConfig borderConfig;
  final String animationId;
  final Future<void> Function() onTap;
  final VoidCallback? onComplete;

  const _ShotOptionCard({
    super.key,
    required this.shotOption,
    required this.imageConfig,
    required this.textConfig,
    required this.cardConfig,
    required this.borderConfig,
    required this.animationId,
    required this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // If custom builder provided, wrap it in the shimmer container
    if (shotOption.customBuilder != null) {
      return WagonWheelShimmerBorderContainer(
        animationId: animationId,
        borderConfig: borderConfig,
        margin: cardConfig.margin,
        padding: cardConfig.padding,
        backgroundColor: cardConfig.backgroundColor,
        borderRadius: cardConfig.borderRadius,
        staticBorderColor: cardConfig.borderColor,
        staticBorderWidth: cardConfig.borderWidth,
        onTap: onTap,
        onComplete: onComplete,
        child: shotOption.customBuilder!(context),
      );
    }

    // Build the content widget
    final content =
        cardConfig.layoutDirection == WagonWheelCardLayoutDirection.horizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image
                  shotOption.imagePath != null
                      ? Image.asset(
                          shotOption.imagePath!,
                          width: imageConfig.width ?? 60,
                          height: imageConfig.height ?? 60,
                          fit: imageConfig.fit ?? BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return _PlaceholderImage(
                              imageConfig: imageConfig,
                              isHorizontal: true,
                            );
                          },
                        )
                      : _PlaceholderImage(
                          imageConfig: imageConfig,
                          isHorizontal: true,
                        ),
                  SizedBox(width: cardConfig.spacing ?? 8),
                  // Title
                  Expanded(
                    child: Text(
                      shotOption.name,
                      textAlign: TextAlign.center,
                      style: textConfig.shotNameStyle ??
                          const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image
                  Expanded(
                    child: Center(
                      child: shotOption.imagePath != null
                          ? Image.asset(
                              shotOption.imagePath!,
                              width: imageConfig.width,
                              height: imageConfig.height,
                              fit: imageConfig.fit ?? BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return _PlaceholderImage(
                                  imageConfig: imageConfig,
                                );
                              },
                            )
                          : _PlaceholderImage(imageConfig: imageConfig),
                    ),
                  ),
                  SizedBox(height: cardConfig.spacing ?? 12),
                  // Title
                  Text(
                    shotOption.name,
                    textAlign: TextAlign.center,
                    style: textConfig.shotNameStyle ??
                        const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );

    return WagonWheelShimmerBorderContainer(
      animationId: animationId,
      borderConfig: borderConfig,
      margin: cardConfig.margin,
      padding: cardConfig.padding ??
          const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      backgroundColor: cardConfig.backgroundColor,
      borderRadius: cardConfig.borderRadius,
      staticBorderColor: cardConfig.borderColor,
      staticBorderWidth: cardConfig.borderWidth,
      onTap: onTap,
      onComplete: onComplete,
      child: content,
    );
  }
}

/// Placeholder image widget using ic_batsman.svg
class _PlaceholderImage extends StatelessWidget {
  final WagonWheelBottomSheetImageConfig imageConfig;
  final bool isHorizontal;

  const _PlaceholderImage({
    required this.imageConfig,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final placeholderPath = imageConfig.placeholderPath ??
        WagonWheelPackageConstants.defaultBatsmanIconPath;
    final width = imageConfig.width ?? 60;
    final height = imageConfig.height ?? 60;

    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        placeholderPath,
        width: width,
        height: height,
        colorFilter: imageConfig.placeholderColorFilter,
        fit: imageConfig.fit ?? BoxFit.contain,
      ),
    );
  }
}
