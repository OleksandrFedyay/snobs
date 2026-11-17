import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';
import 'package:kingfishertom/features/widgets/track_progress_indicator.dart';

class TracksView extends StatefulWidget {
  const TracksView({
    required this.artist,
    super.key,
  });

  final ArtistChartDto? artist;

  @override
  State<TracksView> createState() => _TracksViewState();
}

class _TracksViewState extends State<TracksView> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackAudioPlayerCubit, TracksAudioPlayerState>(
      builder: (BuildContext context, TracksAudioPlayerState state) {
        final int tracksLength = (state.isRadioInfoTracks
                    ? state.radioInfoTracks
                    : state.tracks)[widget.artist?.id ?? '']
                ?.length ??
            0;

        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  context.i10n.songs,
                  style: context.textStyle.headlineMedium,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            for (int i = 0;
                i < (showAll || tracksLength < 5 ? tracksLength : 5);
                i++) ...<Widget>[
              const SizedBox(height: 8),
              _buildTrack(i, state),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 1,
                color: lightColorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 8),
            ],
            if (tracksLength > 5 && !showAll) _buildShowAllButton(),
          ],
        );
      },
    );
  }

  Widget _buildTrack(int index, TracksAudioPlayerState state) {
    final Track? track = (state.isRadioInfoTracks
        ? state.radioInfoTracks
        : state.tracks)[widget.artist?.id ?? '']?[index];

    return GestureDetector(
      key: ValueKey<String>('track$index'),
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final TrackAudioPlayerCubit cubit =
            context.read<TrackAudioPlayerCubit>();

        if (state.artist?.displaySubtitle != widget.artist?.id) {
          await context.read<TrackAudioPlayerCubit>().setActiveArtist(
                widget.artist,
                index,
              );
        } else {
          await cubit.audioHandler.skipToQueueItem(index);
        }

        if (!state.active) cubit.setActive(value: true);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  track?.title ?? '',
                  style: context.textStyle.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  track?.displayArtists ?? '',
                  style: context.textStyle.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (track?.id.toString() == state.artist?.id)
            _buildPlayButton(state)
          else
            Container(
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
        ],
      ),
    );
  }

  Widget _buildPlayButton(TracksAudioPlayerState state) {
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
  }

  Widget _buildShowAllButton() {
    return AppButton(
      onPressed: () {
        setState(() {
          showAll = true;
        });
      },
      text: context.i10n.moreSongs.toUpperCase(),
      withArrow: false,
      style: AppThemeModel.instance.getGreyButtonTheme().style,
    );
  }
}
