import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/swipe.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/local.swipes.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_app_user_level.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_badges.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/update_photo.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/update_user.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/file_service.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';

part 'profile_page_state.dart';

@injectable
class ProfilePageCubit extends BaseCubit<ProfilePageState> {
  ProfilePageCubit(
    this.getUserUseCase,
    this.getBadgesUseCase,
    this.localSwipesDataSource,
    this.getTotalGenreSubgenreUseCase,
    this.getLevelUseCase,
    this.fileService,
    this.updatePhotoUseCase,
    this.updateUserUseCase,
  ) : super(const ProfilePageState());

  static ProfilePageCubit create() {
    return GetIt.I<ProfilePageCubit>()..init();
  }

  final GetUserStreamUseCase getUserUseCase;
  final GetBadgesUseCase getBadgesUseCase;
  final LocalSwipesDataSource localSwipesDataSource;
  final GetTotalGenreSubgenreUseCase getTotalGenreSubgenreUseCase;
  final GetAppUserLevelUseCase getLevelUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UpdatePhotoUseCase updatePhotoUseCase;
  final FileService fileService;

  Future<void> init() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: MenuStatus.loading));

      handleStream(
        '_getUserStreamUseCase',
        getUserUseCase.execute(),
        (UserModel? user) async {
          final Map<LevelValueType, Object> levelUseCase =
              await getLevelUseCase();
          emit(
            state.copyWith(
              status: MenuStatus.initial,
              user: user,
              level: levelUseCase[LevelValueType.levelData]! as LevelDto,
              badges: await getBadgesUseCase(),
              swipe: await localSwipesDataSource.getSwipeInfo(),
            ),
          );
        },
      );
    });
  }

  void setIndex(int index) {
    emit(state.copyWith(index: index));
  }

  Future<void> updatePhoto(File photo) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: MenuStatus.loading));

      final String imageUrl = await updatePhotoUseCase(photo);

      await updateUserUseCase(
        <String, String>{'imageUrl': imageUrl},
      );

      if (state.user != null) {
        await getIt<UserModelStream>()
            .updateSaveUserModel(state.user!.update(imageUrl: imageUrl));
      }
    });
  }

  Future<void> pickProfilePhoto({
    required ValueSetter<File> onComplete,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    await performSafeAction(() async {
      await fileService.pickProfilePhoto(
        onComplete: onComplete,
        uiSettings: uiSettings,
      );
    });
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: MenuStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
