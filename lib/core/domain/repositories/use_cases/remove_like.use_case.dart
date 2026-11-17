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
class RemoveLikeUseCase extends BaseExceptionService {
  RemoveLikeUseCase(
    this.remoteUserDataSource,
    this.remoteArtistChartDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<void> call(ArtistChartDto artist, String? collectName) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      if (!user.likes.contains(artist.id)) return;

      if (collectName == null) {
        final List<String> likes = user.likes..remove(artist.id);
        await remoteUserDataSource.updateUser(<String, dynamic>{'like': likes});

        await getIt<UserModelStream>()
            .updateSaveUserModel(user.update(likes: likes));
      } else {
        final List<Map<String, dynamic>> userCollections =
            user.collections.map((Map<String, dynamic> value) {
          final ArtistCollectionDto collect =
              ArtistCollectionDto.fromJson(value);
          if (collect.name == collectName) {
            collect.artists.remove(artist.id);
          }

          return collect.toJson();
        }).toList();

        await remoteUserDataSource
            .updateUser(<String, dynamic>{'collections': userCollections});

        await getIt<UserModelStream>()
            .updateSaveUserModel(user.update(collections: userCollections));
      }

      await remoteArtistChartDataSource.deleteArtistChart(artist.id);
    } catch (e) {
      log(e.toString());
    }
  }
}
