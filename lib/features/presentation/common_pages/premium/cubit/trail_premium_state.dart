part of 'trail_premium_cubit.dart';

@immutable
class TrailPremiumState extends Equatable {
  const TrailPremiumState({
    this.errorMessage = '',
  });

  final String errorMessage;

  TrailPremiumState copyWith({
    String? errorMessage,
  }) {
    return TrailPremiumState(
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => <Object>[errorMessage];
}
