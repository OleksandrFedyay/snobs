import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/auth/local.user_jwt_source.dart';
import 'package:kingfishertom/core/data/data_sources/remote.level.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.levels_info_data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

///Retrieves all levels from [LocalLevelsInfoDataSourceImpl].
///If it returns null, all levels are retrieved from [RemoteLevelDataSource]
///and sets them to the [LocalLevelsInfoDataSourceImpl]
@injectable
class GetAllLevelsUseCase extends BaseExceptionService {
  const GetAllLevelsUseCase({
    required RemoteLevelDataSource remoteLevelDataSource,
    required LocalUserJwtSource localUserJwtSource,
    required LocalLevelsInfoDataSourceImpl localLevelsInfoDataSourceImpl,
  })  : _remoteLevelDataSource = remoteLevelDataSource,
        _localUserJwtSource = localUserJwtSource,
        _localLevelsInfoDataSourceImpl = localLevelsInfoDataSourceImpl;
  final RemoteLevelDataSource _remoteLevelDataSource;
  final LocalUserJwtSource _localUserJwtSource;
  final LocalLevelsInfoDataSourceImpl _localLevelsInfoDataSourceImpl;

  Future<List<LevelDto>> call() {
    return makeErrorParsedCall(() async {
      final List<LevelDto>? result =
          await _localLevelsInfoDataSourceImpl.getAllLevels();
      final List<LevelDto> allLevels = <LevelDto>[
        if (result != null)
          for (final LevelDto level in result) level,
      ];

      final String? jwt = await _localUserJwtSource.getJwt();
      if (allLevels.isEmpty && jwt != null) {
        allLevels.addAll(await _remoteLevelDataSource.getAllLevels(jwt: jwt));
        await _localLevelsInfoDataSourceImpl.setAllLevels(allLevels);
      }
      return allLevels;
    });
  }
}
