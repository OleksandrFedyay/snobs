import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_apple.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_google.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';

part 'email_page_state.dart';

@injectable
class EmailPageCubit extends BaseCubit<EmailPageState> {
  EmailPageCubit(
    this._signInViaAppleUseCase,
    this._signInViaGoogleUseCase,
  ) : super(const EmailPageState());

  static EmailPageCubit create() {
    return GetIt.I<EmailPageCubit>();
  }

  final SignInViaAppleUseCase _signInViaAppleUseCase;
  final SignInViaGoogleUseCase _signInViaGoogleUseCase;

  Future<void> signInViaApple() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: EmailPageStatus.loading));
      await _signInViaAppleUseCase();

      emit(state.copyWith(status: EmailPageStatus.success));
    });
  }

  Future<void> signInViaGoogle() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: EmailPageStatus.loading));
      await _signInViaGoogleUseCase();

      emit(state.copyWith(status: EmailPageStatus.success));
    });
  }

  Future<void> setButtonEnabled({required bool buttonEnabled}) async {
    await performSafeAction(() async {
      emit(state.copyWith(buttonEnabled: buttonEnabled));
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: EmailPageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
