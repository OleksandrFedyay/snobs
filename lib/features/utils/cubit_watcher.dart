import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitWatcher extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> cubit, Change<dynamic> change) {
    super.onChange(cubit, change);
    debugPrint(
      '🛡️ Cubit: <${cubit.runtimeType}>\n'
      '🔵 Previous State: ${change.currentState}\n'
      '🔷 Current State: ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    debugPrint(
      '🛑 Cubit: <${cubit.runtimeType}>\n'
      '🔴 Error: $error\n'
      '♦️ StackTrace: $stackTrace',
    );
  }
}
