// ignore_for_file: unused_field
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/add_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_chart.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/search_artist.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';

part 'search_page_state.dart';

@injectable
class SearchPageCubit extends BaseCubit<SearchPageState> {
  SearchPageCubit(
    this.getUserUseCase,
    this.removeLikeUseCase,
    this.addLikeUseCase,
    this.editArtistInCollectionUseCase,
    this.getArtistChartUseCase,
    this._getTotalGenreSubgenreUseCase,
    this.getGenresUseCase,
    this.getSubgenreUseCase,
    this._remoteTracksDataSource,
    this._searchArtistUseCase,
    this._getAllLikedArtistsUseCase,
  ) : super(const SearchPageState());

  static SearchPageCubit create([String? subgenre]) {
    return GetIt.I<SearchPageCubit>()..init(subgenre);
  }

  final GetUserStreamUseCase getUserUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final AddLikeUseCase addLikeUseCase;
  final EditArtistInCollectionUseCase editArtistInCollectionUseCase;
  final GetArtistChartUseCase getArtistChartUseCase;
  final GetGenresUseCase getGenresUseCase;
  final GetSubgenreUseCase getSubgenreUseCase;
  final GetTotalGenreSubgenreUseCase _getTotalGenreSubgenreUseCase;
  final RemoteTracksDataSource _remoteTracksDataSource;
  final SearchArtistUseCase _searchArtistUseCase;
  final GetAllLikedArtistsUseCase _getAllLikedArtistsUseCase;

  Future<void> init([String? subgenre]) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: SearchStatus.loading));

      handleStream(
        '_getUserStreamUseCase',
        getUserUseCase.execute(),
        (UserModel? user) async {
          if (user == null) return;

          final List<Genre> genreObjects = await getGenresUseCase();
          final List<String> genresName =
              genreObjects.map((Genre e) => e.name).toList();
          final List<SubgenreLiked> allSubgenres = await getSubgenreUseCase();
          final List<GenreSubgenresTotal> genres =
              await _getTotalGenreSubgenreUseCase(
            genresName,
            allSubgenres,
          );
          final List<ArtistChartDto> artists =
              await _getAllLikedArtistsUseCase(user.likes);

          emit(
            state.copyWith(
              user: user,
              likedArtists: artists.reversed.toList(),
              genres: genres,
              status: SearchStatus.initial,
            ),
          );
        },
      );
    });
  }

  void setIndex(int? index) {
    emit(state.copyWith(index: index));
  }

  Future<void> filterArtists(String query) async {
    await performSafeAction(() async {
      if (query.isEmpty) {
        emit(
          state.copyWith(
            status: SearchStatus.initial,
            query: '',
          ),
        );
        return;
      }

      emit(state.copyWith(status: SearchStatus.loading));

      final List<ArtistChartDto> artists = await _searchArtistUseCase(query);
      emit(
        state.copyWith(
          //  tracks: await _remoteTracksDataSource.searchTrack(query),
          filteredArtists: artists.sorted((ArtistChartDto a, ArtistChartDto b) {
            final int aInlikedArtists = likedArtistsIndexOfArtists(a.id);
            final int bInlikedArtists = likedArtistsIndexOfArtists(b.id);
            if (aInlikedArtists != -1 && bInlikedArtists != -1) {
              return aInlikedArtists.compareTo(bInlikedArtists);
            }
            if (aInlikedArtists != -1) return -1;
            if (bInlikedArtists != -1) return 1;

            return b.likes.compareTo(a.likes);
          }),
          status: SearchStatus.initial,
          query: query,
        ),
      );
    });
  }

  int likedArtistsIndexOfArtists(String id) {
    for (int i = 0; i < state.likedArtists.length; i++) {
      if (state.likedArtists[i].id == id) return i;
    }
    return -1;
  }

  void setCurrentArtist(String artistId) {
    emit(state.copyWith(currentArtist: artistId));
  }

  Future<void> addArtistToLiked(
    ArtistChartDto artist,
    List<String> collections,
  ) async {
    await performSafeAction(() async {
      await addLikeUseCase(artist.id, collections);
    });
  }

  Future<void> editArtistCollections(
    ArtistChartDto artist,
    List<String> collections,
  ) async {
    await performSafeAction(() async {
      await editArtistInCollectionUseCase(artist, collections);
    });
  }

  Future<void> unlikeArtist(ArtistChartDto artist) async {
    await performSafeAction(() async {
      await removeLikeUseCase(artist, null);

      emit(
        state.copyWith(
          status: SearchStatus.unlikeArtist,
          artist: artist,
        ),
      );
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: SearchStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
