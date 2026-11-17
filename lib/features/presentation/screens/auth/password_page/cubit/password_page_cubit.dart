import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/forget_password.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/register_via_email.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_social.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_exist.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/firebase_messaging_service.dart';
import 'package:timezone/timezone.dart' as tz;

part 'password_page_state.dart';

@injectable
class PasswordPageCubit extends BaseCubit<PasswordPageState> {
  PasswordPageCubit(
    this._signInViaEmailUseCase,
    this._registerViaEmailUseCase,
    this._userExistUseCase,
    this._forgetPasswordUseCase,
  ) : super(const PasswordPageState());

  static PasswordPageCubit create(String email) {
    return GetIt.I<PasswordPageCubit>()..init(email);
  }

  final SignInViaEmailUseCase _signInViaEmailUseCase;
  final RegisterViaEmailUseCase _registerViaEmailUseCase;
  final UserExistUseCase _userExistUseCase;
  final ForgetPasswordUseCase _forgetPasswordUseCase;

  Future<void> init(String email) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: PasswordPageStatus.loading));

      emit(
        state.copyWith(
          userExist: await _userExistUseCase.call(email),
          status: PasswordPageStatus.initial,
        ),
      );
    });
  }

  Future<void> signInOrRegisterViaEmail({
    required String email,
    required String password,
  }) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: PasswordPageStatus.loadingButton));

      if (state.userExist) {
        await _signInViaEmailUseCase.call(email: email, password: password);
      } else {
        await _registerViaEmailUseCase.call(email: email, password: password);
      }

      final tz.TZDateTime lastSwipeTime = tz.TZDateTime.from(
        DateTime.now(),
        tz.local,
      );

      await showLocalNotificationInDate(
        lastSwipeTime.add(const Duration(days: 1)),
      );

      emit(state.copyWith(status: PasswordPageStatus.success));
    });
  }

  Future<void> setButtonEnabled({required bool buttonEnabled}) async {
    await performSafeAction(() async {
      emit(state.copyWith(buttonEnabled: buttonEnabled));
    });
  }

  Future<void> forgetPasswordUseCase(String email) async {
    await performSafeAction(() async {
      await _forgetPasswordUseCase(email);
      handleError('Sent a reset link in $email');
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: PasswordPageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
