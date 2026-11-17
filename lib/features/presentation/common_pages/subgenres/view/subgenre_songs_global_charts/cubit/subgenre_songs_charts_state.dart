part of 'subgenre_songs_chart_cubit.dart';

sealed class SubgenreSongsGlobalChartState extends Equatable {
  const SubgenreSongsGlobalChartState();
}

final class SubgenreSongsGlobalChartsContentLoading
    extends SubgenreSongsGlobalChartState {
  const SubgenreSongsGlobalChartsContentLoading();

  @override
  List<Object?> get props => <Object?>[];
}

final class SubgenreSongsGlobalChartsContentData
    extends SubgenreSongsGlobalChartState {
  const SubgenreSongsGlobalChartsContentData({
    required this.songsCharts,
    required this.currentArtist,
    this.searchedSongsCharts,
  });

  final List<Track> songsCharts;
  final String currentArtist;
  final List<Track>? searchedSongsCharts;

  @override
  List<Object?> get props => <Object?>[
        songsCharts,
        currentArtist,
        searchedSongsCharts,
      ];
}

final class SubgenreSongsGlobalChartsContentError
    extends SubgenreSongsGlobalChartState {
  const SubgenreSongsGlobalChartsContentError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[
        errorMessage,
      ];
}
