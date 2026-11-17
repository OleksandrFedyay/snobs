import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/level_dto.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/play_body.dart';
import 'package:kingfishertom/core/data/api/models/radio/radio_dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/api/rebelation_api/rebelation_api_service.dart';
import 'package:kingfishertom/core/data/data_sources/remote.tracks.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.app_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/repositories/recommendation_artist_service.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/add_like.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/edit_artist_in_collections.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_app_user_level.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_chart.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_artist_tracks.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_genres.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_user.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/like_track.use_case.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/remove_like.use_case.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/audio_player_handler.dart';

part 'tracks_audio_player_state.dart';

@lazySingleton
class TrackAudioPlayerCubit extends BaseCubit<TracksAudioPlayerState> {
  TrackAudioPlayerCubit(
    this._likeTrackUseCase,
    this._getUserUseCase,
    this._getArtistTracksUseCase,
    this._rebelationApiService,
    this._remoteTracksDataSource,
    this._addLikeUseCase,
    this._recommendationArtistService,
    this._localAppInfoDataSource,
    this._getLevelUseCase,
    this.addLikeUseCase,
    this.editArtistInCollectionUseCase,
    this.removeLikeUseCase,
    this.getAllLikedArtistsUseCase,
  ) : super(const TracksAudioPlayerState()) {
    _audioPlayer = AudioPlayer();
  }

  final LikeTrackUseCase _likeTrackUseCase;
  final GetUserStreamUseCase _getUserUseCase;
  final GetArtistTracksUseCase _getArtistTracksUseCase;
  final RebelationApiService _rebelationApiService;
  final RemoteTracksDataSource _remoteTracksDataSource;
  final AddLikeUseCase _addLikeUseCase;
  final RecommendationArtistService _recommendationArtistService;
  final LocalAppInfoDataSource _localAppInfoDataSource;
  final GetAppUserLevelUseCase _getLevelUseCase;
  final AddLikeUseCase addLikeUseCase;
  final EditArtistInCollectionUseCase editArtistInCollectionUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final GetAllLikedArtistsUseCase getAllLikedArtistsUseCase;

  //Todo(Issa): need to refactor the create() in all classes
  static TrackAudioPlayerCubit create() {
    return getIt<TrackAudioPlayerCubit>()..init();
  }

  late final AudioPlayer _audioPlayer;
  late final AudioSession audioSession;
  late final AudioPlayerHandler audioHandler;

  bool _playInterrupted = false;
  List<int> _tracksId = <int>[];
  List<ArtistChartDto> _radioArtists = <ArtistChartDto>[];
  List<MediaItem> _mediaRadioItems = <MediaItem>[];
  List<MediaItem> _mediaRadioArtistItems = <MediaItem>[];

  @override
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        active: false,
        error: true,
        radioStatus: RadioStatus.initial,
      ),
    );

    emit(state.copyWith(error: false));
  }

  @override
  Future<void> close() async {
    await audioHandler.customAction('dispose');
    unawaited(super.close());
  }

  Future<void> init() async {
    handleStream(
      '_getUserStreamUseCase',
      _getUserUseCase.execute(),
      (UserModel? user) async {
        final List<ArtistChartDto> likedArtist =
            await getAllLikedArtistsUseCase(user?.likes ?? <String>[]);
        final Map<LevelValueType, Object> levelUseCase =
            await _getLevelUseCase();
        emit(
          state.copyWith(
            user: user,
            likedArtist: likedArtist,
            rank: levelUseCase[LevelValueType.levelData]! as LevelDto,
            isNewRankLevel: levelUseCase[LevelValueType.levelStatus]! as bool,
          ),
        );
      },
    );
    await isTrialOrSubscriptionActive;
    audioHandler = await AudioService.init(
      builder: () {
        return AudioPlayerHandler(player: _audioPlayer);
      },
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
        androidNotificationChannelName: 'Music playback',
      ),
    );

    _audioPlayer.sequenceStateStream.listen((SequenceState? audioState) {
      final MediaItem? mediaItem = audioState?.currentSource?.tag as MediaItem?;
      emit(state.copyWith(artist: mediaItem));

      if (mediaItem?.id == _tracksId.lastOrNull.toString() &&
          state.radioStatus == RadioStatus.active) {
        resumeRadio();
      }
    });

    final AudioSession audioSession = await AudioSession.instance;
    await audioSession.configure(const AudioSessionConfiguration.music());
    audioSession.becomingNoisyEventStream.listen((_) async {
      /// Pause audio when headphones/speakers are disconnected
      setActive(value: false);
    });

    _audioPlayer.playingStream.listen((bool value) {
      emit(state.copyWith(active: value));
    });
    audioSession.interruptionEventStream
        .listen((AudioInterruptionEvent event) async {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            await _audioPlayer.setVolume(.2);
            _playInterrupted = false;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (state.active) _playInterrupted = true;
            setActive(value: false);
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // set the volume back to 100% for the current music file
            // replaygain adjustments are made when recording starts playing
            await _audioPlayer.setVolume(.2);
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_playInterrupted) setActive(value: true);
        }
        _playInterrupted = false;
      }
    });

    await audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  }

  Future<void> playTrack(
    ArtistChartDto? artist, {
    bool fullSong = false,
    bool reset = true,
    bool? active,
  }) async {
    if (artist?.id == state.artist?.displaySubtitle && state.active) return;
    if (artist?.id.isEmpty ?? true) return;

    if (reset) await resetRadio();

    final List<Track> tracks = await _getArtistTracksUseCase(artist?.id ?? '');
    if (tracks.isEmpty) return;

    final Map<String, List<Track>> map = <String, List<Track>>{}
      ..addAll(state.tracks)
      ..putIfAbsent(artist?.id ?? '', () => tracks);
    if (state.isRadioInfoTracks) {
      setIsRadioInfoTracks(false);
    }
    emit(state.copyWith(tracks: map));

    if (!reset && state.radioStatus == RadioStatus.active) return;
    await play(
      tracks,
      artist,
      active: active ?? state.active,
      fullSong: fullSong,
    );
  }

  Future<void> setActiveArtist(ArtistChartDto? artist, int trackIndex) async {
    if (artist?.id == state.artist?.displaySubtitle) return;
    await resetRadio();

    final List<Track> tracks = state.tracks[artist?.id ?? ''] ?? <Track>[];
    if (tracks.isEmpty) return;

    await play(tracks, artist, trackIndex: trackIndex);
  }

  Future<void> play(
    List<Track> tracks,
    ArtistChartDto? artist, {
    bool active = true,
    int trackIndex = 0,
    bool fullSong = false,
  }) async {
    if (artist?.id == null &&
        tracks.firstOrNull?.id.toString() == state.artist?.id) {
      return;
    }
    if (artist?.id == state.artist?.displaySubtitle &&
        state.active &&
        artist?.id != null) {
      return;
    }

    _radioArtists = <ArtistChartDto>[];
    _tracksId = <int>[];

    await audioHandler.customAction('clear');
    if (tracks.length > 1) {
      await audioHandler.addQueueItems(
        tracks
            .map((Track e) =>
                _getMediaItemFromUrl(e, artist, fullSong: fullSong))
            .toList(),
      );
    } else {
      await audioHandler.addQueueItem(
        _getMediaItemFromUrl(tracks[trackIndex], artist, fullSong: fullSong),
      );
    }

    if (active) unawaited(audioHandler.play());

    //Todo(Issa): Need to remove this logic, causing issues when start the app
/*
    await audioHandler.customAction('clear');
    await audioHandler.addQueueItem(
      _getMediaItemFromUrl(tracks[trackIndex], artist, fullSong: fullSong),
    );
    await audioHandler.skipToQueueItem(0);

    if (active) unawaited(audioHandler.play());

    if (tracks.length < 2) return;
    await audioHandler.addQueueItems(
      tracks
          .map((Track e) => _getMediaItemFromUrl(e, artist, fullSong: fullSong))
          .toList()
        ..removeAt(trackIndex),
    );
*/

    if (trackIndex != 0) await audioHandler.skipToQueueItem(trackIndex);
  }

  Future<void> likeTrack() async {
    if (state.radioStatus == RadioStatus.active) {
      final int index = state.radioTracks
          .indexWhere((Track t) => t.id.toString() == state.artist?.id);
      if (index == -1) return;

      final Track track = state.radioTracks[index];
      final Track? updatedTrack = await _likeTrackUseCase(
        state.artist?.displaySubtitle ?? track.artists.first.toString(),
        state.user?.id,
        track.id.toString(),
      );
      if (updatedTrack == null) return;

      final List<Track> tracks = <Track>[...state.radioTracks]
        ..removeAt(index)
        ..insert(index, updatedTrack);

      emit(state.copyWith(radioTracks: tracks));

      for (final int a in track.artists) {
        await _addLikeUseCase(a.toString());
      }

      return;
    }

    final int? index = state.tracks[state.artist?.displaySubtitle]
        ?.indexWhere((Track t) => t.id.toString() == state.artist?.id);
    if (index == null) return;

    final Track? track = state.tracks[state.artist?.displaySubtitle]?[index];
    if (track == null) return;
    final Track? updatedTrack = await _likeTrackUseCase(
      state.artist?.displaySubtitle,
      state.user?.id,
      track.id.toString(),
    );
    if (updatedTrack == null) return;

    final List<Track> tracks = <Track>[
      ...state.tracks[state.artist?.displaySubtitle] ?? <Track>[]
    ]
      ..removeAt(index)
      ..insert(index, updatedTrack);

    final Map<String, List<Track>> map = <String, List<Track>>{}
      ..addAll(state.tracks)
      ..update(
          state.artist?.displaySubtitle ?? '', (List<Track> value) => tracks);
    emit(state.copyWith(tracks: map));
  }

  Future<void> likeTrackId(int? id) async {
    if (id == null) return;

    final int? index = state.tracks[state.artist?.displaySubtitle]
        ?.indexWhere((Track t) => t.id == id);
    if (index == null) return;

    final Track? track = state.tracks[state.artist?.displaySubtitle]?[index];
    if (track == null) return;
    final Track? updatedTrack = await _likeTrackUseCase(
      state.artist?.displaySubtitle,
      state.user?.id,
      track.id.toString(),
    );
    if (updatedTrack == null) return;

    final List<Track> tracks = <Track>[
      ...state.tracks[state.artist?.displaySubtitle] ?? <Track>[]
    ]
      ..removeAt(index)
      ..insert(index, updatedTrack);

    final Map<String, List<Track>> map = <String, List<Track>>{}
      ..addAll(state.tracks)
      ..update(
          state.artist?.displaySubtitle ?? '', (List<Track> value) => tracks);
    emit(state.copyWith(tracks: map));
  }

  void setActive({bool? value}) {
    if (value == state.active) return;

    final bool active = value ?? !state.active;
    if (active) {
      _playInterrupted = false;
      audioHandler.play();
    } else {
      audioHandler.pause();
    }
  }

  Future<void> resetRadio([PlayerType playerType = PlayerType.songs]) async {
    if (state.active) {
      await audioHandler.stop();
    }
    emit(state.copyWith(
      radioStatus: RadioStatus.initial,
      playerType: playerType,
    ));
  }

  //Todo(Issa): Need to refactor this method or this cubit
  Future<void> startRadio(
    List<ArtistChartDto> artists,
    List<String> subgenres,
    String genre,
  ) =>
      performSafeAction(() async {
        final List<Genre> allGenres = await getIt<GetGenresUseCase>().call();

        emit(
          state.copyWith(
            radioStatus: RadioStatus.loading,
            radioTitle: subgenres.length == 1 ? subgenres.first : genre,
            radioGenre: genre,
            allGenres: allGenres,
          ),
        );

        if (artists.isEmpty) {
          final ArtistsListDto recommendedArtists =
              await _recommendationArtistService
                  .getArtists(subgenres.first, <String>[
            ...state.user?.likes ?? <String>[],
            ...state.user?.skips ?? <String>[],
          ]);

          artists.addAll(recommendedArtists.artists);
        }

        unawaited(
          FirebaseAnalytics.instance.logEvent(name: 'radio_init'),
        );
        if (!kIsWeb) {
          unawaited(FacebookAppEvents().logEvent(name: 'radio_init'));
        }
        final List<Track> tracks = _getDistinctList(
          await _rebelationApiService.getRadioTracks(
            PlayBody(
              favorites: artists
                  .map((ArtistChartDto a) => int.tryParse(a.id) ?? 0)
                  .toList(),
            ),
          ),
        );

        if (tracks.isEmpty) return;

        await audioHandler.customAction('clear');

        if (tracks.length > 1) {
          _mediaRadioItems = tracks
              .map(
                (Track e) => _getMediaItemFromUrl(
                  e,
                  _getArtist(e.artists, artists),
                  fullSong: true,
                ),
              )
              .toList();
          await audioHandler.addQueueItems(_mediaRadioItems);
        } else {
          final MediaItem mediaItem = _getMediaItemFromUrl(
            tracks.first,
            _getArtist(tracks.first.artists, artists),
            fullSong: true,
          );
          await audioHandler.addQueueItem(mediaItem);
        }

        await audioHandler.skipToQueueItem(0);

        _radioArtists = artists;
        unawaited(audioHandler.play());
        emit(
          state.copyWith(
            radioStatus: RadioStatus.active,
            playerType: PlayerType.radio,
            radioTitle: subgenres.length == 1 ? subgenres.first : genre,
            artistCount: _radioArtists.length,
          ),
        );

        _tracksId = tracks.map((Track t) => t.id).toList();

        final List<Track> tracksFromFirebase =
            await _remoteTracksDataSource.getTracksByIds(_tracksId);
        emit(state.copyWith(radioTracks: tracksFromFirebase));

        if (artists.length >= 25) return;
        if (subgenres.length == 1) {
          await _localAppInfoDataSource.setRadioHistory(
            RadioDto(
              subgenres: subgenres,
              artists: artists,
              genre: genre,
            ),
          );
          final ArtistsListDto recommendedArtists =
              await _recommendationArtistService
                  .getArtists(subgenres.first, <String>[
            ...state.user?.likes ?? <String>[],
            ...state.user?.skips ?? <String>[],
          ]);
          final int n = 25 - artists.length;
          final int len = recommendedArtists.artists.length;
          _radioArtists = <ArtistChartDto>[
            ..._radioArtists,
            ...recommendedArtists.artists.sublist(0, len < n ? len : n),
          ];

          return;
        }

        final List<ArtistChartDto> recommendedArtists = <ArtistChartDto>[];
        final int subgenresLength = subgenres.length;
        for (final String s in subgenres.sublist(
            0, subgenresLength < 3 ? subgenresLength : 3)) {
          final ArtistsListDto recommendedSubgenreArtists =
              await _recommendationArtistService.getArtists(s, <String>[
            ...state.user?.likes ?? <String>[],
            ...state.user?.skips ?? <String>[],
          ]);
          final int n = (25 - artists.length) ~/ 3;
          final int len = recommendedSubgenreArtists.artists.length;
          recommendedArtists.addAll(
            recommendedSubgenreArtists.artists.sublist(0, len < n ? len : n),
          );
        }
        _radioArtists = <ArtistChartDto>[
          ..._radioArtists,
          ...recommendedArtists
        ];
      });

  List<RadioDto> prepareSuggestedRadios(
      {required List<String> subgenres, required String genre}) {
    final List<RadioDto> radios = <RadioDto>[];

    for (final String value in subgenres) {
      radios.add(RadioDto(
        subgenres: <String>[value],
        artists: _radioArtists
            .where(
                (ArtistChartDto element) => element.subgenres.contains(value))
            .toList(),
        genre: genre,
      ));
    }
    return radios;
  }

  /// Needed to get the Artist songs in Radio page for INFO button.
  Future<void> getRadioArtistTracks({
    required String artistId,
    required ArtistChartDto? artist,
  }) async {
    final List<Track> tracks = await _getArtistTracksUseCase(artistId);
    final Map<String, List<Track>> tracksMap = <String, List<Track>>{
      artistId: tracks
    };

    if (tracks.length > 1 && artist != null) {
      _mediaRadioArtistItems = tracks
          .map((Track e) => _getMediaItemFromUrl(
                e,
                artist,
              ))
          .toList();
    }

    emit(state.copyWith(radioInfoTracks: tracksMap));
  }

  ///Set the the artist preview songs to the Artist dialogue
  Future<void> setIsRadioInfoTracks(bool isRadioInfoTracks) async {
    if (isRadioInfoTracks) {
      emit(state.copyWith(
        radioArtistIndex: _audioPlayer.currentIndex ?? 0,
        isRadioPlaying: _audioPlayer.playing,
        radioPlayingPosition: _audioPlayer.position,
      ));
      setActive(value: false);
      await audioHandler.customAction('clear');
      await audioHandler.addQueueItems(_mediaRadioArtistItems);
    }
    emit(state.copyWith(isRadioInfoTracks: isRadioInfoTracks));
  }

  ///Remove the the artist preview songs
  Future<void> removeRadioInfoTracks() async {
    await audioHandler.customAction('clear');
    await audioHandler.addQueueItems(_mediaRadioItems);
    await audioHandler.skipToQueueItem(state.radioArtistIndex);
    await audioHandler.seek(state.radioPlayingPosition);
    if (state.isRadioPlaying) {
      setActive(value: true);
    }
  }

  Future<void> nextRadio() => audioHandler.skipToNext();

  ArtistChartDto? _getArtist(
    List<int> artistsIds,
    List<ArtistChartDto> artists,
  ) {
    for (final int id in artistsIds) {
      final ArtistChartDto? a = artists
          .where((ArtistChartDto e) => e.id == id.toString())
          .firstOrNull;
      if (a != null) return a;
    }
    return null;
  }

  List<Track> _getDistinctList(List<Track> tracks) {
    final List<Track> res = <Track>[];
    final List<String> artists = <String>[];

    for (final Track t in tracks) {
      if (!_trackContainsArtists(artists, t)) {
        res.add(t);
        artists.addAll(t.artists.map((int e) => e.toString()));
      }
    }
    return res;
  }

  bool _trackContainsArtists(List<String> artists, Track track) {
    for (final int a in track.artists) {
      if (artists.contains(a.toString())) {
        return true;
      }
    }
    return false;
  }

  Future<void> resumeRadio() async {
    emit(state.copyWith(loadingNext: true));
    final List<Track> tracks = _getDistinctList(
      await _rebelationApiService.getRadioTracks(
        PlayBody(
          favorites: _radioArtists
              .map((ArtistChartDto a) => int.tryParse(a.id) ?? 0)
              .toList(),
          exclude: _tracksId,
        ),
      ),
    );

    if (tracks.isEmpty) return;

    await audioHandler.addQueueItems(
      tracks
          .map(
            (Track e) => _getMediaItemFromUrl(
              e,
              _getArtist(e.artists, _radioArtists),
              fullSong: true,
            ),
          )
          .toList(),
    );

    _tracksId = <int>[..._tracksId, ...tracks.map((Track t) => t.id)];
    final List<Track> tracksFromFirebase = await _remoteTracksDataSource
        .getTracksByIds(tracks.map((Track t) => t.id).toList());

    emit(
      state.copyWith(
        loadingNext: false,
        radioTracks: <Track>[
          ...state.radioTracks,
          ...tracksFromFirebase,
        ],
      ),
    );
  }

  MediaItem _getMediaItemFromUrl(
    Track track,
    ArtistChartDto? artist, {
    bool fullSong = false,
  }) {
    return MediaItem(
      id: track.id.toString(),
      title: track.title,
      artist: track.displayArtists,
      artUri: Uri.tryParse(track.art.isEmpty ? artist?.image ?? '' : track.art),
      displayTitle: track.title,
      displaySubtitle: artist?.id,
      displayDescription: artist?.bio,
      extras: <String, dynamic>{
        'url': track.url,
        'clip': state.isTrialOrSubscriptionActive && fullSong,
        'subgenres': artist?.subgenres,
        'artist': jsonEncode(artist?.toJson()),
      },
    );
  }

  Future<void> addArtistToLiked(
    ArtistChartDto artist,
    List<String> collections,
  ) async {
    await performSafeAction(() async {
      await addLikeUseCase(artist.id, collections);
    });
  }

  Future<void> editArtistCollections(
    ArtistChartDto artist,
    List<String> collections,
  ) async {
    await performSafeAction(() async {
      await editArtistInCollectionUseCase(artist, collections);
    });
  }

  Future<void> unlikeArtist(ArtistChartDto artist) async {
    await performSafeAction(() async {
      await removeLikeUseCase(artist, null);
    });
  }

  Future<void> get isTrialOrSubscriptionActive async {
    final bool isActive = await getIt<PurchasesCat>().isActiveOffer();

    emit(state.copyWith(isTrialOrSubscriptionActive: isActive));
  }
}
