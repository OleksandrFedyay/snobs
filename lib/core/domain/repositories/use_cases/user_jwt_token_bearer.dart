import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/auth/local.user_jwt_source.dart';
import 'package:kingfishertom/core/data/auth/remote.auth.jwt_source.dart';

final String _token = base64.encode(utf8.encode('snobs:8eLieQwKf9D7bQLeawqsf'));

///Called right after user is authorized to get jwt token from remote jwt source
///or from local secure storage.

@injectable
class UserJwtTokenBearer {
  const UserJwtTokenBearer({
    required RemoteAuthJwtSource remoteAuthJwtSource,
    required LocalUserJwtSource localUserJwtSource,
  })  : _remoteAuthJwtSource = remoteAuthJwtSource,
        _localUserJwtSource = localUserJwtSource;

  final RemoteAuthJwtSource _remoteAuthJwtSource;
  final LocalUserJwtSource _localUserJwtSource;

  ///TODO change returned type to String? after fixing the issues
  ///TODO delete the {bool? refreshToken} parameter after testing
  ///Retrieves JWT token from [LocalUserJwtSource]
  ///and if it is null retrieves JWT token from [RemoteAuthJwtSource]

  Future<void> call(UserModel user, {bool refreshToken = true}) async {
    final String? result = await _localUserJwtSource.getJwt();

    if (result == null || refreshToken) {
      final String? result = await _remoteAuthJwtSource.getUserJwtToken(
        user: user,
        token: _token,
      );
      if (result != null && result.isNotEmpty) {
        return _localUserJwtSource.setJwt(result);
      }
    }
  }

  Future<void> deleteJwt() async {
    await _localUserJwtSource.deleteJwt();
  }
}
