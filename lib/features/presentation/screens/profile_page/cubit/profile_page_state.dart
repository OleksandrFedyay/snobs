part of 'profile_page_cubit.dart';

enum MenuStatus {
  initial,
  error,
  loading,
}

@immutable
class ProfilePageState extends Equatable {
  const ProfilePageState({
    this.status = MenuStatus.loading,
    this.errorMessage = '',
    this.badges = const <BadgeDto>[],
    this.user,
    this.swipe,
    this.index = 0,
    this.level,
    this.isTrialOrSubscriptionActive = false,
  });

  final MenuStatus status;
  final String errorMessage;
  final UserModel? user;
  final List<BadgeDto> badges;
  final SwipeDto? swipe;
  final int index;
  ///The next Rank level value
  final LevelDto? level;
  final bool isTrialOrSubscriptionActive;

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      user,
      badges,
      swipe,
      index,
      level,
      isTrialOrSubscriptionActive,
    ];
  }

  ProfilePageState copyWith({
    MenuStatus? status,
    String? errorMessage,
    UserModel? user,
    List<BadgeDto>? badges,
    SwipeDto? swipe,
    int? index,
    LevelDto? level,
    bool? isTrialOrSubscriptionActive,
  }) {
    return ProfilePageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      badges: badges ?? this.badges,
      swipe: swipe ?? this.swipe,
      index: index ?? this.index,
      level: level ?? this.level,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
    );
  }
}
