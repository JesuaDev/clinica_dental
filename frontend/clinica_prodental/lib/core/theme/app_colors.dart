import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF237227);
  static const Color onDarkPrimary = Color(0xFF02020c);

  static const List<Color> colors = [
    Color(0xFFE9B005),
    Color(0XFFbf453a),
    Color.fromARGB(255, 145, 140, 223),
    Color(0xFF3e3aa9),
    Color(0XFF377bc4),
    Color(0xFFD21312)
  ];

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'sora-regular',
    brightness: Brightness.light,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> state,
      ) {
        if (state.contains(WidgetState.hovered) ||
            state.contains(WidgetState.selected)) {
          return Colors.white70;
        }

        return Colors.white;
      }),
    ),

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Color(0xFFFBFBFD),

      secondary: Color(0xFFE9EDF3),
      onSecondary: Color(0xFF111827),

      tertiary: Color(0XFFFFF6F6),

      error: Colors.red,
      onError: Colors.white,

      surface: Colors.white,
      onSurface: Colors.black,
    ),

    scaffoldBackgroundColor: const Color(0xFFF6F7F9),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'sora-regular',
    brightness: Brightness.dark,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: onDarkPrimary,

      secondary: Color(0xFF1c1e2a),
      onSecondary: Colors.white,

      tertiary: Color(0xFFB0B0B0),

      error: Colors.red,
      onError: Colors.black,

      surface: Color(0xFF121212),
      onSurface: Colors.white,
    ),

    scaffoldBackgroundColor: const Color(0xFF0E0E0E),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor,
    ),
  );
}
