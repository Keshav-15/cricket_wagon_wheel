import 'package:cricket_wagon_wheel/cricket_wagon_wheel.dart';
import 'package:flutter/material.dart';

/// Example demonstrating the bottom sheet feature
/// This is a standalone example for testing the bottom sheet
class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bottom Sheet Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            WagonWheelBottomSheet.show(
              context: context,
              config: WagonWheelBottomSheetConfig(
                title: 'Select Shot Type (Deep Mid Wicket)',
                shotOptions: const [
                  WagonWheelShotOption(id: 'flick', name: 'Flick'),
                  WagonWheelShotOption(id: 'pull', name: 'Pull'),
                  WagonWheelShotOption(id: 'lofted_shot', name: 'Lofted Shot'),
                  WagonWheelShotOption(id: 'slog_sweep', name: 'Slog Sweep'),
                  WagonWheelShotOption(id: 'drive', name: 'Drive'),
                  WagonWheelShotOption(id: 'punch', name: 'Punch'),
                  WagonWheelShotOption(id: 'helicopter', name: 'Helicopter'),
                  WagonWheelShotOption(id: 'defence', name: 'Defence'),
                ],
                onShotSelected: (selectedOption) async {
                  debugPrint(
                    'Selected: ${selectedOption.name} (ID: ${selectedOption.id})',
                  );
                  Navigator.pop(context); // Close sheet
                },
                onNoneSelected: () async {
                  debugPrint('None selected');
                  Navigator.pop(context); // Close sheet
                },
                layoutConfig: WagonWheelBottomSheetLayoutConfig(
                  initialChildSize: 0.6,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                cardConfig: WagonWheelBottomSheetCardConfig(
                  layoutDirection:
                      WagonWheelCardLayoutDirection.horizontal, // Default
                ),
                borderConfig: WagonWheelBottomSheetBorderConfig(
                  shimmerColors: [Colors.teal, Colors.green, Colors.teal],
                  borderWidth: 2.5,
                  animationDuration: const Duration(milliseconds: 600),
                ),
              ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}
