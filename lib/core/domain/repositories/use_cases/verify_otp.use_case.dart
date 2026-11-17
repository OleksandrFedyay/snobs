import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class VerifyOtpUseCase {
  VerifyOtpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<String?> call(String otp) => _authRepository.verifyOTP(otp);
}
