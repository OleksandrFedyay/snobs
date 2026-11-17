import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_state.dart';

@injectable
class NotificationCubit extends BaseCubit<NotificationState> {
  NotificationCubit(
    this.localAppInfoDataSource,
  ) : super(const NotificationState());

  static NotificationCubit create() {
    return GetIt.I<NotificationCubit>()..init();
  }

  final LocalAppInfoDataSource localAppInfoDataSource;

  Future<void> init() async {
    await performSafeAction(() async {
      final bool? notificationTurn = localAppInfoDataSource.getNotifications();
      emit(
        state.copyWith(
          notificationTurn:
              notificationTurn ?? await Permission.notification.isGranted,
        ),
      );
    });
  }

  Future<void> turnOffNotification() async {
    await performSafeAction(() async {
      await localAppInfoDataSource.setNotifications(notificationTurn: false);

      emit(state.copyWith(notificationTurn: false));
    });
  }

  Future<void> turnOnNotification() async {
    await performSafeAction(() async {
      await FirebaseMessaging.instance.requestPermission();
      final bool status = await Permission.notification.isGranted;
      if (status) {
        await localAppInfoDataSource.setNotifications(notificationTurn: true);
        emit(state.copyWith(notificationTurn: true));
      } else {
        await openAppSettings();
        await localAppInfoDataSource.setNotifications(
          notificationTurn: await Permission.notification.isGranted,
        );
      }
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }
}
