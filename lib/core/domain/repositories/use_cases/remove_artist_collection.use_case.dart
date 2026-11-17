import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class RemoveArtistCollectionUseCase extends BaseExceptionService {
  RemoveArtistCollectionUseCase(
    this.remoteArtistChartDataSource,
    this.remoteUserDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(
    ArtistChartDto artist,
    String collection,
  ) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      final List<Map<String, dynamic>> userCollections =
          user.collections.map((Map<String, dynamic> value) {
        ArtistCollectionDto collect = ArtistCollectionDto.fromJson(value);
        final List<String> artists = <String>[...collect.artists];

        if (collection == collect.name) {
          artists.remove(artist.id);
        }

        collect = collect.copyWith(
          artists: artists,
        );
        return collect.toJson();
      }).toList();

      await remoteUserDataSource
          .updateUser(<String, dynamic>{'collections': userCollections});

      await getIt<UserModelStream>()
          .updateSaveUserModel(user.update(collections: userCollections));
    } catch (e) {
      log(e.toString());
    }
  }
}
