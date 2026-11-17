part of 'settings_cubit.dart';

enum SettingsStatus {
  initial,
  error,
  loading,
}

@immutable
class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.loading,
    this.errorMessage = '',
    this.user,
    this.isTrialOrSubscriptionActive = false,
    this.appVersionNumber = '',
    this.appVersionCode = '',
  });

  final SettingsStatus status;
  final UserModel? user;
  final String errorMessage;
  final bool isTrialOrSubscriptionActive;
  final String appVersionNumber;
  final String appVersionCode;

  SettingsState copyWith({
    SettingsStatus? status,
    UserModel? user,
    String? errorMessage,
    bool? isTrialOrSubscriptionActive,
    String? appVersionNumber,
    String? appVersionCode,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
      appVersionCode: appVersionCode ?? this.appVersionCode,
      appVersionNumber: appVersionNumber ?? this.appVersionNumber,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        user,
        errorMessage,
        isTrialOrSubscriptionActive,
        appVersionCode,
        appVersionNumber,
      ];
}
