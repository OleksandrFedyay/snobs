import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_apple.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/sign_in_via_google.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';

part 'login_page_state.dart';

@injectable
class LoginPageCubit extends BaseCubit<LoginPageState> {
  LoginPageCubit(
    this._signInViaAppleUseCase,
    this._signInViaGoogleUseCase,
  ) : super(const LoginPageState());

  static LoginPageCubit create() {
    return GetIt.I<LoginPageCubit>();
  }

  final SignInViaAppleUseCase _signInViaAppleUseCase;
  final SignInViaGoogleUseCase _signInViaGoogleUseCase;

  Future<void> signInViaApple() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: LoginPageStatus.loading));
      await _signInViaAppleUseCase();
      router.pushAndClearStackNameRoute();
    });
  }

  Future<void> signInViaGoogle() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: LoginPageStatus.loading));
      await _signInViaGoogleUseCase();
      router.pushAndClearStackNameRoute();
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: LoginPageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
