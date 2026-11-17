import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_current_level.use_case.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

enum LevelValueType {
  levelData,
  levelStatus,
}

///Retrieves user's levels from [RemoteLevelDataSource]
@injectable
class GetAppUserLevelUseCase extends BaseExceptionService {
  GetAppUserLevelUseCase(
    this._localAppInfoDataSource,
    this._getCurrentLevelUseCase,
  );

  static bool isNewRankLevel = false;

  final GetCurrentLevelUseCase _getCurrentLevelUseCase;

  final LocalAppInfoDataSource _localAppInfoDataSource;

  Future<Map<LevelValueType, Object>> call() async {
    return makeErrorParsedCall(() async {
      final LevelDto? level = _localAppInfoDataSource.getCurrentLevel();

      final UserModel? user = await getIt<UserModelStream>().getUserModel();
      if (level == null || (user?.levelXp ?? 0) >= level.xp) {
        final LevelDto? remoteLevel = await _getCurrentLevelUseCase(
          xp: user?.levelXp ?? 0,
        );
        if (remoteLevel != null) {
          /// [level != null] If the storage was cleaned so level will be null and User Xp level will be with value
          /// isNewRankLevel is needed to Show the Rank dialogue
          isNewRankLevel = level != null;
          await _localAppInfoDataSource.setCurrentLevel(remoteLevel);
          return <LevelValueType, Object>{
            LevelValueType.levelData: remoteLevel,
            LevelValueType.levelStatus: isNewRankLevel,
          };
        }
        return <LevelValueType, Object>{};
      }
      return <LevelValueType, Object>{
        LevelValueType.levelData: level,
        LevelValueType.levelStatus: isNewRankLevel,
      };
    });
  }
}
