import 'package:injectable/injectable.dart';

import 'package:kingfishertom/core/services/logout.service.dart';

@injectable
class LogoutUseCase {
  LogoutUseCase(this._logoutService);
  final LogoutService _logoutService;

  Future<void> call() async {
    await _logoutService.logout();
  }
}
