import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_apple.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_google.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';

part 'phone_page_state.dart';

@injectable
class PhonePageCubit extends BaseCubit<PhonePageState> {
  PhonePageCubit(
    this._signInViaAppleUseCase,
    this._signInViaGoogleUseCase,
  ) : super(const PhonePageState());
  static PhonePageCubit create() {
    return GetIt.I<PhonePageCubit>();
  }

  final SignInViaAppleUseCase _signInViaAppleUseCase;
  final SignInViaGoogleUseCase _signInViaGoogleUseCase;

  Future<void> signInViaApple() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: PhonePageStatus.loading));
      await _signInViaAppleUseCase();

      emit(state.copyWith(status: PhonePageStatus.success));
    });
  }

  Future<void> signInViaGoogle() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: PhonePageStatus.loading));
      await _signInViaGoogleUseCase();

      emit(state.copyWith(status: PhonePageStatus.success));
    });
  }

  Future<void> setPhoneAndButtonEnabled(
    String phone, {
    required bool buttonEnabled,
  }) async {
    await performSafeAction(() async {
      emit(
        state.copyWith(
          phone: phone,
          buttonEnabled: buttonEnabled,
        ),
      );
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: PhonePageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
