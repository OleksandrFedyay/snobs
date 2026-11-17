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
class EditArtistInCollectionUseCase extends BaseExceptionService {
  EditArtistInCollectionUseCase(
    this.remoteArtistChartDataSource,
    this.remoteUserDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(
    ArtistChartDto artist,
    List<String> artistCollections,
  ) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      bool like = true;
      final List<Map<String, dynamic>> userCollections =
          user.collections.map((Map<String, dynamic> value) {
        ArtistCollectionDto collect = ArtistCollectionDto.fromJson(value);
        final List<String> artists = <String>[...collect.artists];

        if (artistCollections.contains(collect.name)) {
          if (!collect.artists.contains(artist.id)) {
            artists.add(artist.id);

            like = true;
            artistCollections.remove(collect.name);
          }
        } else {
          if (collect.artists.contains(artist.id)) {
            artists.remove(artist.id);
            like = false;
          }
        }
        collect = collect.copyWith(
          artists: artists,
        );
        return collect.toJson();
      }).toList();

      for (final String collect in artistCollections) {
        userCollections.add(
          ArtistCollectionDto(
            name: collect,
            artists: <String>[artist.id],
          ).toJson(),
        );
      }

      await remoteUserDataSource
          .updateUser(<String, dynamic>{'collections': userCollections});

      await getIt<UserModelStream>()
          .updateSaveUserModel(user.update(collections: userCollections));

      await remoteArtistChartDataSource.updateArtistChart(
        artist.id,
        like: like,
      );
    } catch (e) {
      log(e.toString());
    }
  }
}

@injectable
class EditArtistsInCollectionUseCase extends BaseExceptionService {
  EditArtistsInCollectionUseCase(
    this.localAppInfoDataSource,
    this.remoteArtistChartDataSource,
    this.remoteUserDataSource,
  );

  final LocalAppInfoDataSource localAppInfoDataSource;
  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final RemoteUserDataSource remoteUserDataSource;

  Future<void> call(
    List<ArtistChartDto> artists,
    List<String> artistCollections,
  ) async {
    try {
      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      final List<Map<String, dynamic>> userCollections =
          user.collections.map((Map<String, dynamic> value) {
        ArtistCollectionDto collect = ArtistCollectionDto.fromJson(value);
        final List<String> collectionArtists = <String>[...collect.artists];

        if (artistCollections.contains(collect.name)) {
          for (final ArtistChartDto a in artists) {
            if (!collect.artists.contains(a.id)) {
              collectionArtists.add(a.id);

              artistCollections.remove(collect.name);
            }
          }
        }
        collect = collect.copyWith(
          artists: collectionArtists,
        );
        return collect.toJson();
      }).toList();

      for (final String collect in artistCollections) {
        userCollections.add(
          ArtistCollectionDto(
            name: collect,
            artists: artists.map((ArtistChartDto a) => a.id).toList(),
          ).toJson(),
        );
      }

      await remoteUserDataSource
          .updateUser(<String, dynamic>{'collections': userCollections});

      await getIt<UserModelStream>()
          .updateSaveUserModel(user.update(collections: userCollections));

      for (final ArtistChartDto artist in artists) {
        await remoteArtistChartDataSource.updateArtistChart(
          artist.id,
          like: true,
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
