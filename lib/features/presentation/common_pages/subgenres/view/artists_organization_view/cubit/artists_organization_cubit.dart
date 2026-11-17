import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_subgenre.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/user_overrides.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';

part 'artists_organization_state.dart';

@injectable
class ArtistsOrganizationCubit extends BaseCubit<ArtistsOrganizationState> {
  ArtistsOrganizationCubit(
    this.getGenresUseCase,
    this._getTotalGenreSubgenreUseCase,
    this.getSubgenreUseCase,
    this._updateUserOverridesUseCase,
    this._firebaseAuth,
    this._editArtistsInCollectionUseCase,
  ) : super(const ArtistsOrganizationState());

  static ArtistsOrganizationCubit create() {
    return GetIt.I<ArtistsOrganizationCubit>();
  }

  final GetGenresUseCase getGenresUseCase;
  final FirebaseAuth _firebaseAuth;
  final GetSubgenreUseCase getSubgenreUseCase;
  final GetTotalGenreSubgenreUseCase _getTotalGenreSubgenreUseCase;
  final UpdateUserOverridesUseCase _updateUserOverridesUseCase;
  final EditArtistsInCollectionUseCase _editArtistsInCollectionUseCase;

  Future<void> init(
    List<ArtistChartDto> artists,
    List<ArtistCollectionDto> artistCollections,
  ) async {
    await performSafeAction(() async {
      if (isClosed) return;
      emit(state.copyWith(status: ArtistsOrganizationStatus.loading));

      final List<Genre> genreObjects = await getGenresUseCase();
      final List<String> genresName =
          genreObjects.map((Genre e) => e.name).toList();
      final List<SubgenreLiked> subs = await getSubgenreUseCase();

      final List<GenreSubgenresTotal> totalGenres =
          await _getTotalGenreSubgenreUseCase(genresName, subs);

      final List<String> subgenres = <String>[];
      for (final String sub in artists.first.subgenres) {
        if (_eachArtistsHaveSubgenre(artists, sub)) {
          subgenres.add(sub);
        }
      }

      emit(
        state.copyWith(
          artistCollections: artistCollections,
          status: ArtistsOrganizationStatus.initial,
          userId: _firebaseAuth.currentUser?.uid,
          genreSubgenres: totalGenres,
          subgenres: subgenres,
        ),
      );
    });
  }

  void addCollection(String newCollection) {
    emit(
      state.copyWith(
        artistCollections: <ArtistCollectionDto>[
          ...state.artistCollections,
          ArtistCollectionDto(name: newCollection),
        ],
        status: ArtistsOrganizationStatus.initial,
      ),
    );
  }

  void selectCollection(String collection) {
    if (!state.selectedArtistCollections.contains(collection)) {
      emit(
        state.copyWith(
          selectedArtistCollections: <String>[
            ...state.selectedArtistCollections,
            collection,
          ],
          status: ArtistsOrganizationStatus.initial,
        ),
      );

      return;
    }

    final List<String> selectedCollections = <String>[
      ...state.selectedArtistCollections
    ]..remove(collection);

    emit(
      state.copyWith(
        selectedArtistCollections: selectedCollections,
        status: ArtistsOrganizationStatus.initial,
      ),
    );
  }

  void removeSubgenre(String subgenre) {
    final List<String> subgenres = <String>[...state.subgenres]
      ..remove(subgenre);

    emit(
      state.copyWith(
        subgenres: subgenres,
        status: ArtistsOrganizationStatus.initial,
      ),
    );
  }

  void setQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void setSubgenres(List<String> subgenres) {
    emit(
      state.copyWith(
        subgenres: subgenres,
        status: ArtistsOrganizationStatus.initial,
      ),
    );
  }

  bool _eachArtistsHaveSubgenre(List<ArtistChartDto> artists, String sub) {
    for (final ArtistChartDto a in artists) {
      if (!a.subgenres.contains(sub)) return false;
    }
    return true;
  }

  Future<void> update(List<ArtistChartDto> artists) async {
    emit(state.copyWith(status: ArtistsOrganizationStatus.loadingButton));
    await _editArtistsInCollectionUseCase(
      artists,
      state.selectedArtistCollections,
    );
    for (final ArtistChartDto a in artists) {
      await _updateUserOverridesUseCase(a, state.subgenres);
    }
    emit(state.copyWith(status: ArtistsOrganizationStatus.success));
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: ArtistsOrganizationStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
