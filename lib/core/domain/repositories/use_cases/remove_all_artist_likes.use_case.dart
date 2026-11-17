import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class RemoveAllArtistLikesUseCase extends BaseExceptionService {
  RemoveAllArtistLikesUseCase(
    this.remoteUserDataSource,
    this.remoteArtistChartDataSource,
    this.localAppInfoDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final LocalAppInfoDataSource localAppInfoDataSource;

  Future<void> call(ArtistChartDto artist) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      if (!user.likes.contains(artist.id)) return;

      final List<String> likes = user.likes..remove(artist.id);
      final List<Map<String, dynamic>> userCollections =
          user.collections.map((Map<String, dynamic> value) {
        final ArtistCollectionDto collect = ArtistCollectionDto.fromJson(value);

        collect.artists.remove(artist.id);

        return collect.toJson();
      }).toList();

      await remoteUserDataSource.updateUser(<String, dynamic>{
        'collections': userCollections,
        'like': likes,
      });

      await getIt<UserModelStream>().updateSaveUserModel(
          user.update(likes: likes, collections: userCollections));

      await remoteArtistChartDataSource.deleteArtistChart(artist.id);
    } catch (e) {
      log(e.toString());
    }
  }
}
