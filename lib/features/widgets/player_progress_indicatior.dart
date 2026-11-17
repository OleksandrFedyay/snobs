import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/duration_ext.dart';
import 'package:kingfishertom/features/utils/mixins/rebuild_mixin.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PlayerProgressIndicator extends StatefulWidget {
  const PlayerProgressIndicator({super.key});

  @override
  State<PlayerProgressIndicator> createState() =>
      _PlayerProgressIndicatorState();
}

class _PlayerProgressIndicatorState extends State<PlayerProgressIndicator>
    with RebuildMixin<PlayerProgressIndicator> {
  Duration? duration;
  Duration? position;
  PlayerState? streamState;
  late List<StreamSubscription<dynamic>> streams;
  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    audioPlayer = GetIt.I.get<TrackAudioPlayerCubit>().audioHandler.player;
    audioPlayer.durationFuture?.then(
      (Duration? value) => setStateIfMounted(() => duration = value),
    );
    position = audioPlayer.position;

    streams = <StreamSubscription<dynamic>>[
      audioPlayer.durationStream.listen(
          (Duration? value) => setStateIfMounted(() => duration = value)),
      audioPlayer.playerStateStream.listen(
          (PlayerState value) => setStateIfMounted(() => streamState = value)),
      audioPlayer.positionStream.listen(
          (Duration value) => setStateIfMounted(() => position = value)),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (final StreamSubscription<dynamic> it in streams) {
      it.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (duration?.inMilliseconds == 0) {
      return const SizedBox.shrink();
    }

    final double value =
        (position?.inMilliseconds ?? 0) / (duration?.inMilliseconds ?? 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IgnorePointer(
          child: SfSliderTheme(
            data: const SfSliderThemeData(
              overlayRadius: 12,
              activeTrackHeight: 1,
              inactiveTrackHeight: 1,
              trackCornerRadius: 12,
              thumbRadius: 0,
            ),
            child: SfSlider(
              inactiveColor: Colors.white24,
              activeColor: lightColorScheme.yellowAccent,
              value: value,
              onChanged: (_) {},
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const SizedBox(width: 12),
            Text(
              position?.getString() ?? '',
              style: context.textStyle.bodySmall,
            ),
            const Spacer(),
            Text(
              duration?.getString() ?? '',
              style: context.textStyle.bodySmall,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }
}
