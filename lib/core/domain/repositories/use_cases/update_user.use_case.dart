import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';

@injectable
class UpdateUserUseCase extends BaseExceptionService {
  UpdateUserUseCase(
    this.remoteUserDataSource,
    this.authRepository,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final AuthRepository authRepository;

  Future<void> call(Map<String, dynamic> data) async {
    try {
      final String? email = data['email'] as String?;
      if (email != null) await authRepository.updateEmail(email);

      await remoteUserDataSource.updateUser(data);
    } catch (e) {
      log(e.toString());
    }
  }
}
