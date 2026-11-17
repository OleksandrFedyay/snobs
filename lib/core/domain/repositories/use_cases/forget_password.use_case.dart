import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class ForgetPasswordUseCase {
  ForgetPasswordUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<void> call(String email) async {
    await _authRepository.forgetPassword(email);
  }
}
