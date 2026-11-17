import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/kingfishertom_api/kingfishertom_api_service.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';

@lazySingleton
class RemoteAuthJwtSource {
  const RemoteAuthJwtSource({
    required KingfishertomApiService kingfishertomApiService,
  }) : _kingfishertomApiService = kingfishertomApiService;

  final KingfishertomApiService _kingfishertomApiService;

  Future<String?> getUserJwtToken({
    required UserModel user,
    required String token,
  }) async {
    return _kingfishertomApiService.getUserJwtToken(user: user, token: token);
  }
}
