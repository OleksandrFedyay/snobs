import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_service.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';

///Retrieve user's levels from KingfishertomApiService
@lazySingleton
class RemoteLevelDataSource {
  RemoteLevelDataSource(
    this._kingfishertomApiService,
  );

  final KingfishertomApiService _kingfishertomApiService;

  ///Returns levels that matches user experience
  Future<LevelDto> getCurrentLevel({
    required int xp,
    required String jwt,
  }) async {
    final LevelDto currentLevel = await getAllLevels(jwt: jwt).then(
      (List<LevelDto> e) => e.where((LevelDto l) => l.xp >= xp).first,
    );
    return currentLevel;
  }

  ///Retrieves all Levels from kingfishertom server:
  ///Normie, Fan, Scout, Nerd, Snob, Elite Snob
  Future<List<LevelDto>> getAllLevels({required String jwt}) async {
    final List<LevelDto> levels = await _kingfishertomApiService.getAllLevels(jwt: jwt);

    return levels;
  }
}
