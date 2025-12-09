/// A Flutter package for displaying interactive cricket wagon wheel diagrams.
///
/// The wagon wheel is a circular visualization of a cricket field divided into
/// sectors representing different fielding positions. It includes:
/// - Circular boundaries (stadium, ground, thirty yards)
/// - Central pitch with batsman icon
/// - Sector lines dividing the field
/// - Fielding position labels
/// - Draggable marker for shot placement
/// - Static markers for historical shot placements
///
/// This library provides a highly customizable and configurable widget
/// for integrating wagon wheel functionality into Flutter applications.
library cricket_wagon_wheel;

export 'src/models/wagon_wheel_animation_properties.dart';
export 'src/models/wagon_wheel_batsman_properties.dart';
export 'src/models/wagon_wheel_boundary_line_properties.dart';
export 'src/models/wagon_wheel_boundary_properties.dart';
export 'src/models/wagon_wheel_circle_indicator_properties.dart';
export 'src/models/wagon_wheel_ground_boundary_properties.dart';
export 'src/models/wagon_wheel_label_config.dart';
export 'src/models/wagon_wheel_leg_off_label_properties.dart';
export 'src/models/wagon_wheel_marker_properties.dart';
export 'src/models/wagon_wheel_pitch_properties.dart';
export 'src/models/wagon_wheel_pitch_rectangle_properties.dart';
export 'src/models/wagon_wheel_sector_config.dart';
export 'src/models/wagon_wheel_stadium_boundary_properties.dart';
export 'src/models/wagon_wheel_text_properties.dart';
export 'src/models/wagon_wheel_thirty_yards_boundary_properties.dart';
export 'src/widgets/wagon_wheel_widget.dart';
