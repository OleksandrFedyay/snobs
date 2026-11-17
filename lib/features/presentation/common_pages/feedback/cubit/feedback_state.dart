import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';

enum FeedbackStatus {
  initial,
  error,
  loading,
  success,
}

@immutable
class FeedbackState extends Equatable {
  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.errorMessage = '',
    this.buttonEnabled = false,
    this.selectedNeed = const <String>[],
    this.type = FeedbackType.feature,
  });

  final FeedbackStatus status;
  final String errorMessage;
  final bool buttonEnabled;
  final List<String> selectedNeed;
  final FeedbackType type;

  FeedbackState copyWith({
    FeedbackStatus? status,
    String? errorMessage,
    bool? buttonEnabled,
    List<String>? selectedNeed,
    FeedbackType? type,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      buttonEnabled: buttonEnabled ?? this.buttonEnabled,
      selectedNeed: selectedNeed ?? this.selectedNeed,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props {
    return <Object>[
      status,
      errorMessage,
      buttonEnabled,
      selectedNeed,
      type,
    ];
  }
}
