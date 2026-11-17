import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/widgets/track_progress_indicator.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({super.key});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackAudioPlayerCubit, TracksAudioPlayerState>(
      builder: (BuildContext context, TracksAudioPlayerState state) {
        if (state.active) {
          return GestureDetector(
            onTap: () {
              context.read<TrackAudioPlayerCubit>().setActive(value: false);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: lightColorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TrackProgressIndicator(),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            context.read<TrackAudioPlayerCubit>().setActive(value: true);
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white70,
              ),
              borderRadius: BorderRadius.circular(52),
            ),
            child: const Icon(
              Icons.play_arrow,
              size: 24,
              color: Colors.white70,
            ),
          ),
        );
      },
    );
  }
}
