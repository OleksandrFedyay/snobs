import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/update_photo.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/update_user.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/file_service.dart';

part 'profile_edit_state.dart';

@injectable
class ProfileEditCubit extends BaseCubit<ProfileEditState> {
  ProfileEditCubit(
    this.getUserUseCase,
    this.updateUserUseCase,
    this.updatePhotoUseCase,
    this.fileService,
  ) : super(const ProfileEditState());

  static ProfileEditCubit create() {
    return GetIt.I<ProfileEditCubit>()..init();
  }

  final GetUserStreamUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UpdatePhotoUseCase updatePhotoUseCase;
  final FileService fileService;

  Future<void> init() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: ProfileStatus.loading));

      handleStream(
        '_getUserStreamUseCase',
        getUserUseCase.execute(),
        (UserModel? user) async {
          emit(
            state.copyWith(
              status: ProfileStatus.initial,
              user: user,
            ),
          );
        },
      );
    });
  }

  Future<void> updatePhoto(File photo) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: ProfileStatus.loading));

      final String imageUrl = await updatePhotoUseCase(photo);

      await updateUserUseCase(
        <String, dynamic>{'imageUrl': imageUrl},
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

  Future<void> updateUser(Map<String, dynamic> data) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: ProfileStatus.loading));
      final Map<String, dynamic> updatedData = <String, dynamic>{...data};
      if (data['email'] == state.user?.email) updatedData.remove('email');

      await updateUserUseCase(updatedData);

      await getIt<UserModelStream>()
          .updateSaveUserModel(UserModel.fromJson(updatedData));

      emit(state.copyWith(status: ProfileStatus.success));
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: ProfileStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
