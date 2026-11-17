part of 'phone_page_cubit.dart';

enum PhonePageStatus {
  initial,
  error,
  loading,
  success,
}

@immutable
class PhonePageState extends Equatable {

  const PhonePageState({
    this.status = PhonePageStatus.initial,
    this.errorMessage = '',
    this.buttonEnabled = false,
    this.phone = '',
  });
  final PhonePageStatus status;
  final String errorMessage;
  final bool buttonEnabled;
  final String phone;

  PhonePageState copyWith({
    PhonePageStatus? status,
    String? errorMessage,
    bool? buttonEnabled,
    String? phone,
  }) {
    return PhonePageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      buttonEnabled: buttonEnabled ?? this.buttonEnabled,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object> get props {
    return <Object>[
      status,
      errorMessage,
      buttonEnabled,
      phone,
    ];
  }
}
