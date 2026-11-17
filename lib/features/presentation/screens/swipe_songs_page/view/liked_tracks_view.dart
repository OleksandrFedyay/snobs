import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/track_progress_indicator.dart';

class LikedTracksView extends StatefulWidget {
  const LikedTracksView({
    required this.artistId,
    required this.likeTrack,
    this.artist,
    super.key,
  });

  final String artistId;
  final ArtistChartDto? artist;
  final ValueSetter<int?> likeTrack;

  @override
  State<LikedTracksView> createState() => _LikedTracksViewState();
}

class _LikedTracksViewState extends State<LikedTracksView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackAudioPlayerCubit, TracksAudioPlayerState>(
      builder: (BuildContext context, TracksAudioPlayerState state) {
        final int length = (state.isRadioInfoTracks
                    ? state.radioInfoTracks
                    : state.tracks)[widget.artistId]
                ?.length ??
            0;

        return Column(
          children: <Widget>[
            for (int i = 0; i < length; i++) ...<Widget>[
              const SizedBox(height: 8),
              _buildTrack(i, state),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 48),
                height: 1,
                color: lightColorScheme.onSurface,
              ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTrack(int index, TracksAudioPlayerState state) {
    final Track? track = (state.isRadioInfoTracks
        ? state.radioInfoTracks
        : state.tracks)[widget.artistId]?[index];

    return Row(
      children: <Widget>[
        GestureDetector(
          key: ValueKey<String>('${track?.id}${track?.likes}'),
          onTap: () => widget.likeTrack(track?.id),
          behavior: HitTestBehavior.opaque,
          child: track?.likes.contains(state.user?.id) ?? false
              ? const Icon(
                  Icons.favorite_rounded,
                  size: 24,
                  color: Color(0xffDDDDDD),
                )
              : const Icon(
                  Icons.favorite_outline_rounded,
                  size: 24,
                  color: Color(0xffDDDDDD),
                ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: GestureDetector(
            key: ValueKey<String>('track$index'),
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final TrackAudioPlayerCubit cubit =
                  context.read<TrackAudioPlayerCubit>();

              if (widget.artist != null &&
                  state.artist?.displaySubtitle != widget.artist?.id) {
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
                        style: context.textStyle.titleLarge
                            ?.copyWith(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
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
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white54,
                      ),
                      borderRadius: BorderRadius.circular(52),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 16,
                      color: Colors.white54,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
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
          width: 24,
          height: 24,
          alignment: Alignment.center,
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
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white54,
          ),
          borderRadius: BorderRadius.circular(52),
        ),
        child: const Icon(
          Icons.play_arrow,
          size: 16,
          color: Colors.white54,
        ),
      ),
    );
  }
}
