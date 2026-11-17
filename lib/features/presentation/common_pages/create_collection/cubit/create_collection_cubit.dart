import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/create_collection.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/create_collection/cubit/create_collection_state.dart';

@injectable
class CreateCollectionCubit extends BaseCubit<CreateCollectionState> {
  CreateCollectionCubit(this.createCollectionUseCase)
      : super(const CreateCollectionState());

  static CreateCollectionCubit create() {
    return GetIt.I<CreateCollectionCubit>();
  }

  final CreateCollectionUseCase createCollectionUseCase;

  Future<void> createCollection() async {
    await performSafeAction(() async {
      if (state.name.isEmpty) return;
      emit(state.copyWith(status: CreateCollectionStatus.loading));

      await createCollectionUseCase(state.name);
      emit(
        state.copyWith(
          status: CreateCollectionStatus.success,
        ),
      );
    });
  }

  void setName(String? name) {
    emit(state.copyWith(name: name?.trim()));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: CreateCollectionStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
