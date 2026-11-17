import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/no_splash_factory.dart';

const String _karlaFM = 'Karla';

final TextTheme _textTheme = TextTheme(
  displayLarge: const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 57,
    height: 1.12,
    fontFamily: _karlaFM,
  ),
  displayMedium: const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 28,
    height: 1.16,
    fontFamily: _karlaFM,
  ),
  displaySmall: const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.22,
    fontFamily: _karlaFM,
  ),
  headlineLarge: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 1.25,
    fontFamily: _karlaFM,
  ),
  headlineMedium: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.29,
    color: Colors.white,
    fontFamily: _karlaFM,
  ),
  headlineSmall: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: Colors.white,
    height: 1.33,
    fontFamily: _karlaFM,
  ),
  titleLarge: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.27,
    color: Colors.white,
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color: lightColorScheme.fieldText,
    letterSpacing: 0.15,
    fontFamily: _karlaFM,
  ),
  titleSmall: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.1,
    fontFamily: _karlaFM,
  ),
  labelLarge: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.5,
    letterSpacing: 0.15,
    fontFamily: _karlaFM,
  ),
  labelMedium: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.33,
    color: Colors.white,
    letterSpacing: 0.5,
    fontFamily: _karlaFM,
  ),
  labelSmall: const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.45,
    letterSpacing: 0.5,
    fontFamily: _karlaFM,
  ),
  bodyLarge: const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.white,
    height: 1.5,
    letterSpacing: 0.5,
    fontFamily: _karlaFM,
  ),
  bodyMedium: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 13,
    height: 1.43,
    color: Colors.white,
    letterSpacing: 0.25,
    fontFamily: _karlaFM,
  ),
  bodySmall: const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.4,
    fontFamily: _karlaFM,
    color: Colors.white70,
  ),
);

ElevatedButtonThemeData getMainElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.main,
      foregroundColor: Colors.white,
      disabledBackgroundColor: lightColorScheme.deepPurple,
      disabledForegroundColor: Colors.white54,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      textStyle: _textTheme.titleSmall?.copyWith(color: Colors.white),
    ),
  );
}

ElevatedButtonThemeData getWelcomeElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.yellowLight,
      foregroundColor: lightColorScheme.fieldText,
      disabledBackgroundColor: lightColorScheme.disabledYellow,
      disabledForegroundColor: lightColorScheme.fieldText,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      textStyle: _textTheme.titleSmall?.copyWith(
        color: lightColorScheme.fieldText,
      ),
    ),
  );
}

ElevatedButtonThemeData getRemoveElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.onSurface,
      foregroundColor: lightColorScheme.yellowLight,
      disabledBackgroundColor: lightColorScheme.onSurface,
      disabledForegroundColor: lightColorScheme.yellowLight,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      textStyle: _textTheme.titleSmall?.copyWith(
        color: lightColorScheme.fieldText,
      ),
    ),
  );
}

ElevatedButtonThemeData getSimpleElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.onSurface,
      foregroundColor: Colors.white,
      disabledBackgroundColor: lightColorScheme.onSurface,
      disabledForegroundColor: Colors.white,
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      textStyle: _textTheme.titleSmall?.copyWith(
        color: Colors.white,
      ),
    ),
  );
}

final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
  labelStyle: TextStyle(
    fontSize: 16,
    color: lightColorScheme.fieldText,
    fontWeight: FontWeight.w700,
  ),
  contentPadding: const EdgeInsets.all(16),
  errorStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: lightColorScheme.onErrorContainer,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: const BorderSide(width: 0),
  ),
  filled: true,
  fillColor: Colors.white,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: const BorderSide(width: 0),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: const BorderSide(width: 0),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: BorderSide(
      color: lightColorScheme.onErrorContainer,
      width: 2,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(52),
    borderSide: BorderSide(
      color: lightColorScheme.onErrorContainer,
      width: 2,
    ),
  ),
  hintStyle: TextStyle(
    fontSize: 16,
    color: lightColorScheme.fieldText.withValues(alpha:.5),
    fontWeight: FontWeight.w400,
  ),
);

final TabBarTheme tabBarTheme = TabBarTheme(
  indicatorColor: lightColorScheme.main,
  labelPadding: const EdgeInsets.all(4),
  labelStyle: _textTheme.titleSmall,
  labelColor: Colors.white,
  dividerColor: Colors.white,
  unselectedLabelColor: Colors.white,
  unselectedLabelStyle: _textTheme.titleSmall,
);

final AppBarTheme appBarTheme = AppBarTheme(
  color: lightColorScheme.surfaceContainerHighest,
  elevation: 1,
  systemOverlayStyle: SystemUiOverlayStyle.light,
  shadowColor: lightColorScheme.secondary,
  iconTheme: const IconThemeData(
    color: Colors.white,
    size: 20,
  ),
);

final BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: lightColorScheme.onPrimary,
  selectedLabelStyle: _textTheme.labelMedium,
  selectedItemColor: Colors.white,
  unselectedLabelStyle: _textTheme.labelMedium?.copyWith(
    color: lightColorScheme.onSecondary,
  ),
);

final SliderThemeData sliderThemeData = SliderThemeData.fromPrimaryColors(
  primaryColor: Colors.white54,
  primaryColorDark: Colors.transparent,
  primaryColorLight: Colors.transparent,
  valueIndicatorTextStyle: const TextStyle(
    color: Colors.black,
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  primaryColor: lightColorScheme.main,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white60,
    selectionHandleColor: Colors.white,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white60,
  ),
  colorScheme: lightColorScheme,
  textTheme: _textTheme,
  scaffoldBackgroundColor: lightColorScheme.onSurface,
  inputDecorationTheme: _inputDecorationTheme,
  tabBarTheme: tabBarTheme,
  appBarTheme: appBarTheme,
  bottomNavigationBarTheme: bottomNavigationBarTheme,
  sliderTheme: sliderThemeData,
  splashFactory: const NoSplashFactory(),
);
