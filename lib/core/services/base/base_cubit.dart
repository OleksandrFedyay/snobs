import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';

abstract class BaseCubit<TState> extends Cubit<TState> {
  BaseCubit(super.initialState);

  @override
  Future<void> close() async {
    _subscriptions
        .forEach((String key, StreamSubscription<dynamic> subscription) {
      try {
        subscription.cancel();
      } catch (error) {
        log('!!! Error while close subscription');
      }
    });
    await super.close();
  }

  void handleError(String errorMessage);

  final Map<String, StreamSubscription<dynamic>> _subscriptions =
      <String, StreamSubscription<dynamic>>{};

  Future<void> performSafeAction(AsyncCallback callback) async {
    try {
      return await callback();
    } on PlatformException catch (exception) {
      // ignore: always_specify_types
      final details = (exception.details as Map?)?['userCancelled'];

      if (details is bool && exception.code == '1' && details) return;

      handleError('$exception');
      log('$exception');
    } on SocketException catch (_) {
      getIt<SnackBarService>()
          .showMessage(infoSnackBar('No or bad internet connection.'));
      handleError('');
    } catch (exception) {
      if (exception is AppException && exception.details != null) {
        handleError(exception.details ?? '');
      } else {
        handleError('');
      }

      log('$exception');
    }
  }

  void handleStream<T>(
    String key,
    Stream<T> stream,
    ValueSetter<T> actionSuccess, {
    ValueSetter<String>? onError,
    bool isAutoShowSnackBar = false,
  }) {
    _subscriptions[key]?.cancel();
    _subscriptions[key] = stream.listen(
      (T data) async {
        actionSuccess(data);
      },
      onError: (Object error) => handleError(error.toString()),
    );
  }
}
