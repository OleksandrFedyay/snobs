import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';

class UserLikeDto {
  const UserLikeDto({
    required this.subgenreLiked,
    required this.user,
    required this.levelDto,
  });

  final UserModel user;
  final SubgenreLiked subgenreLiked;
  final LevelDto levelDto;
}
