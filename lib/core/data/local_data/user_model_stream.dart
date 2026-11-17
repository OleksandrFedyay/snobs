import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class UserModelStream {
  UserModelStream(this._secureStorage, this._remoteUserDataSource);


  final RemoteUserDataSource _remoteUserDataSource;
  final FlutterSecureStorage _secureStorage;
  final BehaviorSubject<UserModel?> _userModelSubject =
      BehaviorSubject<UserModel?>();
  static const String _userKey = 'user_model_key';


  /// Stream of UserModel
  Stream<UserModel?> get userModelCurrentStream => _userModelSubject.stream;

  /// Current UserModel (Without stream)
  UserModel? get model => _userModelSubject.value;

  /// Load UserModel from Storage and add it to the stream
  Future<UserModel?> getUserModel() async {
    if (_userModelSubject.valueOrNull == null) {
      final UserModel? userData = await _userModel;
      if (userData != null) {
        _userModelSubject.add(userData);
      }
      return userData;
    }

    /// Return the current value if already UserModel set
    return _userModelSubject.valueOrNull;
  }

  /// Update UserModel and notify listeners
  Future<void> updateSaveUserModel(UserModel userModel) async {
    _userModelSubject.add(userModel);
    await _saveUserModel(userModel);
  }

  Future<UserModel?> get _userModel async {
    final String? user = await _secureStorage.read(key: _userKey);

    if (user == null) return null;

    return UserModel.fromJson(jsonDecode(user) as Map<String, dynamic>);
  }

  Future<void> _saveUserModel(UserModel user) async{
    await  _secureStorage.write(key: _userKey, value: jsonEncode(user.toJson()));
    await _remoteUserDataSource.updateUser(user.toJson());
  }


  void dispose() => _userModelSubject.close();
}
