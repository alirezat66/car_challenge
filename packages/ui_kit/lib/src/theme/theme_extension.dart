import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  Color get primaryColor => theme.colorScheme.primary; // #FFC107 (Amber Yellow)
  Color get surface =>
      theme.colorScheme.surface; // Light: #FFFFFF, Dark: #2A2A2A
  Color get onSurface =>
      theme.colorScheme.onSurface; // Light: #1A1A1A, Dark: #FFFFFF
  TextTheme get textTheme => theme.textTheme;

  TextStyle get displayLarge => theme.textTheme.displayLarge!;
  TextStyle get displayMedium => theme.textTheme.displayMedium!;
  TextStyle get displaySmall => theme.textTheme.displaySmall!;

  TextStyle get headlineLarge => theme.textTheme.headlineLarge!;
  TextStyle get headlineMedium => theme.textTheme.headlineMedium!;
  TextStyle get headlineSmall => theme.textTheme.headlineSmall!;

  TextStyle get bodyLarge => theme.textTheme.bodyLarge!;
  TextStyle get bodyMedium => theme.textTheme.bodyMedium!;
  TextStyle get bodySmall => theme.textTheme.bodySmall!;

  TextStyle get titleLarge => theme.textTheme.titleLarge!;
  TextStyle get titleMedium => theme.textTheme.titleMedium!;
  TextStyle get titleSmall => theme.textTheme.titleSmall!;

  TextStyle get labelLarge => theme.textTheme.labelLarge!;
  TextStyle get labelMedium => theme.textTheme.labelMedium!;
  TextStyle get labelSmall => theme.textTheme.labelSmall!;
}
