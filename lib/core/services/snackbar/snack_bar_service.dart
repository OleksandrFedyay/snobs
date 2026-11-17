import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

@lazySingleton
class SnackBarService {
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  void showMessage(SnackBar snackBar) =>
      _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);

  void get hideMessage => _scaffoldMessengerKey.currentState
      ?.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);

  void clearSnackBars() => _scaffoldMessengerKey.currentState?.clearSnackBars();
}
