import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/auth.repository.dart';
import 'package:kingfishertom/core/services/clearable.dart';
import 'package:kingfishertom/core/services/logout.service.dart';

@LazySingleton(as: LogoutService)
class LogoutServiceImpl implements LogoutService {
  LogoutServiceImpl(
    this._clearables,
    this._logoutRepository,
  );

  final AuthRepository _logoutRepository;
  final List<Clearable> _clearables;

  @override
  Future<void> logout() async {
    await _logoutRepository.logout();

    for (final Clearable cleanable in _clearables) {
      try {
        await cleanable.clear();
      } catch (e, s) {
        log('Failed to clear $cleanable', error: e, stackTrace: s);
      }
    }
  }
}
