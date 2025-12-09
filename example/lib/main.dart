import 'package:cricket_wagon_wheel/cricket_wagon_wheel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wagon Wheel Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WagonWheelExample(),
    );
  }
}

class WagonWheelExample extends StatefulWidget {
  const WagonWheelExample({super.key});

  @override
  State<WagonWheelExample> createState() => _WagonWheelExampleState();
}

class _WagonWheelExampleState extends State<WagonWheelExample> {
  double? lastPhi;
  double? lastT;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Wagon Wheel Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: WagonWheel(
                    config: WagonWheelConfig(
                      boundary: WagonWheelBoundaryProperties(
                        groundSize: 280,
                        stadiumBoundarySize: 20,
                        stadiumBoundaryColor: Colors.green,
                        groundBoundaryColor: Colors.amber,
                      ),
                      pitch: WagonWheelPitchProperties(
                        showBatsman: true,
                        batsmanAboveGridLines: true,
                        batsmanIconPath:
                            'assets/icons/ic_batsman.svg', // Using custom icon
                        showLegOffLabels: true,
                        circleIndicatorColor: Colors.amber,
                        pitchColor: Colors.lightGreen,
                      ),
                      marker: WagonWheelMarkerProperties(
                        initialPhi: 0.5,
                        initialT: 0.8,
                        markerLineColor: Colors.red,
                        markerCircleColor: Colors.red,
                        enableMarker: true,
                      ),
                    ),
                    onMarkerPositionChanged: (phi, t) {
                      setState(() {
                        lastPhi = phi;
                        lastT = t;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (lastPhi != null && lastT != null)
                  Text(
                    'Last marker position:\nPhi: ${lastPhi!.toStringAsFixed(2)}\nT: ${lastT!.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
