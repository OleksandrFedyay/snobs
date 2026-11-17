import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  AudioPlayerHandler({
    required this.player,
  }) {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  final AudioPlayer player;
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: <AudioSource>[]);

  void _notifyAudioHandlerAboutPlaybackEvents() {
    player.playbackEventStream.listen((PlaybackEvent event) {
      final bool playing = player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: <MediaControl>[
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          systemActions: const <MediaAction>{
            MediaAction.seek,
          },
          androidCompactActionIndices: const <int>[0, 1, 3],
          processingState: const <ProcessingState, AudioProcessingState>{
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[player.processingState]!,
          repeatMode: const <LoopMode, AudioServiceRepeatMode>{
            LoopMode.off: AudioServiceRepeatMode.none,
            LoopMode.one: AudioServiceRepeatMode.one,
            LoopMode.all: AudioServiceRepeatMode.all,
          }[player.loopMode]!,
          shuffleMode: (player.shuffleModeEnabled)
              ? AudioServiceShuffleMode.all
              : AudioServiceShuffleMode.none,
          playing: playing,
          updatePosition: player.position,
          bufferedPosition: player.bufferedPosition,
          speed: player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  void _listenForDurationChanges() {
    player.durationStream.listen((Duration? duration) {
      int? index = player.currentIndex;
      final List<MediaItem> newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices!.indexOf(index);
      }
      final MediaItem oldMediaItem = newQueue[index];
      final MediaItem newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    player.currentIndexStream.listen((int? index) {
      final List<MediaItem> playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final List<IndexedAudioSource>? sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final Iterable<MediaItem> items = sequence.map((IndexedAudioSource source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final Iterable<AudioSource> audioSource = mediaItems.map(_createAudioSource);
    await _playlist.addAll(audioSource.toList());

    // notify system
    final List<MediaItem> newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  Future<void> insertQueueItems(int index, List<MediaItem> mediaItems) async {
    // manage Just Audio
    final Iterable<AudioSource> audioSource =
        mediaItems.map(_createAudioSource);
    await _playlist.insertAll(index + 1, audioSource.toList());

    // notify system
    final List<MediaItem> newQueue = queue.value
      ..insertAll(index + 1, mediaItems);
    queue.add(newQueue);
  }

  Future<void> removeQueueItems(int startIndex, int endIndex) async {
    // manage Just Audio
    await _playlist.removeRange(startIndex + 1, endIndex + 1);

    // notify system
    final List<MediaItem> newQueue = queue.value
      ..removeRange(startIndex + 1, endIndex + 1);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final AudioSource audioSource = _createAudioSource(mediaItem);
    await _playlist.add(audioSource);

    // notify system
    final List<MediaItem> newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  AudioSource _createAudioSource(MediaItem mediaItem) {
    if (mediaItem.extras?['clip'] as bool? ?? false) {
      return AudioSource.uri(
        Uri.parse(mediaItem.extras?['url'] as String? ?? ''),
        tag: mediaItem,
      );
    }

    return ClippingAudioSource(
      tag: mediaItem,
      child: AudioSource.uri(
        Uri.parse(mediaItem.extras?['url'] as String? ?? ''),
        tag: mediaItem,
      ),
      start: const Duration(seconds: 30),
      end: const Duration(seconds: 60),
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    await _playlist.removeAt(index);

    // notify system
    final List<MediaItem> newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    int ind = index;
    if (ind < 0 || ind >= queue.value.length) return;
    if (player.shuffleModeEnabled) {
      ind = player.shuffleIndices![ind];
    }
    try {
      await player.seek(Duration.zero, index: ind);
    } catch (e) {
      log('exception');
    }
  }

  @override
  Future<void> skipToNext() => player.seekToNext();

  @override
  Future<void> skipToPrevious() => player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    try {
      await player.setAudioSource(
        _playlist,
        initialIndex: 0,
        initialPosition: Duration.zero,
      );
    } catch (e) {
      log('Error: $e');
    }
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await player.setLoopMode(LoopMode.off);
      case AudioServiceRepeatMode.one:
        await player.setLoopMode(LoopMode.one);
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        await player.setLoopMode(LoopMode.all);
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      await player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'clear') {
      await _playlist.clear();
    } else if (name == 'dispose') {
      await player.stop();
      await player.dispose();
      await super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await player.stop();
    return super.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    await player.stop();
    return super.onTaskRemoved();
  }
}
