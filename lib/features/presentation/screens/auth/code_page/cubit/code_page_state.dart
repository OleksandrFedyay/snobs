part of 'code_page_cubit.dart';

enum CodePageStatus {
  initial,
  error,
  loading,
  success,
  loadingButton,
}

@immutable
class CodePageState extends Equatable {
  const CodePageState({
    this.status = CodePageStatus.initial,
    this.errorMessage = '',
    this.code = '',
    this.userName = '',
  });

  final CodePageStatus status;
  final String errorMessage;
  final String code;
  final String userName;

  CodePageState copyWith({
    CodePageStatus? status,
    String? errorMessage,
    String? code,
    String? userName,
  }) {
    return CodePageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      code: code ?? this.code,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage, code, userName];
}
