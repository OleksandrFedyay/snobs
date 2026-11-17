import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/cubit_stream_with_current_state.dart';

part 'subgenre_liked_artist_state.dart';

class SubgenreLikedArtistCubit extends BaseCubit<SubgenreLikedArtistState> {
  SubgenreLikedArtistCubit({
    required SubgenrePageCubit subgenrePageCubit,
  })  : _subgenrePageCubit = subgenrePageCubit,
        super(const SubgenreMyLikedArtistContentLoading()) {
    _parentStateSubscription = _subgenrePageCubit.streamWithCurrentState.listen(
      (SubgenrePageState e) => _onParentStateChange(
        subgenrePageState: e,
      ),
    );
  }

  final SubgenrePageCubit _subgenrePageCubit;
  late final StreamSubscription<SubgenrePageState> _parentStateSubscription;

  Future<void> _onParentStateChange({
    required SubgenrePageState subgenrePageState,
  }) async {
    if (subgenrePageState.status == SubgenrePageStatus.loading) {
      emit(const SubgenreMyLikedArtistContentLoading());
      return;
    } else if (subgenrePageState.status == SubgenrePageStatus.error) {
      emit(
        SubgenreMyLikedArtistContentError(
          errorMessage: subgenrePageState.errorMessage,
        ),
      );
      return;
    }

    emit(
      SubgenreMyLikedArtistContentData(
        artists: subgenrePageState.artists,
        update: subgenrePageState.update,
        selectedArtists: subgenrePageState.selectedArtists,
        overrides: subgenrePageState.overrides,
        subgenre: subgenrePageState.subgenre,
        currentArtist: subgenrePageState.currentArtist,
        user: subgenrePageState.user,
      ),
    );
  }

  Future<void> searchMyLikedArtist(String? query) async {
    if (query == null || query.isEmpty) {
      emit(
        SubgenreMyLikedArtistContentData(
          artists: _subgenrePageCubit.state.artists
              .where(
                (ArtistChartDto a) =>
                    a.subgenres.contains(_subgenrePageCubit.state.subgenre),
              )
              .toList(),
          update: _subgenrePageCubit.state.update,
          selectedArtists: _subgenrePageCubit.state.selectedArtists,
          overrides: _subgenrePageCubit.state.overrides,
          subgenre: _subgenrePageCubit.state.subgenre,
          currentArtist: _subgenrePageCubit.state.currentArtist,
          user: _subgenrePageCubit.state.user,
        ),
      );
    } else {
      final SubgenreMyLikedArtistContentData initialData =
          state as SubgenreMyLikedArtistContentData;
      final List<ArtistChartDto> searchedMyLikedArtist = initialData.artists
          .where(
            (ArtistChartDto e) =>
                e.name.toLowerCase().startsWith(query.toLowerCase()) ||
                e.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(
        SubgenreMyLikedArtistContentData(
          searchedMyLikedArtists: searchedMyLikedArtist,
          artists: _subgenrePageCubit.state.artists
              .where(
                (ArtistChartDto a) =>
                    a.subgenres.contains(_subgenrePageCubit.state.subgenre),
              )
              .toList(),
          update: _subgenrePageCubit.state.update,
          selectedArtists: _subgenrePageCubit.state.selectedArtists,
          overrides: _subgenrePageCubit.state.overrides,
          subgenre: _subgenrePageCubit.state.subgenre,
          currentArtist: _subgenrePageCubit.state.currentArtist,
          user: _subgenrePageCubit.state.user,
        ),
      );
    }
  }

  Future<void> cancelMyLikedArtistSearching() async {
    emit(
      SubgenreMyLikedArtistContentData(
        artists: _subgenrePageCubit.state.artists
            .where(
              (ArtistChartDto a) =>
                  a.subgenres.contains(_subgenrePageCubit.state.subgenre),
            )
            .toList(),
        update: _subgenrePageCubit.state.update,
        selectedArtists: _subgenrePageCubit.state.selectedArtists,
        overrides: _subgenrePageCubit.state.overrides,
        subgenre: _subgenrePageCubit.state.subgenre,
        currentArtist: _subgenrePageCubit.state.currentArtist,
        user: _subgenrePageCubit.state.user,
      ),
    );
  }

  ///Sorts Artists
  Future<void> sortArtists({required SortByMethod? sortingMethod}) async {
    ///If state is not SubgenreMyLikedArtistContentData sorting won't be performed.
    if (state
        case SubgenreMyLikedArtistContentData(
          :final List<ArtistChartDto> artists,
          :final bool update,
          :final List<ArtistChartDto> selectedArtists,
          :final List<ArtistSubgenres> overrides,
          :final String subgenre,
          :final String currentArtist,
          :final UserModel? user,
          :final List<ArtistChartDto>? searchedMyLikedArtists,
        )) {
      switch (sortingMethod) {
        case SortByMethod.aToZ:
          await emitPreSortingState(
            state: state as SubgenreMyLikedArtistContentData,
          );
          artists.sort(
              (ArtistChartDto a, ArtistChartDto b) => a.name.compareTo(b.name));

          emit(
            SubgenreMyLikedArtistContentData(
              currentArtist: currentArtist,
              artists: artists,
              update: update,
              subgenre: subgenre,
              overrides: overrides,
              selectedArtists: selectedArtists,
              user: user,
              searchedMyLikedArtists: searchedMyLikedArtists,
            ),
          );
          return;
        case SortByMethod.topArtist:
          await emitPreSortingState(
            state: state as SubgenreMyLikedArtistContentData,
          );
          artists.sort((ArtistChartDto a, ArtistChartDto b) =>
              a.likes.compareTo(b.likes));

          emit(
            SubgenreMyLikedArtistContentData(
              currentArtist: currentArtist,
              artists: artists,
              update: update,
              subgenre: subgenre,
              overrides: overrides,
              selectedArtists: selectedArtists,
              user: user,
            ),
          );
          return;

        ///TODO handle the sorting logic for songs by date added parameter
        /*   case SortByMethod.dateAdded:
          return;*/
        case null:
          return;
      }
    }
    return;
  }

  ///Emits state before sorting to trigger the state changes.
  ///List sorting doesn't trigger the state changes.
  ///Here it is async because it is used in [sortArtists]
  ///and there the state sometimes does not have enough time to emit new state.
  Future<void> emitPreSortingState({
    required SubgenreMyLikedArtistContentData state,
  }) async {
    emit(
      SubgenreMyLikedArtistContentData(
        currentArtist: state.currentArtist,
        artists: const <ArtistChartDto>[],
        update: state.update,
        subgenre: state.subgenre,
        overrides: state.overrides,
        selectedArtists: state.selectedArtists,
        user: state.user,
        searchedMyLikedArtists: const <ArtistChartDto>[],
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
    emit(SubgenreMyLikedArtistContentError(errorMessage: errorMessage));
  }
}
