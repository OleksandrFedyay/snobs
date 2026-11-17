import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class SignInViaEmailUseCase {
  SignInViaEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({required String email, required String password}) async {
    await _authRepository.signInViaEmail(email: email, password: password);
  }
}
