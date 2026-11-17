part of 'profile_edit_cubit.dart';

enum ProfileStatus {
  initial,
  error,
  loading,
  success,
  updatePhone,
}

@immutable
class ProfileEditState extends Equatable {
  const ProfileEditState({
    this.status = ProfileStatus.loading,
    this.errorMessage = '',
    this.user,
  });

  final ProfileStatus status;
  final String errorMessage;
  final UserModel? user;

  ProfileEditState copyWith({
    ProfileStatus? status,
    String? errorMessage,
    UserModel? user,
  }) {
    return ProfileEditState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      user,
    ];
  }
}
