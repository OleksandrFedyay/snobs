import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class UserExistUseCase {
  UserExistUseCase(
    this._authRepository,
  );
  final AuthRepository _authRepository;

  Future<bool> call(String email) async {
    return _authRepository.userExist(email);
  }
}
