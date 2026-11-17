import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class RemoveCollectionUseCase extends BaseExceptionService {
  RemoveCollectionUseCase(
    this.remoteUserDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(String name) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      final List<Map<String, dynamic>> collections = <Map<String, dynamic>>[
        ...user.collections
      ]..removeWhere((Map<String, dynamic> element) {
          return element['name'] == name;
        });

      await remoteUserDataSource
          .updateUser(<String, dynamic>{'collections': collections});

      await getIt<UserModelStream>()
          .updateSaveUserModel(user.update(collections: collections));
    } catch (e) {
      log(e.toString());
    }
  }
}
