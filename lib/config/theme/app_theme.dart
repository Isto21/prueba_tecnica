import 'package:flutter/material.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';

const Color _customColor = Colors.green;

class AppTheme {
  final int selectedColor;
  final int isDark;

  AppTheme({this.selectedColor = 0, this.isDark = Consts.darkMode});

  ThemeData theme() {
    return _theme(isDark);
  }

  ThemeData themeLight() {
    return _theme(Consts.lightMode);
  }

  ThemeData themeDark() {
    return _theme(Consts.darkMode);
  }

  ThemeData _theme(int isDarkMode) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _customColor,
      brightness: (isDarkMode == Consts.darkMode)
          ? Brightness.dark
          : (isDarkMode == Consts.lightMode)
              ? Brightness.light
              : WidgetsBinding.instance.platformDispatcher.platformBrightness,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        // elevation: 20,
      ),
    );
  }

  AppTheme copyWith({
    int? selectedColor,
    int? isDark,
  }) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDark: isDark ?? this.isDark,
    );
  }
}
