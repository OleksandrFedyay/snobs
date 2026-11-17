import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';

@injectable
class EndTrialUseCase {
  EndTrialUseCase(this.remoteUserDataSource);
  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(int daysLeft) async {
    await remoteUserDataSource.endTrial(daysLeft);
  }
}
