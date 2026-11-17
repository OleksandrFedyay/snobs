import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/complete_task.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_chart.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_overrides.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';

part 'library_page_state.dart';

@injectable
class LibraryPageCubit extends BaseCubit<LibraryPageState> {
  LibraryPageCubit(
    this.getUserUseCase,
    this.localAppInfoDataSource,
    this.getAllLikedArtistsUseCase,
    this.getTotalGenreSubgenreUseCase,
    this.getGenresUseCase,
    this.getSubgenreUseCase,
    this.getArtistOverridesUseCase,
    this.completeTaskUseCase,
  ) : super(const LibraryPageState());

  static LibraryPageCubit create() {
    return GetIt.I<LibraryPageCubit>()..init();
  }

  final GetUserStreamUseCase getUserUseCase;
  final LocalAppInfoDataSource localAppInfoDataSource;
  final GetAllLikedArtistsUseCase getAllLikedArtistsUseCase;
  final GetTotalGenreSubgenreUseCase getTotalGenreSubgenreUseCase;
  final GetGenresUseCase getGenresUseCase;
  final GetSubgenreUseCase getSubgenreUseCase;
  final GetArtistOverridesUseCase getArtistOverridesUseCase;
  final CompleteTaskUseCase completeTaskUseCase;

  Future<void> init() async {
    await performSafeAction(() async {
      if (isClosed) return;
      emit(state.copyWith(status: LibraryTabStatus.loading));

      //Todo(Issa): Listener that relies on the User stream and will be instead of [getUserUseCase.execute()]
      /*    getIt<UserModelStream>().userModelCurrentStream.listen((UserModel? user) {
        debugPrint('User loaded or updated: ${user?.likes.length}');
      });
*/
      handleStream(
        '_getUserStreamUseCase',
        getUserUseCase.execute(),
        (UserModel? user) async {
          if (user == null) return;
          final Iterable<ArtistCollectionDto> collections =
              user.collections.map(
            ArtistCollectionDto.fromJson,
          );

          final List<ArtistChartDto> likedArtist =
              await getAllLikedArtistsUseCase(user.likes);
          if (isClosed) return;

          final List<Genre> genreObjects = await getGenresUseCase();
          final List<String> genresName =
              genreObjects.map((Genre e) => e.name).toList();
          final List<SubgenreLiked> allSubgenres = await getSubgenreUseCase();

          final List<ArtistSubgenres> overrides =
              await getArtistOverridesUseCase();
          for (final ArtistSubgenres over in overrides) {
            final int index = likedArtist
                .indexWhere((ArtistChartDto e) => e.id == over.artistId);
            if (index >= 0) {
              likedArtist.replaceRange(
                index,
                index + 1,
                <ArtistChartDto>[
                  likedArtist[index].copyWith(subgenres: over.subgenres)
                ],
              );
            }
          }

          final List<GenreSubgenresTotal> totalGenres =
              await getTotalGenreSubgenreUseCase(
            genresName,
            allSubgenres,
          );
          totalGenres.sort((GenreSubgenresTotal a, GenreSubgenresTotal b) {
            if (b.likesCount == a.likesCount) {
              return a.genre.compareTo(b.genre);
            }
            return b.likesCount.compareTo(a.likesCount);
          });

          emit(
            state.copyWith(
              status: LibraryTabStatus.initial,
              likedArtist: likedArtist,
              user: user,
              isExploreLibraryTaskCompleted:
                  user.completedTasks.contains(StringsRes.exploreLibraryTaskId),
              genres: totalGenres.map((GenreSubgenresTotal total) {
                final List<SubgenresArtistsDto> subgenres = total.subgenres
                    .map(
                      (SubgenreLiked sub) => SubgenresArtistsDto(
                        artists: likedArtist
                            .where((ArtistChartDto a) =>
                                a.subgenres.contains(sub.subGenre))
                            .toList(),
                        subgenreLiked: sub,
                      ),
                    )
                    .toList()
                  ..sort(
                    (SubgenresArtistsDto a, SubgenresArtistsDto b) =>
                        b.artists.length.compareTo(a.artists.length),
                  );

                return TotalLibraryGenreDto(
                  genre: total.genre,
                  totalSubgenres: subgenres,
                  likesCount: total.likesCount,
                );
              }).toList(),
              collections: collections.toList(),
            ),
          );
        },
      );
    });
  }

  //Todo(Issa): Need to show tool tip when the User got the premium account from Profile Page
  /* Future<void> updateStatus() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: LibraryTabStatus.loading));

      emit(
        state.copyWith(
          status: LibraryTabStatus.initial,
        ),
      );
    });
  }*/

  Future<void> update() async {
    if (isClosed) return;
    await performSafeAction(() async {
      if (isClosed) return;

      final List<ArtistChartDto> likedArtist = <ArtistChartDto>[
        ...state.likedArtist
      ];
      final List<ArtistSubgenres> overrides = await getArtistOverridesUseCase();
      for (final ArtistSubgenres over in overrides) {
        final int index =
            likedArtist.indexWhere((ArtistChartDto e) => e.id == over.artistId);
        if (index >= 0) {
          likedArtist.replaceRange(
            index,
            index + 1,
            <ArtistChartDto>[
              likedArtist[index].copyWith(subgenres: over.subgenres)
            ],
          );
        }
      }

      if (isClosed) return;
      emit(
        state.copyWith(
          status: LibraryTabStatus.initial,
          likedArtist: likedArtist,
        ),
      );
    });
  }

  Future<void> completedExploreLibraryTask() async {
    await completeTaskUseCase(StringsRes.exploreLibraryTaskId);

    emit(state.copyWith(isExploreLibraryTaskCompleted: true));
  }

  Future<void> setShowMyCollection({required bool showMyCollection}) async {
    emit(state.copyWith(showMyCollection: showMyCollection));
  }

  Future<void> setCurrentCollection(String currentCollection) async {
    emit(state.copyWith(currentCollection: currentCollection));
  }

  Future<void> addCollection(String name) async {
    emit(
      state.copyWith(
        collections: <ArtistCollectionDto>[
          ...state.collections,
          ArtistCollectionDto(name: name),
        ],
      ),
    );
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: LibraryTabStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
