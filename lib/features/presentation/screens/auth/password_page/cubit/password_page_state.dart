part of 'password_page_cubit.dart';

enum PasswordPageStatus {
  initial,
  error,
  loading,
  success,
  loadingButton,
  passwordResset,
}

@immutable
class PasswordPageState extends Equatable {

  const PasswordPageState({
    this.status = PasswordPageStatus.initial,
    this.errorMessage = '',
    this.buttonEnabled = false,
    this.userExist = true,
  });
  final PasswordPageStatus status;
  final String errorMessage;
  final bool buttonEnabled;
  final bool userExist;

  PasswordPageState copyWith({
    PasswordPageStatus? status,
    String? errorMessage,
    bool? buttonEnabled,
    bool? userExist,
  }) {
    return PasswordPageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      buttonEnabled: buttonEnabled ?? this.buttonEnabled,
      userExist: userExist ?? this.userExist,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage, buttonEnabled, userExist];
}
