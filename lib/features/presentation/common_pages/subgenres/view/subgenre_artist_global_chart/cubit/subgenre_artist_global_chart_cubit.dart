import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/cubit_stream_with_current_state.dart';

part 'subgenre_artist_global_chart_state.dart';

class SubgenreArtistGlobalChartCubit
    extends BaseCubit<SubgenreArtistGlobalChartState> {
  SubgenreArtistGlobalChartCubit({
    required SubgenrePageCubit subgenrePageCubit,
  })  : _subgenrePageCubit = subgenrePageCubit,
        super(SubgenreArtistGlobalChartLoading()) {
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
        emit(SubgenreArtistGlobalChartLoading());
      }
      if (subgenrePageState.status == SubgenrePageStatus.error) {
        emit(
          SubgenreArtistGlobalChartContentError(
            errorMessage: subgenrePageState.errorMessage,
          ),
        );
      }
      return;
    }
    emit(
      SubgenreArtistGlobalChartContentData(
        likedSongs: subgenrePageState.likedSongs,
        user: subgenrePageState.user,
        artistsChart: subgenrePageState.artistsChart,
        artists: subgenrePageState.artists
            .where(
              (ArtistChartDto a) =>
                  a.subgenres.contains(subgenrePageState.subgenre),
            )
            .toList(),
      ),
    );
  }

  Future<void> searchArtistGlobalChart(
    String? query,
  ) async {
    if (query == null || query.isEmpty) {
      emit(
        SubgenreArtistGlobalChartContentData(
          artistsChart: _subgenrePageCubit.state.artistsChart,
          likedSongs: _subgenrePageCubit.state.likedSongs,
          user: _subgenrePageCubit.state.user,
          artists: _subgenrePageCubit.state.artists
              .where(
                (ArtistChartDto a) =>
                    a.subgenres.contains(_subgenrePageCubit.state.subgenre),
              )
              .toList(),
        ),
      );
    } else {
      final SubgenreArtistGlobalChartContentData initialData =
          state as SubgenreArtistGlobalChartContentData;
      final List<ArtistChartDto> searchedArtistChart = initialData.artistsChart
          .where(
            (ArtistChartDto e) =>
                e.name.toLowerCase().startsWith(query.toLowerCase()) ||
                e.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(
        SubgenreArtistGlobalChartContentData(
          searchedArtistChart: searchedArtistChart,
          artistsChart: _subgenrePageCubit.state.artistsChart,
          likedSongs: _subgenrePageCubit.state.likedSongs,
          user: _subgenrePageCubit.state.user,
          artists: _subgenrePageCubit.state.artists
              .where(
                (ArtistChartDto a) =>
                    a.subgenres.contains(_subgenrePageCubit.state.subgenre),
              )
              .toList(),
        ),
      );
    }
  }

  ///[cancelArtistGlobalChartSearching] is called when
  ///the searching of the global artists charts is canceled.
  Future<void> cancelArtistGlobalChartSearching() async {
    emit(
      SubgenreArtistGlobalChartContentData(
        artistsChart: _subgenrePageCubit.state.artistsChart,
        likedSongs: _subgenrePageCubit.state.likedSongs,
        user: _subgenrePageCubit.state.user,
        artists: _subgenrePageCubit.state.artists
            .where(
              (ArtistChartDto a) =>
                  a.subgenres.contains(_subgenrePageCubit.state.subgenre),
            )
            .toList(),
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
    emit(SubgenreArtistGlobalChartContentError(errorMessage: errorMessage));
  }
}
