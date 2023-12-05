import 'package:flutter/painting.dart';

/// Returns a color based on the hash code of the given object.
Color getColorFromHashCode(Object object) => HSLColor.fromAHSL(
      1,
      object.hashCode % 360,
      0.2,
      0.5,
    ).toColor();
