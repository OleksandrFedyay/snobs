part of 'search_page_cubit.dart';

enum SearchStatus {
  initial,
  error,
  loading,
  unlikeArtist,
}

@immutable
class SearchPageState extends Equatable {
  const SearchPageState({
    this.status = SearchStatus.loading,
    this.errorMessage = '',
    this.filteredArtists = const <ArtistChartDto>[],
    this.currentArtist = '',
    this.user,
    this.artist,
    this.query = '',
    this.index = 0,
    this.genres = const <GenreSubgenresTotal>[],
    this.tracks = const <Track>[],
    this.likedArtists = const <ArtistChartDto>[],
  });

  final SearchStatus status;
  final String errorMessage;
  final UserModel? user;
  final List<ArtistChartDto> filteredArtists;
  final String currentArtist;
  final String query;
  final ArtistChartDto? artist;
  final int index;
  final List<GenreSubgenresTotal> genres;
  final List<Track> tracks;
  final List<ArtistChartDto> likedArtists;

  SearchPageState copyWith({
    SearchStatus? status,
    String? errorMessage,
    UserModel? user,
    List<ArtistChartDto>? filteredArtists,
    String? currentArtist,
    String? query,
    ArtistChartDto? artist,
    int? index,
    List<GenreSubgenresTotal>? genres,
    List<Track>? tracks,
    List<ArtistChartDto>? likedArtists,
  }) {
    return SearchPageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      filteredArtists: filteredArtists ?? this.filteredArtists,
      currentArtist: currentArtist ?? this.currentArtist,
      query: query ?? this.query,
      artist: artist ?? this.artist,
      index: index ?? this.index,
      genres: genres ?? this.genres,
      tracks: tracks ?? this.tracks,
      likedArtists: likedArtists ?? this.likedArtists,
    );
  }

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      user,
      filteredArtists,
      currentArtist,
      query,
      artist,
      index,
      genres,
      tracks,
      likedArtists,
    ];
  }
}
