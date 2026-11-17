import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_like_dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/add_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_chart.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_chart_tracks.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_liked_subgenre_tracks.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_top_snobs_users.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_overrides.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

part 'subgenres_page_state.dart';

@injectable
class SubgenrePageCubit extends BaseCubit<SubgenrePageState> {
  SubgenrePageCubit(
    this._getUserUseCase,
    this._getAllLikedArtistsUseCase,
    this._addLikeUseCase,
    this._editArtistInCollectionUseCase,
    this._removeLikeUseCase,
    this._getArtistOverridesUseCase,
    this._localAppInfoDataSource,
    this._updateUserOverridesUseCase,
    this._getArtistChartUseCase,
    this._getChartTracksUseCase,
    this._getSnobsTopUsersUseCase,
    this._getGenreSubgenreUseCase,
    this._getLikedSubgenreTrackUseCase,
  ) : super(const SubgenrePageState());

  static SubgenrePageCubit create(
    String genre,
    String subgenre,
    GenrePageType genrePageType,
  ) {
    return GetIt.I<SubgenrePageCubit>()..init(genre, subgenre, genrePageType);
  }

  final GetUserStreamUseCase _getUserUseCase;
  final GetAllLikedArtistsUseCase _getAllLikedArtistsUseCase;
  final AddLikeUseCase _addLikeUseCase;
  final EditArtistInCollectionUseCase _editArtistInCollectionUseCase;
  final RemoveLikeUseCase _removeLikeUseCase;
  final GetArtistOverridesUseCase _getArtistOverridesUseCase;

  // ignore_for_file: unused_field
  final LocalAppInfoDataSource _localAppInfoDataSource;
  final UpdateUserOverridesUseCase _updateUserOverridesUseCase;
  final GetArtistChartUseCase _getArtistChartUseCase;
  final GetChartTracksUseCase _getChartTracksUseCase;
  final GetSnobsSubgenreTopUsersUseCase _getSnobsTopUsersUseCase;
  final GetGenreSubgenreUseCase _getGenreSubgenreUseCase;
  final GetLikedSubgenreTrackUseCase _getLikedSubgenreTrackUseCase;
  String _subgenre = '';
  String _userId = '';
  String _description = '';
  List<Track>? _likedSongs;
  List<ArtistChartDto>? _chartArtists;
  List<Track>? _chartSongs;
  List<UserLikeDto>? _chartFans;

  Future<void> init(
    String genre,
    String subgenre,
    GenrePageType genrePageType,
  ) async {
    await performSafeAction(() async {
      _subgenre = subgenre.toLowerCase();

      ///Supplies
      if (genrePageType == GenrePageType.subgenre) {
        final List<Subgenre> listOfSubgenresOfSelectedGenre =
            await _getGenreSubgenreUseCase(genre);
        _description = listOfSubgenresOfSelectedGenre
            .firstWhere((Subgenre s) => s.name == subgenre)
            .description;
      } else {
        _description = genre.genreStingToEnum.genreDesc;
      }

      emit(
        state.copyWith(
          status: SubgenrePageStatus.loading,
          genre: genre.genreStingToEnum,
          subgenre: subgenre,
          genrePageType: genrePageType,
          genreSubgenreDescription: _description,
        ),
      );

      await isTrialOrSubscriptionActive;

      handleStream(
        '_getUserStreamUseCase',
        _getUserUseCase.execute(),
        (UserModel? user) async {
          if (user == null) return;
          _userId = user.id;
          final List<ArtistChartDto> artists =
              await _getAllLikedArtistsUseCase(user.likes);

          final List<ArtistSubgenres> overrides =
              await _getArtistOverridesUseCase();
          for (final ArtistSubgenres over in overrides) {
            final int index =
                artists.indexWhere((ArtistChartDto e) => e.id == over.artistId);
            if (index >= 0) {
              artists.replaceRange(
                index,
                index + 1,
                <ArtistChartDto>[
                  artists[index].copyWith(subgenres: over.subgenres)
                ],
              );
            }
          }
          List<ArtistChartDto> artistsData = <ArtistChartDto>[];
          if (genrePageType == GenrePageType.genre) {
            final List<String> subgenres =
                await getIt<RemoteLikeGenreDataSource>().getSubgenres(genre);

            artistsData = artists
                .where((ArtistChartDto artist) =>
                    artist.subgenres.any(subgenres.contains))
                .toList();
          } else {
            artistsData = artists
                .where((ArtistChartDto artist) =>
                    artist.subgenres.contains(subgenre))
                .toList();
          }

          if (isClosed) return;
          emit(
            state.copyWith(
              user: user,
              overrides: overrides,
              artists: artistsData.reversed.toList(),
              status: SubgenrePageStatus.initial,
            ),
          );
        },
      );
    });
  }

  void setIndex(int index) {
    emit(state.copyWith(index: index));
  }

  //Todo(Issa):  Need to add separate page status for each page like [Fans, Chart songs]
  ///Switches ToggleButton indexes: 0 - Artists, 1 - Songs, 2 - Fans.
  Future<void> setToggleButtonIndex({int? toggleButtonIndex}) async {
    emit(
      state.copyWith(
        toggleButtonIndex: toggleButtonIndex,
        chosenSortByMethod: SortByMethod.topArtist,
      ),
    );

    /// ChosenResource.myLiked
    if (state.chosenResource == ChosenResource.myLiked) {
      if (toggleButtonIndex == 1 && _likedSongs == null) {
        await performSafeAction(() async {
          emit(state.copyWith(status: SubgenrePageStatus.loading));
          _likedSongs = await _getLikedSubgenreTrackUseCase(_userId, _subgenre);

          emit(state.copyWith(
            likedSongs: _likedSongs,
            status: SubgenrePageStatus.initial,
          ));
        });
      }
    } else {
      /// ChosenResource.global
      if (toggleButtonIndex == 0 && _chartArtists == null) {
        await performSafeAction(() async {
          emit(state.copyWith(status: SubgenrePageStatus.loading));
          _chartArtists = await _getArtistChartUseCase(_subgenre);

          emit(state.copyWith(
            artistsChart: _chartArtists,
            status: SubgenrePageStatus.initial,
          ));
        });
      } else if (toggleButtonIndex == 1 && _chartSongs == null) {
        await performSafeAction(() async {
          emit(state.copyWith(
              statusChartsSongs: SubgenreChartsSongsPageStatus.loading));

          _chartSongs = await _getChartTracksUseCase(_subgenre);

          emit(state.copyWith(
            songsCharts: _chartSongs,
            statusChartsSongs: SubgenreChartsSongsPageStatus.initial,
          ));
        });
      } else if (toggleButtonIndex == 2 && _chartFans == null) {
        await performSafeAction(() async {
          emit(state.copyWith(statusFans: SubgenreFansPageStatus.loading));

          _chartFans = await _getSnobsTopUsersUseCase(_subgenre);

          emit(state.copyWith(
            topSnobsUsers: _chartFans,
            statusFans: SubgenreFansPageStatus.initial,
          ));
        });
      }
    }
  }

  void setCurrentArtist(String artistId) {
    emit(state.copyWith(currentArtist: artistId));
  }

  Future<void> addArtistToLiked(
    ArtistChartDto artist,
    List<String> collections,
  ) async {
    await performSafeAction(() async {
      await _addLikeUseCase(artist.id, collections);
    });
  }

  Future<void> editArtistCollections(
    ArtistChartDto artist,
    List<String> collections,
  ) async {
    await performSafeAction(() async {
      await _editArtistInCollectionUseCase(artist, collections);
    });
  }

  void setUpdate({required bool update}) {
    emit(state.copyWith(update: update));
  }

  void selectArtist(ArtistChartDto artist) {
    emit(state.copyWith(
        selectedArtists: <ArtistChartDto>[...state.selectedArtists, artist]));
  }

  void unselectArtist(ArtistChartDto artist) {
    final List<ArtistChartDto> selectedArtists = <ArtistChartDto>[
      ...state.selectedArtists
    ]..remove(artist);
    emit(state.copyWith(selectedArtists: selectedArtists));
  }

  void selectAllArtist(List<ArtistChartDto> artists) {
    emit(state.copyWith(selectedArtists: artists));
  }

  Future<void> updateArtistOverrides(
    ArtistChartDto artist,
    List<String> subgenres,
  ) async {
    await _updateUserOverridesUseCase(
      artist,
      subgenres,
    );

    emit(state.copyWith(status: SubgenrePageStatus.initial));
  }

  Future<void> unlikeArtist(ArtistChartDto artist) async {
    await performSafeAction(() async {
      await _removeLikeUseCase(artist, null);

      emit(
        state.copyWith(
          status: SubgenrePageStatus.unlikeArtist,
          artist: artist,
        ),
      );
    });
  }

  Future<void> selectResource(ChosenResource? chosenResource) async {
    emit(state.copyWith(chosenResource: chosenResource));
    await setToggleButtonIndex(toggleButtonIndex: 0);
  }

  void selectSortByMethod(SortByMethod? chosenSortByMethod) {
    emit(state.copyWith(chosenSortByMethod: chosenSortByMethod));
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: SubgenrePageStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
