import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/delete_acount.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/end_trial.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/logout_use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends BaseCubit<SettingsState> {
  SettingsCubit(
    this.getUserUseCase,
    this._logoutUseCase,
    this.deleteAccountUseCase,
    this.endTrialUseCase,
  ) : super(const SettingsState());

  static SettingsCubit create() {
    return GetIt.I<SettingsCubit>()..init();
  }

  final GetUserStreamUseCase getUserUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final LogoutUseCase _logoutUseCase;
  final EndTrialUseCase endTrialUseCase;

  Future<void> init() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: SettingsStatus.loading));
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      handleStream(
        '_getUserStreamUseCase',
        getUserUseCase.execute(),
        (UserModel? user) async {
          emit(
            state.copyWith(
              status: SettingsStatus.initial,
              user: user,
              appVersionNumber: packageInfo.version,
              appVersionCode: packageInfo.buildNumber,
            ),
          );
        },
      );
    });
  }

  Future<void> endTrial() async {
    await performSafeAction(() async {
      await endTrialUseCase(0);
    });
  }

  Future<void> logout() async {
    await performSafeAction(() async {
      await _logoutUseCase();

      if (!kIsWeb) await getIt<PurchasesCat>().logOut();
      await router.pushAndClearStackSplashRoute();
    });
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    await deleteAccountUseCase();
    await logout();
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: SettingsStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
