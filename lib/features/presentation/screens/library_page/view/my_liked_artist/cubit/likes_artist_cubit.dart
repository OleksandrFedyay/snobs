import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/add_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_chart.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user_by_id.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_artist_collection.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_collection.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_like.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

part 'likes_artist_state.dart';

@injectable
class LikesArtistCubit extends BaseCubit<LikesArtistState> {
  LikesArtistCubit(
    this.getUserUseCase,
    this._getAllLikedArtistsUseCase,
    this.removeLikeUseCase,
    this.removeCollectionUseCase,
    this.getUserByIdUseCase,
    this.addLikeUseCase,
    this.removeArtistCollectionUseCase,
    this.editArtistInCollectionUseCase,
  ) : super(const LikesArtistState());

  static LikesArtistCubit create(
    ArtistCollectionDto currentCollection, [
    String? userId,
  ]) {
    return GetIt.I<LikesArtistCubit>()..init(currentCollection, userId);
  }

  final GetUserStreamUseCase getUserUseCase;
  final GetAllLikedArtistsUseCase _getAllLikedArtistsUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final RemoveCollectionUseCase removeCollectionUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final AddLikeUseCase addLikeUseCase;
  final EditArtistInCollectionUseCase editArtistInCollectionUseCase;
  final RemoveArtistCollectionUseCase removeArtistCollectionUseCase;

  Future<void> init(
    ArtistCollectionDto currentCollection, [
    String? userId,
  ]) async {
    await performSafeAction(() async {
      emit(state.copyWith(status: LikesArtistStatus.loading));

      if (userId == null) {
        handleStream(
          '_getUserStreamUseCase',
          getUserUseCase.execute(),
          (UserModel? user) async {
            if (user == null) return;
            final List<ArtistCollectionDto> collections =
                user.collections.map((Map<String, dynamic> collect) {
              return ArtistCollectionDto.fromJson(collect);
            }).toList();

            final ArtistCollectionDto? freshCurrentCollection =
                collections.where((ArtistCollectionDto collect) {
              return collect.name == currentCollection.name;
            }).firstOrNull;

            final List<ArtistChartDto> artists =
                await _getAllLikedArtistsUseCase(
              freshCurrentCollection?.artists ?? currentCollection.artists,
            );

            emit(
              state.copyWith(
                user: user,
                artists: artists.reversed.toList(),
                filteredArtists: artists.reversed.toList(),
                status: LikesArtistStatus.initial,
                currentCollection: freshCurrentCollection,
              ),
            );
          },
        );

        return;
      }

      final UserModel? user = await getUserByIdUseCase(userId);

      final Map<String, dynamic>? collect = user?.collections
          .where((Map<String, dynamic> collect) =>
              collect['name'] == currentCollection.name)
          .firstOrNull;
      if (collect == null) return;

      final List<ArtistChartDto> artists = await _getAllLikedArtistsUseCase(
        ArtistCollectionDto.fromJson(collect).artists,
      );
      emit(
        state.copyWith(
          user: user,
          artists: artists.reversed.toList(),
          filteredArtists: artists.reversed.toList(),
          status: LikesArtistStatus.initial,
          currentCollection: currentCollection,
        ),
      );
    });
  }

  void setShowSearch() {
    if (!state.showSearch) {
      emit(state.copyWith(showSearch: true));
      return;
    }

    final List<ArtistChartDto> filteredArtists = <ArtistChartDto>[
      ...state.artists
    ];
    if (state.sortType == SortType.az) {
      filteredArtists.sort(
        (ArtistChartDto a, ArtistChartDto b) => a.name.compareTo(b.name),
      );
    }

    emit(
      state.copyWith(
        filteredArtists: filteredArtists,
        status: LikesArtistStatus.initial,
        query: '',
        showSearch: false,
      ),
    );
  }

  Future<void> filterArtists(String query, SortType sortType) async {
    await performSafeAction(() async {
      if (query.isEmpty) {
        final List<ArtistChartDto> filteredArtists = <ArtistChartDto>[
          ...state.artists
        ];
        if (sortType == SortType.az) {
          filteredArtists.sort(
            (ArtistChartDto a, ArtistChartDto b) => a.name.compareTo(b.name),
          );
        }

        emit(
          state.copyWith(
            filteredArtists: filteredArtists,
            status: LikesArtistStatus.initial,
            query: query,
            sortType: sortType,
          ),
        );
        return;
      }

      final List<ArtistChartDto> filteredArtists =
          state.artists.where((ArtistChartDto artist) {
        return artist.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (sortType == SortType.az) {
        filteredArtists.sort(
          (ArtistChartDto a, ArtistChartDto b) => a.name.compareTo(b.name),
        );
      }
      emit(
        state.copyWith(
          filteredArtists: filteredArtists,
          status: LikesArtistStatus.initial,
          query: query,
          sortType: sortType,
        ),
      );
    });
  }

  Future<void> deleteCollection() async {
    await performSafeAction(() async {
      emit(state.copyWith(status: LikesArtistStatus.loading));
      await removeCollectionUseCase(state.currentCollection.name);

      await router.pop();
    });
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

  Future<void> removeArtistCollection(
    ArtistChartDto artist,
    String collection,
  ) async {
    await performSafeAction(() async {
      await removeArtistCollectionUseCase(artist, collection);

      final List<ArtistChartDto> artists = <ArtistChartDto>[...state.artists]
        ..remove(artist);
      final List<ArtistChartDto> filteredArtists = <ArtistChartDto>[
        ...state.filteredArtists
      ]..remove(artist);

      emit(
        state.copyWith(
          artists: artists,
          filteredArtists: filteredArtists,
        ),
      );
    });
  }

  Future<void> unlikeArtist(ArtistChartDto artist) async {
    await performSafeAction(() async {
      await removeLikeUseCase(artist, null);

      final List<ArtistChartDto> artists = <ArtistChartDto>[...state.artists]
        ..remove(artist);
      final List<ArtistChartDto> filteredArtists = <ArtistChartDto>[
        ...state.filteredArtists
      ]..remove(artist);

      emit(
        state.copyWith(
          status: LikesArtistStatus.unlikeArtist,
          artist: artist,
          artists: artists,
          filteredArtists: filteredArtists,
        ),
      );
    });
  }

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        status: LikesArtistStatus.error,
        errorMessage: errorMessage,
      ),
    );
  }
}
