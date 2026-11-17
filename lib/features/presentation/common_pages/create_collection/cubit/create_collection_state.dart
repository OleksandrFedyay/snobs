

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CreateCollectionStatus {
  initial,
  error,
  loading,
  success,
}

@immutable
class CreateCollectionState extends Equatable {

  const CreateCollectionState({
    this.status = CreateCollectionStatus.initial,
    this.errorMessage = '',
    this.name = '',
  });
  final CreateCollectionStatus status;
  final String errorMessage;
  final String name;

  CreateCollectionState copyWith({
    CreateCollectionStatus? status,
    String? errorMessage,
    String? name,
  }) {
    return CreateCollectionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => <Object>[status, errorMessage, name];
}
