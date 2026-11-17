part of 'login_page_cubit.dart';

enum LoginPageStatus {
  initial,
  error,
  loading,
  success,
}

@immutable
class LoginPageState extends Equatable {

  const LoginPageState({
    this.status = LoginPageStatus.initial,
    this.errorMessage = '',
  });
  final LoginPageStatus status;
  final String errorMessage;

  LoginPageState copyWith({
    LoginPageStatus? status,
    String? errorMessage,
  }) {
    return LoginPageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage];
}
