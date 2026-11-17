import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/feedback_type.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/create_feedback.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/file_service.dart';
import 'package:kingfishertom/features/presentation/common_pages/feedback/cubit/feedback_state.dart';

@injectable
class FeedbackCubit extends BaseCubit<FeedbackState> {
  FeedbackCubit(
    this.createFeedbackUseCase,
    this.fileService,
  ) : super(const FeedbackState());

  static FeedbackCubit create() {
    return GetIt.I<FeedbackCubit>();
  }

  final CreateFeedbackUseCase createFeedbackUseCase;
  final FileService fileService;

  void init([FeedbackType? initialType]) {
    emit(state.copyWith(type: initialType));
  }

  Future<void> createFeedback(
    FeedbackDto feedbackDto,
    List<File> files, {
    required ArtistChartDto? artist,
  }) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: FeedbackStatus.loading));

      await createFeedbackUseCase(
        feedbackDto,
        files,
        artist: artist,
      );
      emit(state.copyWith(status: FeedbackStatus.success));
    });
  }

  Future<void> setButtonEnabled({required bool buttonEnabled}) async {
    await performSafeAction(() async {
      emit(state.copyWith(buttonEnabled: buttonEnabled));
    });
  }

  Future<void> setFeedbackType(FeedbackType type) async {
    await performSafeAction(() async {
      emit(state.copyWith(type: type));
    });
  }

  Future<void> pickFile(ValueSetter<List<File>> onComplete) async {
    await performSafeAction(() async {
      await fileService.pickFile(onComplete);
    });
  }

  void selectNeeds(String need) {
    if (!state.selectedNeed.contains(need)) {
      emit(state.copyWith(selectedNeed: <String>[...state.selectedNeed, need]));
      return;
    }
    final List<String> needs = <String>[...state.selectedNeed]..remove(need);

    emit(state.copyWith(selectedNeed: needs));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
