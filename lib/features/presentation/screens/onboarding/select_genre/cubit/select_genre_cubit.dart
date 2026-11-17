import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';

part 'select_genre_state.dart';

@injectable
class SelectGenreCubit extends BaseCubit<SelectGenreState> {
  SelectGenreCubit(
    this._localAppInfoDataSource,
    this._getGenresUseCase,
  ) : super(const SelectGenreState());

  static SelectGenreCubit create() {
    return GetIt.I<SelectGenreCubit>()..init();
  }

  final LocalAppInfoDataSource _localAppInfoDataSource;
  final GetGenresUseCase _getGenresUseCase;

  Future<void> init() async {
    ///Callable GetGenresUseCase object returns List of Genres Objects.
    final List<Genre> genres = await _getGenresUseCase(updateInfo: true);
    emit(state.copyWith(status: SelectGenreStatus.loading));

    ///Changes the state with the copyWith method by passing List of Genres objects 'g'
    ///and changing status to 'initial'.
    emit(
      state.copyWith(
        status: SelectGenreStatus.initial,
        genres: genres,
      ),
    );
  }

  Future<void> saveGenre() async {
    await performSafeAction(() async {
      await _localAppInfoDataSource.setGenre(state.genre.name);

      emit(state.copyWith(status: SelectGenreStatus.success));
    });
  }

  Future<void> setGenre(String genreName) async {
    final List<Genre> g = await _getGenresUseCase();
    final Genre genre = g.firstWhere((Genre e) => e.name == genreName);
    await performSafeAction(() async {
      emit(state.copyWith(genre: genre));
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: SelectGenreStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
