import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class UpdatePhotoUseCase extends BaseExceptionService {
  UpdatePhotoUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<String> call(File photo) async {
    return _authRepository.updatePhotoUrl(photo);
  }
}
