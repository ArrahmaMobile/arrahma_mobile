import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class AppThemeUtils {
  static ThemeVariants getThemeVariants() {
    return ThemeVariants(
      light: _getTheme(false),
      dark: _getTheme(true),
    );
  }

  static AppThemeData _getTheme(bool isDark) {
    return ThemeUtils.getTheme(
      isDark,
      primaryColor: Colors.blue.shade400,
      accentColor: Colors.blue.shade600,
    );
  }
}
