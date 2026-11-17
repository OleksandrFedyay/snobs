import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class CreateCollectionUseCase extends BaseExceptionService {
  CreateCollectionUseCase(
    this.remoteUserDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(String name) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      final List<Map<String, dynamic>> collections = user.collections;
      for (final Map<String, dynamic> c in collections) {
        if (c['name'] == name) return;
      }

      await getIt<UserModelStream>().updateSaveUserModel(user.update(
        collections: <Map<String, dynamic>>[
          ...collections,
          ArtistCollectionDto(name: name).toJson(),
        ],
      ));
    } catch (e) {
      log(e.toString());
    }
  }
}
