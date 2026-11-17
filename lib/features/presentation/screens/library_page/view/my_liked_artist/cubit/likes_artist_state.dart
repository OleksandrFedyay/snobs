part of 'likes_artist_cubit.dart';

enum LikesArtistStatus {
  initial,
  error,
  loading,
  unlikeArtist,
}

enum SortType {
  az,
  date;

  String gteString(BuildContext context) {
    switch (this) {
      case SortType.az:
        return context.i10n.sortByAz;

      case SortType.date:
        return context.i10n.sortByDateAdded;
    }
  }
}

@immutable
class LikesArtistState extends Equatable {
  const LikesArtistState({
    this.status = LikesArtistStatus.loading,
    this.errorMessage = '',
    this.currentCollection = const ArtistCollectionDto(name: ''),
    this.artists = const <ArtistChartDto>[],
    this.filteredArtists = const <ArtistChartDto>[],
    this.currentArtist = '',
    this.user,
    this.artist,
    this.query = '',
    this.sortType = SortType.date,
    this.showSearch = false,
  });

  final LikesArtistStatus status;
  final String errorMessage;
  final UserModel? user;
  final ArtistCollectionDto currentCollection;
  final List<ArtistChartDto> artists;
  final List<ArtistChartDto> filteredArtists;
  final String currentArtist;
  final SortType sortType;
  final String query;
  final ArtistChartDto? artist;
  final bool showSearch;

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      user,
      currentCollection,
      artists,
      filteredArtists,
      currentArtist,
      sortType,
      query,
      artist,
      showSearch,
    ];
  }

  LikesArtistState copyWith({
    LikesArtistStatus? status,
    String? errorMessage,
    UserModel? user,
    ArtistCollectionDto? currentCollection,
    List<ArtistChartDto>? artists,
    List<ArtistChartDto>? filteredArtists,
    String? currentArtist,
    SortType? sortType,
    String? query,
    ArtistChartDto? artist,
    bool? showSearch,
  }) {
    return LikesArtistState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      currentCollection: currentCollection ?? this.currentCollection,
      artists: artists ?? this.artists,
      filteredArtists: filteredArtists ?? this.filteredArtists,
      currentArtist: currentArtist ?? this.currentArtist,
      sortType: sortType ?? this.sortType,
      query: query ?? this.query,
      artist: artist ?? this.artist,
      showSearch: showSearch ?? this.showSearch,
    );
  }
}
