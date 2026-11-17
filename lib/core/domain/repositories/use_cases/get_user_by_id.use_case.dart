import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class GetUserByIdUseCase extends BaseExceptionService {
  GetUserByIdUseCase(this.remoteUserDataSource);

  final RemoteUserDataSource remoteUserDataSource;

  Future<UserModel?> call(String? id) async {
    try {
      return await remoteUserDataSource.getUserById(id);
    } catch (e) {
      return null;
    }
  }
}
