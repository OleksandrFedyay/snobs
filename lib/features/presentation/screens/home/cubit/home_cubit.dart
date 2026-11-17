import 'dart:math';

import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/local.swipes.data_source.impl.dart';
import 'package:kingfishertom/core/data/local_data/user_model_stream.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/end_trial.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/unlock_subgenre.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  HomeCubit(
    this.localAppInfoDataSource,
    this.getGenresUseCase,
    this.getSubgenreUseCase,
    this.getTotalGenreSubgenreUseCase,
    this.localSwipesDataSource,
    this.getUserStreamUseCase,
    this.endTrialUseCase,
    this.unlockSubgenreUseCase,
  ) : super(const HomeState());

  final LocalAppInfoDataSource localAppInfoDataSource;
  final GetGenresUseCase getGenresUseCase;
  final GetSubgenreUseCase getSubgenreUseCase;
  final GetTotalGenreSubgenreUseCase getTotalGenreSubgenreUseCase;
  final LocalSwipesDataSource localSwipesDataSource;
  final GetUserStreamUseCase getUserStreamUseCase;
  final EndTrialUseCase endTrialUseCase;
  final UnlockSubgenreUseCase unlockSubgenreUseCase;

  static HomeCubit create() {
    return GetIt.I<HomeCubit>()..loadGenresAndSubgenres();
  }

  Future<void> loadGenresAndSubgenres() async {
    handleStream(
      '_getUserStreamUseCase',
      getUserStreamUseCase.execute(),
      (UserModel? user) async {
        if (user == null) return;

        final List<Genre> genreObjects = await getGenresUseCase();
        final List<String> genresName =
            genreObjects.map((Genre e) => e.name).toList();
        final List<SubgenreLiked> allSubgenres = await getSubgenreUseCase();
        final String genre = localAppInfoDataSource.getGenre();
        final String subgenre = localAppInfoDataSource.getSubgenre();
        final String selectedGenreOrSub =
            localAppInfoDataSource.getSelectedGenreOrSub();
        final List<GenreSubgenresTotal> genresSubgenres =
            await getTotalGenreSubgenreUseCase(
          genresName,
          allSubgenres,
        );

        final List<String> genresAndSubgenresRandomItems = <String>[];
        for (final GenreSubgenresTotal item in genresSubgenres) {
          genresAndSubgenresRandomItems.add(item.genre);
          genresAndSubgenresRandomItems.addAll(
              item.totalSubgenres.map((SubgenreLiked sub) => sub.subGenre));
        }

        emit(
          state.copyWith(
            subGenre: subgenre,
            genre: genre,
            selectedGenreOrSubGenre: selectedGenreOrSub,
            libraryGenre: genre,
            genresAndSubgenresRandomItems: genresAndSubgenresRandomItems,
            librarySubgenre: subgenre,
            genresSubgenres: genresSubgenres,
            user: user,
            isGenreWithAllWord: localAppInfoDataSource.getIsGenreWithAllWord(),
          ),
        );
      },
    );
  }

  Future<void> showTutorial() async {
    emit(
      state.copyWith(
        subGenre: localAppInfoDataSource.getSubgenre(),
        genre: localAppInfoDataSource.getGenre(),
        libraryGenre: localAppInfoDataSource.getGenre(),
        librarySubgenre: localAppInfoDataSource.getSubgenre(),
      ),
    );
  }

  Future<void> setGenre(String genre, String subgenre) async {
    await performSafeAction(() async {
      if (subgenre.isNotEmpty) {
        if (state.user != null) {
          await getIt<UserModelStream>().updateSaveUserModel(state.user!.update(
            unlockedSubgenres: <String>{
              ...state.user?.unlockedSubgenres
                      .where((String s) => s.isNotEmpty) ??
                  <String>[],
              subgenre,
            }.toList(),
          ));
        }
      }

      await localAppInfoDataSource.setSubgenre(subgenre);
      await localAppInfoDataSource.setGenre(genre);
      await localAppInfoDataSource.setIsGenreWithAllWord(
          value: subgenre.isEmpty);

      final String selectedGenreOrSubGenre =
          subgenre.isNotEmpty ? subgenre : genre;
      await localAppInfoDataSource
          .setSelectedGenreOrSub(selectedGenreOrSubGenre);

      emit(
        state.copyWith(
          subGenre: subgenre,
          genre: genre,
          isGenreWithAllWord: subgenre.isEmpty,
          selectedGenreOrSubGenre: selectedGenreOrSubGenre,
          libraryGenre: genre,
          librarySubgenre: subgenre,
        ),
      );
    });
  }

  Future<void> setLibraryGenre(String genre) async {
    emit(state.copyWith(libraryGenre: genre));
  }

  Future<void> setLibrarySubgenre(String subgenre) async {
    emit(state.copyWith(librarySubgenre: subgenre));
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }

  void updateSelectedGenreDialogue(String genre) {
    setIsOnSetGenreDialogue(genre.isNotEmpty);
    emit(state.copyWith(currentGenreDialogue: genre));
  }

  void setIsOnSetGenreDialogue(bool value) {
    emit(state.copyWith(isOnSetGenreDialogue: value));
  }

  void setSelectedRandomGenreDialogue(String value) {
    emit(state.copyWith(selectedRandomGenreDialogue: value));
  }

  void setIsFirstScrollGenreDialogue(bool value) {
    emit(state.copyWith(isFirstScrollGenreDialogue: value));
  }

  final Set<String> _usedGenreSubgenreItems = <String>{};

  void randomGenreSubgenre({bool isFromSwipePage = true}) {
    /// Clear Used Genre Subgenre Items if all items have been used
    if (_usedGenreSubgenreItems.length ==
        state.genresAndSubgenresRandomItems.length) {
      _usedGenreSubgenreItems.clear();
    }

    /// Pick a random a new unique item
    final Random random = Random();
    String selectedGenreOrSub = '';
    do {
      selectedGenreOrSub = state.genresAndSubgenresRandomItems[
          random.nextInt(state.genresAndSubgenresRandomItems.length)];
    } while (_usedGenreSubgenreItems.contains(selectedGenreOrSub));

    /// Add [selectedGenreOrSub] to [_usedGenreSubgenreItems] to avoid repetition
    _usedGenreSubgenreItems.add(selectedGenreOrSub);

    final String? selectedGenre =
        state.genresSubgenres.firstWhereOrNull((GenreSubgenresTotal g) {
      for (final SubgenreLiked s in g.subgenres) {
        if (s.subGenre == selectedGenreOrSub) return true;
      }
      return false;
    })?.genre;

    //Note: If [selectedGenre] is null, its meaning [selectedGenreOrSub] is a Genre not a Subgenre.
    if (isFromSwipePage) {
      setGenre(
        selectedGenre ?? selectedGenreOrSub,
        selectedGenre == null ? '' : selectedGenreOrSub,
      );
    } else {
      setIsOnSetGenreDialogue(false);
      setIsFirstScrollGenreDialogue(true);
      emit(state.copyWith(
        currentGenreDialogue: selectedGenre ?? selectedGenreOrSub,
      ));
      setSelectedRandomGenreDialogue(selectedGenreOrSub);
    }
  }

  @override
  void handleError(String errorMessage) {
    emit(const HomeState());
  }
}
