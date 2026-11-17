import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/data/api/models/user/user_model.dart';

///Secure storage for JWT token.
@lazySingleton
class LocalUserJwtSource {
  LocalUserJwtSource(this._secureStorage);

  final FlutterSecureStorage _secureStorage;
  static const String _jwtKey = '_jwt';

  ///Retrieve JWT from this [LocalUserJwtSource] storage.
  Future<String?> getJwt() => _secureStorage.read(key: _jwtKey);

  /// Set the JWT to this [LocalUserJwtSource] storage.
  Future<void> setJwt(String jwt) async {
    await _secureStorage.write(key: _jwtKey, value: jwt);
  }

  ///Delete JWT token from this [LocalUserJwtSource] storage
  Future<void> deleteJwt() async {
    await _secureStorage.delete(key: _jwtKey);
  }

  ///TODO complete this method for refreshing jwt
  Future<void> setUserForJwt(UserModel userForJwt) async {}

  Future<void> clearStorage() async {
    await _secureStorage.deleteAll();
  }
}
