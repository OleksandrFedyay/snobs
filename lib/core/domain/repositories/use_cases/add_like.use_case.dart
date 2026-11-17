import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/complete_task.use_case.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';

@injectable
class AddLikeUseCase extends BaseExceptionService {
  AddLikeUseCase(
    this.remoteUserDataSource,
    this.remoteArtistChartDataSource,
    this.completeTaskUseCase,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final CompleteTaskUseCase completeTaskUseCase;

  Future<void> call(
    String? artistId, [
    List<String> artistCollections = const <String>[],
  ]) async {
    try {
      if (artistId == null) return;

      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      final List<Map<String, dynamic>> collections =
          addArtistInCollections(artistId, artistCollections, user);

      if (!user.likes.contains(artistId)) {
        await getIt<UserModelStream>().updateSaveUserModel(user.update(
          likes: <String>[...user.likes, artistId],
          collections: collections,
        ));
      }

      await remoteArtistChartDataSource.updateArtistChart(artistId, like: true);

      if (user.swipesCount == 4) {
        await completeTaskUseCase('exploreswipepage');
      } else if (user.swipesCount == 49) {
        await completeTaskUseCase('50totalswipes');
      } else if (user.swipesCount == 299) {
        await completeTaskUseCase('300totalswipes');
      } else if (user.swipesCount == 499) {
        await completeTaskUseCase('5000totalswipes');
      } else if (user.swipesCount == 999) {
        await completeTaskUseCase('1000totalswipes');
      } else if (user.swipesCount == 2499) {
        await completeTaskUseCase('2500totalswipes');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  List<Map<String, dynamic>> addArtistInCollections(
    String artistId,
    List<String> artistCollections,
    UserModel user,
  ) {
    final List<Map<String, dynamic>> userColections =
        user.collections.map((Map<String, dynamic> value) {
      ArtistCollectionDto collect = ArtistCollectionDto.fromJson(value);

      if (artistCollections.contains(collect.name)) {
        collect =
            collect.copyWith(artists: <String>[...collect.artists, artistId]);
        artistCollections.remove(collect.name);
      }
      return collect.toJson();
    }).toList();

    for (final String collect in artistCollections) {
      userColections.add(
        ArtistCollectionDto(
          name: collect,
          artists: <String>[artistId],
        ).toJson(),
      );
    }

    return userColections;
  }
}
