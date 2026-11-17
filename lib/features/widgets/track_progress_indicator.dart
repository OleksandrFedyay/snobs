import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/mixins/rebuild_mixin.dart';

class TrackProgressIndicator extends StatefulWidget {
  const TrackProgressIndicator({super.key});

  @override
  State<TrackProgressIndicator> createState() => _TrackProgressIndicatorState();
}

class _TrackProgressIndicatorState extends State<TrackProgressIndicator>
    with RebuildMixin<TrackProgressIndicator> {
  Duration? _duration;
  Duration? _position;

//  late PlayerState _streamState;
  late List<StreamSubscription<dynamic>> _streams;
  late final AudioPlayer _audioPlayer;
  double _progressIndicatorVaslue = 0;

  @override
  void initState() {
    _audioPlayer = GetIt.I.get<TrackAudioPlayerCubit>().audioHandler.player;
    _audioPlayer.durationFuture?.then(
      (Duration? value) => setState(() => _duration = value),
    );
    _position = _audioPlayer.position;

    //Todo(Issa): need to remove setState and add bloC
    _streams = <StreamSubscription<dynamic>>[
      _audioPlayer.durationStream
          .listen((Duration? value) => setState(() => _duration = value)),
      /*     _audioPlayer.playerStateStream
          .listen((PlayerState value) => setState(() => _streamState = value)),*/
      _audioPlayer.positionStream
          .listen((Duration value) => setState(() => _position = value)),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (final StreamSubscription<dynamic> it in _streams) {
      it.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_duration?.inMilliseconds == 0) {
      return const Icon(
        Icons.pause_rounded,
        size: 20,
        color: Colors.white,
      );
    }

    _progressIndicatorVaslue =
        (_position?.inMilliseconds ?? 0) / (_duration?.inMilliseconds ?? 1);

    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          CircularProgressIndicator(
            color: lightColorScheme.yellow,
            strokeWidth: 2,
            value: _progressIndicatorVaslue,
          ),
          const Icon(
            Icons.pause_rounded,
            size: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
