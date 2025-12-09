import 'package:flutter/material.dart';

/// Configuration for stadium, ground, and thirty yards boundaries
class WagonWheelBoundaryProperties {
  // Stadium Boundary
  final double stadiumBoundarySize;
  final Color? stadiumBoundaryColor;
  final Border? stadiumBoundaryBorder;

  // Ground Boundary
  final double? groundSize;
  final double groundBoundaryOvalness;
  final Color? groundBoundaryColor;
  final Border? groundBoundaryBorder;

  // Thirty Yards Boundary
  final double? thirtyYardsSize;
  final double thirtyYardsBoundaryCapsulness;
  final Color? thirtyYardsBoundaryColor;
  final Border? thirtyYardsBoundaryBorder;

  const WagonWheelBoundaryProperties({
    this.stadiumBoundarySize = 0.0,
    this.stadiumBoundaryColor,
    this.stadiumBoundaryBorder,
    this.groundSize,
    this.groundBoundaryOvalness = 0.0,
    this.groundBoundaryColor,
    this.groundBoundaryBorder,
    this.thirtyYardsSize,
    this.thirtyYardsBoundaryCapsulness = 0.25,
    this.thirtyYardsBoundaryColor,
    this.thirtyYardsBoundaryBorder,
  });
}
