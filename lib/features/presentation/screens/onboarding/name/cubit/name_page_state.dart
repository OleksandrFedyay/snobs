part of 'name_page_cubit.dart';

enum NamePageStatus {
  initial,
  error,
  success,
  loadingButton,
}

@immutable
class NamePageState extends Equatable {
  const NamePageState({
    this.status = NamePageStatus.initial,
    this.errorMessage = '',
    this.buttonEnabled = false,
    this.initialName = '',
  });

  final NamePageStatus status;
  final String errorMessage;
  final bool buttonEnabled;
  final String initialName;

  NamePageState copyWith({
    NamePageStatus? status,
    String? errorMessage,
    bool? buttonEnabled,
    String? initialName,
  }) {
    return NamePageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      buttonEnabled: buttonEnabled ?? this.buttonEnabled,
      initialName: initialName ?? this.initialName,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage, buttonEnabled, initialName];
}
