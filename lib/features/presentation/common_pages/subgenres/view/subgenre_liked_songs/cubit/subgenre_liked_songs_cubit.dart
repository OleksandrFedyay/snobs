import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/cubit_stream_with_current_state.dart';

part 'subgenre_liked_songs_state.dart';

class SubgenreLikedSongsCubit
    extends BaseCubit<SubgenreLikedSongsState> {
  SubgenreLikedSongsCubit({
    required SubgenrePageCubit subgenrePageCubit,
  })  : _subgenrePageCubit = subgenrePageCubit,
        super(SubgenreLikedSongsContentLoading()) {
    _parentStateSubscription = _subgenrePageCubit.streamWithCurrentState.listen(
      (SubgenrePageState e) => _onParentStateChange(
        subgenrePageState: e,
      ),
    );
  }

  final SubgenrePageCubit _subgenrePageCubit;
  late final StreamSubscription<SubgenrePageState> _parentStateSubscription;

  ///Listens to the parent's states: [SubgenrePageState]
  Future<void> _onParentStateChange({
    required SubgenrePageState subgenrePageState,
  }) async {
    if (subgenrePageState.status != SubgenrePageStatus.initial) {
      if (subgenrePageState.status == SubgenrePageStatus.loading) {
        emit(SubgenreLikedSongsContentLoading());
      }
      if (subgenrePageState.status == SubgenrePageStatus.error) {
        emit(
          SubgenreLikedSongsContentError(
            errorMessage: subgenrePageState.errorMessage,
          ),
        );
      }
      return;
    }
    emit(
      SubgenreLikedSongsContentData(
        likedSongs: subgenrePageState.likedSongs,
        currentArtist: subgenrePageState.currentArtist,
        subgenre: subgenrePageState.subgenre,
      ),
    );
  }

  void searchLikedSongs(
    String? query,
  ) {
    if (query == null || query.isEmpty) {
      emit(
        SubgenreLikedSongsContentData(
          likedSongs: _subgenrePageCubit.state.likedSongs,
          currentArtist: _subgenrePageCubit.state.currentArtist,
        ),
      );
    } else {
      final SubgenreLikedSongsContentData initialState = state as SubgenreLikedSongsContentData;
      final List<Track> searchedLikedSongs = initialState.likedSongs
          .where(
            (Track e) =>
                e.title.toLowerCase().startsWith(query.toLowerCase()) ||
                e.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(
        SubgenreLikedSongsContentData(
          likedSongs: _subgenrePageCubit.state.likedSongs,
          currentArtist: _subgenrePageCubit.state.currentArtist,
          searchedLikedSongs: searchedLikedSongs,
        ),
      );
    }
  }

  ///[cancelLikedSongsSearching] is called when the searching of the liked songs is canceled.
  void cancelLikedSongsSearching() {
    emit(
      SubgenreLikedSongsContentData(
        likedSongs: _subgenrePageCubit.state.likedSongs,
        currentArtist: _subgenrePageCubit.state.currentArtist,
      ),
    );
  }

  ///Sorts songs
  Future<void> sortSongs({required SortByMethod? sortingMethod}) async {
    ///If state is not SubgenreLikedSongsContentData sorting won't be performed
    if (state
        case SubgenreLikedSongsContentData(
          :final List<Track> likedSongs,
          :final String currentArtist
        )) {
      switch (sortingMethod) {
        case SortByMethod.aToZ:
          await emitPreSortingState(currentArtist);
          likedSongs.sort((Track a, Track b) => a.title.compareTo(b.title));
          emit(
            SubgenreLikedSongsContentData(
              likedSongs: likedSongs,
              currentArtist: currentArtist,
            ),
          );
          return;
        case SortByMethod.topArtist:
          await emitPreSortingState(currentArtist);
          likedSongs.sort((Track a, Track b) => a.likes.length.compareTo(b.likes.length));
          emit(
            SubgenreLikedSongsContentData(
              likedSongs: likedSongs,
              currentArtist: currentArtist,
            ),
          );
          return;

        ///TODO handle the sorting logic for songs by date added parameter
        /*  case SortByMethod.dateAdded:
          return;*/
        case null:
          return;
      }
    }
    return;
  }

  ///Emits state before sorting to trigger the state changes.
  ///List sorting doesn't trigger the state changes.
  Future<void> emitPreSortingState(String currentArtist) async {
    emit(
      SubgenreLikedSongsContentData(
        currentArtist: currentArtist,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _parentStateSubscription.cancel();
    await super.close();
  }

  @override
  void handleError(String errorMessage) {
    emit(SubgenreLikedSongsContentError(errorMessage: errorMessage));
  }
}
