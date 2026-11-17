import 'package:flutter/material.dart';

extension AppColorScheme on ColorScheme {
  Color get red => const Color(0xFFFF6150);

  Color get main => const Color(0xFF7E00FC);

  Color get deepPurple => const Color(0xFF18131F);

  Color get deepPurpleBackground => const Color(0xFF240D45);

  Color get swipeBackground => const Color(0xFF160E1D);

  Color get fieldText => const Color(0xFF4B4B4B);

  Color get yellow => const Color(0xFFF9C84B);

  Color get yellowAccent => const Color(0xFFE9BE50);

  Color get yellowLight => const Color(0xFFF7D274);

  Color get disabledYellow => const Color(0xFF8B7849);

  Color get green => const Color(0xFF82DF26);

  Color get iconColor => const Color(0xFF8F92A1);

  Color get darkBackground => const Color(0xFF161616);

  Color get greyTextColor => const Color(0xFF929292);

  Color get backgroundGrey => const Color(0xFF2E2E2E);

  Color get iconGrey => const Color(0xFF999999);

  Color get charcoal => const Color(0xFF211929);

  Color get darkBlue => const Color(0xFF0E0D32);

  Color get lightBlue => const Color(0xFF083B72);

  Color get homeBackground1 => const Color(0xFF181818);

  Color get homeBackground2 => const Color(0xFF1E1E1E);
}

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1A1A1A),
  onPrimary: Color(0xFF121212),
  primaryContainer: Color(0xFF242424),
  onPrimaryContainer: Color(0xFF1C1C1C),
  secondary: Color(0xFF4C4C4C),
  onSecondary: Color(0xFFBBBBBB),
  secondaryContainer: Color(0xFFEFEFEF),
  onSecondaryContainer: Color(0xFF2A2A2A),
  tertiary: Color(0xFF868686),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFEBEBEB),
  onTertiaryContainer: Color(0xFF9F9F9F),
  error: Color(0xFFFF7373),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFE04E39),
  onErrorContainer: Color(0xFFBC3030),
  onSurface: Color(0xFF2E2E2E),
  surface: Color(0xFFFFFFFF),
  surfaceContainerHighest: Color(0xFF1E1E1E),
  onSurfaceVariant: Color(0xFF4F4F4F),
  outline: Color(0xFF272727),
);
