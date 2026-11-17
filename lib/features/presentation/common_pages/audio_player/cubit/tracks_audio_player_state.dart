part of 'tracks_audio_player_cubit.dart';

enum RadioStatus {
  active,
  loading,
  initial,
}

enum PlayerType {
  songs,
  radio,
}

@immutable
class TracksAudioPlayerState extends Equatable {
  const TracksAudioPlayerState({
    this.artist,
    this.user,
    this.active = false,
    this.tracks = const <String, List<Track>>{},
    this.radioInfoTracks = const <String, List<Track>>{},
    this.radioTracks = const <Track>[],
    this.radioStatus = RadioStatus.initial,
    this.playerType = PlayerType.songs,
    this.error = false,
    this.loadingNext = false,
    this.radioTitle = '',
    this.rank,
    this.likedArtist = const <ArtistChartDto>[],
    this.artistCount = 0,
    this.isRadioInfoTracks = false,
    this.radioGenre = '',
    this.radioArtistIndex = 0,
    this.isTrialOrSubscriptionActive = false,
    this.isNewRankLevel = false,
    this.isRadioPlaying = false,
    this.radioPlayingPosition = Duration.zero,
    this.allGenres = const <Genre>[],
  });

  final MediaItem? artist;
  final bool active;
  final Map<String, List<Track>> tracks;
  final Map<String, List<Track>> radioInfoTracks;
  final bool isRadioInfoTracks;
  final int radioArtistIndex;
  final UserModel? user;
  final RadioStatus radioStatus;
  final PlayerType playerType;
  final List<Track> radioTracks;
  final bool error;
  final bool loadingNext;
  final String radioTitle;
  final String radioGenre;
  final LevelDto? rank;
  final List<ArtistChartDto> likedArtist;
  final int artistCount;
  final bool isTrialOrSubscriptionActive;
  final bool isNewRankLevel;
  final bool isRadioPlaying;
  final Duration radioPlayingPosition;
  final List<Genre> allGenres;

  @override
  List<Object?> get props {
    final int? index = tracks[artist?.displaySubtitle]
        ?.indexWhere((Track t) => t.id.toString() == artist?.id);

    if (index == null) {
      return <Object?>[
        artist,
        radioTracks,
        active,
        tracks,
        tracks[artist?.displaySubtitle],
        user,
        radioStatus,
        error,
        loadingNext,
        radioTitle,
        rank,
        likedArtist,
        artistCount,
        radioInfoTracks,
        isRadioInfoTracks,
        radioGenre,
        radioArtistIndex,
        playerType,
        isTrialOrSubscriptionActive,
        isNewRankLevel,
        isRadioPlaying,
        radioPlayingPosition,
        allGenres,
      ];
    }

    return <Object?>[
      artist,
      active,
      tracks,
      radioTracks,
      tracks[artist?.displaySubtitle],
      tracks[artist?.displaySubtitle]?[index],
      tracks[artist?.displaySubtitle]?[index].likes,
      user,
      radioStatus,
      error,
      loadingNext,
      radioTitle,
      rank,
      likedArtist,
      artistCount,
      radioInfoTracks,
      isRadioInfoTracks,
      radioGenre,
      radioArtistIndex,
      playerType,
      isTrialOrSubscriptionActive,
      isNewRankLevel,
      isRadioPlaying,
      radioPlayingPosition,
      allGenres,
    ];
  }

  TracksAudioPlayerState copyWith({
    MediaItem? artist,
    bool? active,
    Map<String, List<Track>>? tracks,
    Map<String, List<Track>>? radioInfoTracks,
    bool? isRadioInfoTracks,
    UserModel? user,
    RadioStatus? radioStatus,
    PlayerType? playerType,
    List<Track>? radioTracks,
    bool? error,
    bool? loadingNext,
    String? radioTitle,
    LevelDto? rank,
    List<ArtistChartDto>? likedArtist,
    int? artistCount,
    String? radioGenre,
    int? radioArtistIndex,
    bool? isTrialOrSubscriptionActive,
    bool? isNewRankLevel,
    bool? isRadioPlaying,
    Duration? radioPlayingPosition,
    List<Genre>? allGenres,
  }) {
    return TracksAudioPlayerState(
      artist: artist ?? this.artist,
      active: active ?? this.active,
      tracks: tracks ?? this.tracks,
      radioInfoTracks: radioInfoTracks ?? this.radioInfoTracks,
      isRadioInfoTracks: isRadioInfoTracks ?? this.isRadioInfoTracks,
      user: user ?? this.user,
      radioStatus: radioStatus ?? this.radioStatus,
      radioTracks: radioTracks ?? this.radioTracks,
      error: error ?? this.error,
      loadingNext: loadingNext ?? this.loadingNext,
      radioTitle: radioTitle ?? this.radioTitle,
      rank: rank ?? this.rank,
      likedArtist: likedArtist ?? this.likedArtist,
      //Todo(Issa): Check this if needed
      artistCount: artistCount ?? this.artistCount,
      radioGenre: radioGenre ?? this.radioGenre,
      radioArtistIndex: radioArtistIndex ?? this.radioArtistIndex,
      playerType: playerType ?? this.playerType,
      isTrialOrSubscriptionActive:
          isTrialOrSubscriptionActive ?? this.isTrialOrSubscriptionActive,
      isNewRankLevel: isNewRankLevel ?? this.isNewRankLevel,
      isRadioPlaying: isRadioPlaying ?? this.isRadioPlaying,
      radioPlayingPosition: radioPlayingPosition ?? this.radioPlayingPosition,
      allGenres: allGenres ?? this.allGenres,
    );
  }
}
