import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_phone.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/verify_otp.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/firebase_messaging_service.dart';
import 'package:timezone/timezone.dart' as tz;

part 'code_page_state.dart';

@injectable
class CodePageCubit extends BaseCubit<CodePageState> {
  CodePageCubit(
    this._signInViaPhoneUseCase,
    this._verifyOtpUseCase,
  ) : super(const CodePageState());

  static CodePageCubit create(String phone) {
    return GetIt.I<CodePageCubit>()..init(phone);
  }

  final SignInViaPhoneUseCase _signInViaPhoneUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  Future<void> init(String phone) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: CodePageStatus.loading));
      await _signInViaPhoneUseCase(phone);

      emit(state.copyWith(status: CodePageStatus.initial));
    });
  }

  Future<void> verifyOtp() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: CodePageStatus.loadingButton));

      final String? userName = await _verifyOtpUseCase(state.code);

      final tz.TZDateTime lastSwipeTime = tz.TZDateTime.from(
        DateTime.now(),
        tz.local,
      );

      await showLocalNotificationInDate(
        lastSwipeTime.add(const Duration(days: 1)),
      );

      emit(
        state.copyWith(
          status: CodePageStatus.success,
          userName: userName,
        ),
      );
    });
  }

  Future<void> setCode(String code) async {
    await performSafeAction(() async {
      emit(state.copyWith(code: code));
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: CodePageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
