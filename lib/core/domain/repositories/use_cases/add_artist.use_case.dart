import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/complete_task.use_case.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';

@injectable
class AddArtistUseCase extends BaseExceptionService {
  AddArtistUseCase(
    this.remoteArtistChartDataSource,
    this.remoteUserDataSource,
    this.completeTaskUseCase,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;
  final RemoteUserDataSource remoteUserDataSource;
  final CompleteTaskUseCase completeTaskUseCase;

  Future<void> call(ArtistChartDto? artist) async {
    try {
      if (artist == null) return;

      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (user == null) return;

      if (user.skips.contains(artist.id)) return;

      await getIt<UserModelStream>().updateSaveUserModel(
          user.update(skips: <String>[...user.skips, artist.id]));

      await remoteArtistChartDataSource.updateArtistChart(
        artist.id,
        like: false,
      );

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
}
