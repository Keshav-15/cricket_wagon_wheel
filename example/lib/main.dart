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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WagonWheel(
                  boundary: WagonWheelBoundaryProperties(
                    stadium: WagonWheelStadiumBoundaryProperties(
                      size: 25,
                      color: const Color(0xFF2E7D32), // Dark green
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    ground: WagonWheelGroundBoundaryProperties(
                      size: 400,
                      color: const Color(0xFFF9A825), // Amber
                      ovalness: 0.15,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    thirtyYards: WagonWheelThirtyYardsBoundaryProperties(
                      color: const Color(0xFF1976D2), // Blue
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    pitch: WagonWheelPitchProperties(
                      pitchConfig: WagonWheelPitchRectangleProperties(
                        color: const Color(0xFF8D6E63), // Brown
                        border: Border.all(color: Colors.white60, width: 1),
                      ),
                      circleIndicator: WagonWheelCircleIndicatorProperties(
                        show: true,
                        color: const Color(0xFF4CAF50), // Green
                        size: const Size(10, 10),
                      ),
                      batsman: WagonWheelBatsmanProperties(
                        show: true,
                        aboveGridLines: true,
                        iconPath: 'assets/icons/ic_batsman.svg',
                      ),
                      legOffLabel: WagonWheelLegOffLabelProperties(
                        show: true,
                        legText: 'LEG',
                        offText: 'OFF',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  label: WagonWheelLabelConfig(
                    properties: WagonWheelTextProperties(
                      textColor: Colors.white,
                      baseFontSize: 12,
                      textFontWeight: FontWeight.bold,
                    ),
                    labelsAboveMarker: false,
                  ),
                  sector: WagonWheelSectorConfig(
                    numberOfSectors: 8,
                    baseStartAngle: -3 * 3.14159 / 4, // -135 degrees
                    boundaryLines: WagonWheelBoundaryLineProperties(
                      lineColor: Colors.white,
                      lineOpacity: 0.6,
                      lineWidth: 1.5,
                    ),
                  ),
                  animation: WagonWheelAnimationProperties(
                    splashColor: Colors.white,
                    splashOpacity: 0.4,
                    selectedSectorBackgroundColor: Colors.white,
                    selectedSectorBackgroundOpacity: 0.2,
                  ),
                  marker: WagonWheelMarkerProperties(
                    enableMarker: true,
                    initialPhi: 0.8,
                    initialT: 0.75,
                    lockToBorder: false,
                    markerCircleSize: 6,
                    markerLineWidth: 2,
                    markerLineColor: const Color(0xFFD32F2F), // Red
                    markerCircleColor: const Color(0xFFD32F2F), // Red
                  ),
                  onMarkerPositionChanged: (phi, t) {
                    setState(() {
                      lastPhi = phi;
                      lastT = t;
                    });
                  },
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
