part of 'subgenres_page_cubit.dart';

@immutable
class SubgenrePageState extends Equatable {
  const SubgenrePageState({
    this.genre = GenreEnum.metal,
    this.status = SubgenrePageStatus.loading,
    this.errorMessage = '',
    this.artists = const <ArtistChartDto>[],
    this.subgenre = '',
    this.genreSubgenreDescription = '',
    this.currentArtist = '',
    this.user,
    this.artist,
    this.update = false,
    this.overrides = const <ArtistSubgenres>[],
    this.selectedArtists = const <ArtistChartDto>[],
    this.artistsChart = const <ArtistChartDto>[],
    this.index = 0,
    this.likedSongs = const <Track>[],
    this.songsCharts = const <Track>[],
    this.chosenResource = ChosenResource.myLiked,
    this.chosenSortByMethod = SortByMethod.topArtist,
    this.toggleButtonIndex = 0,
    this.topSnobsUsers = const <UserLikeDto>[],
    this.isTrialOrSubscriptionActive = false,
    this.statusFans = SubgenreFansPageStatus.loading,
    this.statusChartsSongs = SubgenreChartsSongsPageStatus.loading,
    this.genrePageType = GenrePageType.subgenre,
  });

  final SubgenrePageStatus status;
  final SubgenreFansPageStatus statusFans;
  final SubgenreChartsSongsPageStatus statusChartsSongs;
  final String errorMessage;
  final List<ArtistChartDto> artists;
  final GenreEnum genre;
  final String subgenre;
  final String genreSubgenreDescription;
  final UserModel? user;
  final String currentArtist;
  final ArtistChartDto? artist;
  final bool update;
  final List<ArtistChartDto> selectedArtists;
  final List<ArtistSubgenres> overrides;
  final int index;
  final int toggleButtonIndex;
  final List<ArtistChartDto> artistsChart;
  final List<Track> likedSongs;
  final List<Track> songsCharts;
  final ChosenResource chosenResource;
  final SortByMethod chosenSortByMethod;
  final List<UserLikeDto> topSnobsUsers;
  final bool isTrialOrSubscriptionActive;
  final GenrePageType genrePageType;

  SubgenrePageState copyWith({
    SubgenrePageStatus? status,
    String? errorMessage,
    List<ArtistChartDto>? artists,
    GenreEnum? genre,
    String? subgenre,
    String? genreSubgenreDescription,
    UserModel? user,
    String? currentArtist,
    ArtistChartDto? artist,
    bool? update,
    List<ArtistChartDto>? selectedArtists,
    List<ArtistSubgenres>? overrides,
    int? index,
    List<ArtistChartDto>? artistsChart,
    List<Track>? likedSongs,
    List<Track>? searchedLikedSongsList,
    List<Track>? songsCharts,
    ChosenResource? chosenResource,
    SortByMethod? chosenSortByMethod,
    int? toggleButtonIndex,
    List<UserLikeDto>? topSnobsUsers,
    bool? isTrialOrSubscriptionActive,
    SubgenreFansPageStatus? statusFans,
    SubgenreChartsSongsPageStatus? statusChartsSongs,
    GenrePageType? genrePageType,
  }) {
    return SubgenrePageState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      artists: artists ?? this.artists,
      genre: genre ?? this.genre,
      subgenre: subgenre ?? this.subgenre,
      genreSubgenreDescription:
          genreSubgenreDescription ?? this.genreSubgenreDescription,
      user: user ?? this.user,
      currentArtist: currentArtist ?? this.currentArtist,
      artist: artist ?? this.artist,
      update: update ?? this.update,
      selectedArtists: selectedArtists ?? this.selectedArtists,
      overrides: overrides ?? this.overrides,
      index: index ?? this.index,
      artistsChart: artistsChart ?? this.artistsChart,
      likedSongs: likedSongs ?? this.likedSongs,
      songsCharts: songsCharts ?? this.songsCharts,
      chosenResource: chosenResource ?? this.chosenResource,
      chosenSortByMethod: chosenSortByMethod ?? this.chosenSortByMethod,
      toggleButtonIndex: toggleButtonIndex ?? this.toggleButtonIndex,
      topSnobsUsers: topSnobsUsers ?? this.topSnobsUsers,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
      statusFans: statusFans ?? this.statusFans,
      statusChartsSongs: statusChartsSongs ?? this.statusChartsSongs,
      genrePageType: genrePageType ?? this.genrePageType,
    );
  }

  @override
  List<Object?> get props {
    return <Object?>[
      status,
      errorMessage,
      artists,
      genre,
      subgenre,
      genreSubgenreDescription,
      user,
      currentArtist,
      artist,
      update,
      selectedArtists,
      overrides,
      index,
      artistsChart,
      likedSongs,
      songsCharts,
      chosenResource,
      chosenSortByMethod,
      toggleButtonIndex,
      topSnobsUsers,
      isTrialOrSubscriptionActive,
      statusFans,
      statusChartsSongs,
      genrePageType,
    ];
  }
}
