import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kingfishertom/core/domain/exception/app.exception.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/snackbar/snack_bar_service.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';

abstract class BaseExceptionService {
  const BaseExceptionService();

  Future<T> makeErrorParsedCall<T>(AsyncValueGetter<T> callback) async {
    try {
      return await callback();
    } on DioException catch (exception) {
      throw await _getProcessedDioError(exception);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth Exception: ${e.message ?? ''}');

      if (e.code == 'user-not-found') {
        getIt<SnackBarService>()
            .showMessage(infoSnackBar('No account found with this email.'));
      } else if (e.code == 'wrong-password') {
        getIt<SnackBarService>().showMessage(infoSnackBar(
            'The password you entered is incorrect. Please try again.'));
      } else if (e.code == 'invalid-email') {
        getIt<SnackBarService>().showMessage(infoSnackBar(
            'The provided email address is invalid.'));
      }

      throw const AppException.firebaseAuthError();
    } on PlatformException catch (exception) {
      final String details =
          exception.details is String ? exception.details as String : '';

      debugPrint('Platform Exception: ${exception.message ?? details}');

      throw const AppException.platformError();
    }
    /*on AppExceptionUserNotContainsInDb {
      rethrow;
    }*/
    /*on AppException {
      rethrow;
    } on AuthException {
      rethrow;
    }*/
    catch (exception, stackTrace) {
      log(
        exception.toString(),
        name: exception.runtimeType.toString(),
        error: exception.toString(),
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<AppException> _getProcessedDioError(DioException exception) async {
    switch (exception.type) {
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.badResponse:
        debugPrint('API exception: method:${exception.requestOptions.method}/'
            '${exception.requestOptions.path} '
            '- code:${exception.response?.statusCode} '
            '- message:${exception.message}');

        throw const AppException.serverBadResponse('Server not responding!');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        debugPrint('API exception: ${exception.type}');
        throw const AppException.connectionError(
            'No or bad internet connection.');
      case DioExceptionType.unknown:
        debugPrint('API exception: Unknown');
        throw const AppException.unknown(
            'Unexpected exception. Please try again later.');
    }
  }
}
