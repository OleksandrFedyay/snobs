import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.user.data_source.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/update_user.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';

part 'name_page_state.dart';

@injectable
class NamePageCubit extends BaseCubit<NamePageState> {
  NamePageCubit(
    this._remoteUserDataSource,
    this._updateUserUseCase,
  ) : super(const NamePageState());

  static NamePageCubit create() {
    return GetIt.I<NamePageCubit>()..init();
  }

  final RemoteUserDataSource _remoteUserDataSource;
  final UpdateUserUseCase _updateUserUseCase;
  late UserModel user;

  Future<void> init() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: NamePageStatus.loadingButton));

      user = await _remoteUserDataSource.getUser();

      emit(
        state.copyWith(
          initialName: user.name,
          status: NamePageStatus.initial,
        ),
      );
    });
  }

  Future<void> saveName(String name) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: NamePageStatus.loadingButton));

      await _updateUserUseCase(<String, dynamic>{'name': name});

      await getIt<UserModelStream>()
          .updateSaveUserModel(user.update(name: name));

      emit(state.copyWith(status: NamePageStatus.success));
    });
  }

  Future<void> setButtonEnabled({required bool buttonEnabled}) async {
    await performSafeAction(() async {
      emit(state.copyWith(buttonEnabled: buttonEnabled));
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: NamePageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
