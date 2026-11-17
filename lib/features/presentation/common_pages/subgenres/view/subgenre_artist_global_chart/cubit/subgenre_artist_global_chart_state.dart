part of 'subgenre_artist_global_chart_cubit.dart';

sealed class SubgenreArtistGlobalChartState extends Equatable {
  const SubgenreArtistGlobalChartState();
}

final class SubgenreArtistGlobalChartLoading
    extends SubgenreArtistGlobalChartState {
  @override
  List<Object?> get props => <Object?>[];
}

final class SubgenreArtistGlobalChartContentData
    extends SubgenreArtistGlobalChartState {
  const SubgenreArtistGlobalChartContentData({
    this.artists = const <ArtistChartDto>[],
    this.artistsChart = const <ArtistChartDto>[],
    this.likedSongs = const <Track>[],
    this.user,
    this.searchedArtistChart,
  });

  final List<ArtistChartDto> artists;
  final List<ArtistChartDto> artistsChart;
  final List<Track> likedSongs;
  final UserModel? user;
  final List<ArtistChartDto>? searchedArtistChart;

  @override
  List<Object?> get props => <Object?>[
        artists,
        artistsChart,
        likedSongs,
        user,
        searchedArtistChart,
      ];
}

final class SubgenreArtistGlobalChartContentError
    extends SubgenreArtistGlobalChartState {
  const SubgenreArtistGlobalChartContentError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[errorMessage];
}
