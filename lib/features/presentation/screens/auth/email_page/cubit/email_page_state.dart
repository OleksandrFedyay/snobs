part of 'email_page_cubit.dart';

enum EmailPageStatus {
  initial,
  error,
  loading,
  success,
}

@immutable
class EmailPageState extends Equatable {

  const EmailPageState({
    this.status = EmailPageStatus.initial,
    this.errorMessage = '',
    this.buttonEnabled = false,
  });
  final EmailPageStatus status;
  final String errorMessage;
  final bool buttonEnabled;

  EmailPageState copyWith({
    EmailPageStatus? status,
    String? errorMessage,
    bool? buttonEnabled,
  }) {
    return EmailPageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      buttonEnabled: buttonEnabled ?? this.buttonEnabled,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage, buttonEnabled];
}
