import 'package:flutter/material.dart';

class AppTheme {
  // Shared constants for light theme
  static const lightSurface = Color(0xFFFFFFFF); // White
  static const lightScaffold = Color(0xFFF5F5F5); // Light Grey
  static const foregroundColor = Color(0xFF1A1A1A); // Near Black
  static const dividerColor = Color(0xFFE0E0E0); // Light Grey
  static const lightPrimary = Color(0xFFFFC107); // Amber Yellow
  static const lightSecondary = Color(0xFFFFECB3); // Light Yellow
  static const lightTertiary = Color(0xFF1A1A1A); // Near Black
  static const iconColor = Color(0xFFFFC107); // Amber Yellow

  // Dark mode constants
  static const darkScaffold = Color(0xFF1A1A1A); // Near Black
  static const darkSurface = Color(0xFF2A2A2A); // Dark Grey
  static const darkForeground = Color(0xFFFFFFFF); // White
  static const darkDividerColor = Color(0xFF424242); // Medium Grey
  static const darkIconColor = Color(0xFFFFECB3); // Light Yellow

  static ThemeData get lightTheme => getTheme(brightness: Brightness.light);
  static ThemeData get darkTheme => getTheme(brightness: Brightness.dark);

  // Unified ThemeData getter
  static ThemeData getTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isDark ? darkScaffold : lightScaffold,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: lightPrimary,
        onPrimary: isDark ? darkForeground : foregroundColor,
        secondary: lightSecondary,
        onSecondary: isDark ? darkForeground : foregroundColor,
        error: Colors.redAccent,
        onError: isDark ? darkForeground : foregroundColor,
        surface: isDark ? darkSurface : lightSurface,
        onSurface: isDark ? darkForeground : foregroundColor,
        tertiary: isDark ? darkForeground : lightTertiary,
      ),
      textTheme: _getTextTheme(isDark: isDark),
      elevatedButtonTheme: _getElevatedButtonTheme(isDark: isDark),
      dividerTheme: _getDividerTheme(isDark: isDark),
      iconTheme: _getIconTheme(isDark: isDark),
      cardTheme: _getCardTheme(isDark: isDark),
      visualDensity: VisualDensity.compact,
      bottomNavigationBarTheme: _getBottomNavigationBarTheme(isDark: isDark),
      radioTheme: _getRadioTheme(isDark: isDark),
      dataTableTheme: _getDataTableTheme(isDark: isDark),
      // Extensions removed
    );
  }

  // ElevatedButtonTheme
  static ElevatedButtonThemeData _getElevatedButtonTheme(
      {required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary, // Amber Yellow
        foregroundColor: Colors.white,
        disabledBackgroundColor: isDark ? Colors.grey[800] : Colors.grey,
        disabledForegroundColor: isDark ? Colors.grey : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          // Roboto default
        ),
      ),
    );
  }

  // TextTheme with default font (Roboto)
  static TextTheme _getTextTheme({required bool isDark}) {
    final textColor = isDark ? darkForeground : foregroundColor;
    return TextTheme(
      displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.25,
          color: textColor),
      displayMedium: TextStyle(
          fontSize: 45, fontWeight: FontWeight.w600, color: textColor),
      displaySmall: TextStyle(
          fontSize: 36, fontWeight: FontWeight.w500, color: textColor),
      headlineLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.w500, color: textColor),
      headlineMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w500, color: textColor),
      headlineSmall: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w500, color: textColor),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: textColor),
      titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: textColor),
      titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: textColor),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: textColor),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: textColor),
      bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: textColor),
      labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: textColor),
      labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: textColor),
      labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: textColor),
    );
  }

  // DividerTheme
  static DividerThemeData _getDividerTheme({required bool isDark}) {
    return DividerThemeData(
      color: isDark ? darkDividerColor : dividerColor,
      space: 0,
      thickness: 1,
    );
  }

  // IconTheme
  static IconThemeData _getIconTheme({required bool isDark}) {
    return IconThemeData(
      color: isDark ? darkIconColor : iconColor,
      size: 24,
    );
  }

  // CardTheme
  static CardTheme _getCardTheme({required bool isDark}) {
    return CardTheme(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  // BottomNavigationBarTheme
  static BottomNavigationBarThemeData _getBottomNavigationBarTheme(
      {required bool isDark}) {
    final textColor = isDark ? darkForeground : foregroundColor;
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      selectedItemColor: lightPrimary,
      unselectedItemColor: textColor,
      selectedLabelStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      elevation: 2,
      unselectedLabelStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    );
  }

  // RadioTheme
  static RadioThemeData _getRadioTheme({required bool isDark}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isDark ? Colors.grey[800] : Colors.grey;
        }
        if (states.contains(WidgetState.selected)) {
          return lightPrimary;
        }
        return isDark ? darkForeground : foregroundColor;
      }),
    );
  }

  static _getDataTableTheme({required bool isDark}) {
    return DataTableThemeData(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the table
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
