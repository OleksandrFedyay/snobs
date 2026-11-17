import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class SignInViaPhoneUseCase {

  SignInViaPhoneUseCase(
    this._authRepository,
  );
  final AuthRepository _authRepository;

  Future<void> call(String phone) async {
    await _authRepository.signInViaPhone(phone);
  }
}
