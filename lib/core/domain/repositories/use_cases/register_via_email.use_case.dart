import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class RegisterViaEmailUseCase {

  RegisterViaEmailUseCase(
    this._authRepository,
  );
  final AuthRepository _authRepository;

  Future<void> call({required String email, required String password}) async {
    await _authRepository.registerViaEmail(email: email, password: password);
  }
}
