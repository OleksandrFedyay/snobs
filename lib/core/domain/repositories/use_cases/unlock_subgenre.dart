import 'dart:async';

import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';

@injectable
class UnlockSubgenreUseCase {
  UnlockSubgenreUseCase(this.remoteUserDataSource);
  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(List<String> subgenres) async {
    await remoteUserDataSource.addSubgenres(subgenres);
  }
}
