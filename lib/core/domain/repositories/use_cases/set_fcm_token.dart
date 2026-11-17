import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';

@injectable
class SetFcmTokenUseCase {
  SetFcmTokenUseCase(this.remoteUserDataSource);
  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(String fcmToken) async {
    await remoteUserDataSource.setFcmToken(fcmToken);
  }
}
