import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/number_buble.dart';
import 'package:kingfishertom/features/widgets/play_button.dart';

class TrackWidget extends StatelessWidget {
  const TrackWidget({
    required this.trackIndex,
    required this.track,
    required this.active,
    super.key,
    this.withBubble = false,
  });

  final int trackIndex;
  final Track track;
  final bool active;
  final bool withBubble;

  SubgenrePageCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey<String>('${active}track$trackIndex'),
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final SubgenrePageCubit cubit = _getCubit(context);
        await context.read<TrackAudioPlayerCubit>().play(<Track>[track], null);
        cubit.setCurrentArtist(track.id.toString());
      },
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (withBubble) ...<Widget>[
                NumberBuble(number: trackIndex + 1),
                const SizedBox(width: 20),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      track.title,
                      style: context.textStyle.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track.displayArtists,
                      style: context.textStyle.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (active)
                const PlayButton()
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
          const SizedBox(height: 8),
          Container(
            color: Colors.white12,
            height: 1,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
