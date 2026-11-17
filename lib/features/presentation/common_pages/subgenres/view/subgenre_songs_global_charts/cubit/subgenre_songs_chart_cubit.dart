import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/cubit_stream_with_current_state.dart';

part 'subgenre_songs_charts_state.dart';

class SubgenreSongsGlobalChartCubit
    extends BaseCubit<SubgenreSongsGlobalChartState> {
  SubgenreSongsGlobalChartCubit({
    required SubgenrePageCubit subgenrePageCubit,
  })  : _subgenrePageCubit = subgenrePageCubit,
        super(const SubgenreSongsGlobalChartsContentLoading()) {
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
    if (subgenrePageState.statusChartsSongs !=
        SubgenreChartsSongsPageStatus.initial) {
      if (subgenrePageState.statusChartsSongs ==
          SubgenreChartsSongsPageStatus.loading) {
        emit(const SubgenreSongsGlobalChartsContentLoading());
      }
      if (subgenrePageState.statusChartsSongs ==
          SubgenreChartsSongsPageStatus.error) {
        emit(
          SubgenreSongsGlobalChartsContentError(
            errorMessage: subgenrePageState.errorMessage,
          ),
        );
      }
      return;
    }
    emit(
      SubgenreSongsGlobalChartsContentData(
        songsCharts: subgenrePageState.songsCharts,
        currentArtist: subgenrePageState.currentArtist,
      ),
    );
  }

  Future<void> searchGlobalChartsSongs(String? query) async {
    if (query == null || query.isEmpty) {
      emit(
        SubgenreSongsGlobalChartsContentData(
          songsCharts: _subgenrePageCubit.state.songsCharts,
          currentArtist: _subgenrePageCubit.state.currentArtist,
        ),
      );
    } else {
      final SubgenreSongsGlobalChartsContentData initialData =
          state as SubgenreSongsGlobalChartsContentData;
      final List<Track> searchedSongsCharts = initialData.songsCharts
          .where(
            (Track e) =>
                e.title.toLowerCase().startsWith(query.toLowerCase()) ||
                e.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(
        SubgenreSongsGlobalChartsContentData(
          searchedSongsCharts: searchedSongsCharts,
          songsCharts: _subgenrePageCubit.state.songsCharts,
          currentArtist: _subgenrePageCubit.state.currentArtist,
        ),
      );
    }
  }

  Future<void> cancelSongsGlobalChartsSearching() async {
    emit(
      SubgenreSongsGlobalChartsContentData(
        songsCharts: _subgenrePageCubit.state.songsCharts,
        currentArtist: _subgenrePageCubit.state.currentArtist,
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
    emit(
      SubgenreSongsGlobalChartsContentError(
        errorMessage: errorMessage,
      ),
    );
  }
}
