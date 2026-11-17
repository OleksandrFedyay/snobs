import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/data_sources/remote.badge.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_jwt_token_bearer.dart';

@injectable
class DeleteAccountUseCase {
  DeleteAccountUseCase(
    this._authRepository,
    this._remoteBadgeDataSource,
    this._localAppInfoDataSource,
    this._userJwtTokenBearer,
  );

  final RemoteBadgeDataSource _remoteBadgeDataSource;
  final AuthRepository _authRepository;
  final LocalAppInfoDataSource _localAppInfoDataSource;
  final UserJwtTokenBearer _userJwtTokenBearer;

  Future<void> call() async {
    await _remoteBadgeDataSource.deleteInfo();
    await _localAppInfoDataSource.clearSharedPreferencesData();
    await _userJwtTokenBearer.deleteJwt();
    try {
      await _authRepository.deleteAccount();
    } catch (_) {}
  }
}
