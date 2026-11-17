import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class SignInViaGoogleUseCase {
  SignInViaGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call() async {
    await _authRepository.signInViaGoogle();
  }
}
