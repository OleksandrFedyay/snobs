import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_all_levels.use_case.dart';

// ignore_for_file: unused_field
///Used to detect the current users' levels
@injectable
class GetCurrentLevelUseCase extends BaseExceptionService {
  const GetCurrentLevelUseCase(this._getAllLevelsUseCase);

  final GetAllLevelsUseCase _getAllLevelsUseCase;

  Future<LevelDto?> call({required int xp}) async {
    return makeErrorParsedCall(() async {
      final List<LevelDto> levels = await _getAllLevelsUseCase();
      LevelDto? currentLevel;
      if (levels.isNotEmpty) {
        currentLevel = levels.where((LevelDto l) => l.xp > xp).first;
      }

      return currentLevel;
    });
  }
}
