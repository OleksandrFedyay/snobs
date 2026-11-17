import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

@injectable
class GetUserStreamUseCase {
  GetUserStreamUseCase(
    this.remoteUserDataSource,
    this.localAppInfoDataSource,
  );

  final RemoteUserDataSource remoteUserDataSource;
  final LocalAppInfoDataSource localAppInfoDataSource;
//Todo(Issa): This stream wil be replaced with [UserModelStream] when the Database will be ready
  Stream<UserModel?> execute() {
    return remoteUserDataSource.getUserStream().asyncMap(
      (UserModel? event) async {
        if (event == null) return event;

        await getIt<UserModelStream>().updateSaveUserModel(event);

        return event;
      },
    );
  }
}
