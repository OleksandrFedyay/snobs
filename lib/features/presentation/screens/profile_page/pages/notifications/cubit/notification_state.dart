part of 'notification_cubit.dart';

@immutable
class NotificationState extends Equatable {
  const NotificationState({
    this.errorMessage = '',
    this.notificationTurn = false,
  });

  final String errorMessage;
  final bool notificationTurn;

  NotificationState copyWith({
    String? errorMessage,
    bool? notificationTurn,
  }) {
    return NotificationState(
      errorMessage: errorMessage ?? this.errorMessage,
      notificationTurn: notificationTurn ?? this.notificationTurn,
    );
  }

  @override
  List<Object> get props => <Object>[errorMessage, notificationTurn];
}
