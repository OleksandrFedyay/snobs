import 'package:flutter/material.dart';
import 'package:kingfishertom/l10n/generated/snobs_app_localizations.dart';



extension BuildContextExt on BuildContext {
  SnobsAppLocalizations get i10n => SnobsAppLocalizations.of(this);

  TextTheme get textStyle => Theme.of(this).textTheme;

  double? get width => MediaQuery.of(this).size.width > 500 ? 500 : null;
}
