import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

import 'package:kingfishertom/features/presentation/resources/style/dark.theme.dart';

const double _sigmaXBlur = 5.0;
const double _sigmaYBlur = 5.0;

@singleton
class AppThemeModel extends ChangeNotifier {
  static AppThemeModel get instance => getIt();

  ImageFilter get overlayBlur =>
      ImageFilter.blur(sigmaX: _sigmaXBlur, sigmaY: _sigmaYBlur);

  ElevatedButtonThemeData getOnboardingElevatedButtonTheme() {
    return getMainElevatedButtonTheme();
  }

  ElevatedButtonThemeData getWelcomeButtonTheme() {
    return getWelcomeElevatedButtonTheme();
  }

  ElevatedButtonThemeData getRemoveButtonTheme() {
    return getRemoveElevatedButtonTheme();
  }

  ElevatedButtonThemeData getGreyButtonTheme() {
    return getSimpleElevatedButtonTheme();
  }
}
