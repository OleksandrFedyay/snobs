import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_like_dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_current_level.use_case.dart';

///Retrieves top users of the requested subgenre of the type [UserModel]
///and gets subgenre liked of the type [SubgenreLiked].
///After that it forms topSnobUsers of the type [UserLikeDto] combining data from [UserModel] and [SubgenreLiked].
@injectable
class GetSnobsSubgenreTopUsersUseCase extends BaseExceptionService {
  GetSnobsSubgenreTopUsersUseCase(
    this._likeGenreDataSource,
    this._getCurrentLevelUseCase,
  );

  final RemoteLikeGenreDataSource _likeGenreDataSource;
  final GetCurrentLevelUseCase _getCurrentLevelUseCase;

  Future<List<UserLikeDto>> call(String subgenre) {
    return makeErrorParsedCall(() async {
      final (List<UserModel>, List<SubgenreLiked>) result =
          await _likeGenreDataSource.getSnobSubgenreTopUsers(
        subgenre,
      );
      final ({
        List<SubgenreLiked> subgenreLiked,
        List<UserModel> users
      }) resultRecord = (users: result.$1, subgenreLiked: result.$2);
      final List<UserLikeDto> snobsSubgenreTopUsers = <UserLikeDto>[];
      for (int i = 0; i < resultRecord.users.length; i++) {
        final LevelDto? levelDto =
            await _getCurrentLevelUseCase(xp: resultRecord.users[i].levelXp);
        if (levelDto != null) {
          snobsSubgenreTopUsers.add(
            UserLikeDto(
              subgenreLiked: resultRecord.subgenreLiked[i],
              user: resultRecord.users[i],
              levelDto: levelDto,
            ),
          );
        }
      }

      return snobsSubgenreTopUsers;
    });
  }
}
