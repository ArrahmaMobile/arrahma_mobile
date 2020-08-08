import 'package:flutter/material.dart';

class ColorUtils {
  static Color getTextColorByBackgroundLuminance(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}
