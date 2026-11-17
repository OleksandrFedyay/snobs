import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/artist_player_card.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/liked_tracks_view.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/player_progress_indicatior.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MusicPlayerDialog extends StatefulWidget {
  const MusicPlayerDialog._({required this.exploreSubgenre});

  final Function(String genre, String subgenre) exploreSubgenre;

  static void showModalDialog(
    BuildContext context,
    Function(String genre, String subgenre) exploreSubgenre,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MusicPlayerDialog._(exploreSubgenre: exploreSubgenre),
    );
  }

  @override
  State<MusicPlayerDialog> createState() => _MusicPlayerDialogState();
}

class _MusicPlayerDialogState extends State<MusicPlayerDialog> {
  TrackAudioPlayerCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<TrackAudioPlayerCubit, TracksAudioPlayerState>(
      builder: (BuildContext context, TracksAudioPlayerState state) {
        final Track? track = state.tracks[state.artist?.displaySubtitle]
            ?.where((Track e) => e.id.toString() == state.artist?.id)
            .firstOrNull;

        final String decodeArtist =
            state.artist?.extras?['artist'] as String? ?? '';
        final Map<String, dynamic>? map =
            jsonDecode(decodeArtist) as Map<String, dynamic>?;
        final ArtistChartDto? artist =
            map == null ? null : ArtistChartDto.fromJson(map);
        final String bio = state.artist?.displayDescription ?? '';

        return Container(
          height: size.height - padding.top - 40,
          decoration: BoxDecoration(
            color: lightColorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                lightColorScheme.primaryContainer,
                lightColorScheme.onPrimary,
                lightColorScheme.onPrimary,
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 0, 28),
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    context.i10n.close.toUpperCase(),
                    style: context.textStyle.labelMedium,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      context.i10n.previews,
                      style: context.textStyle.headlineSmall,
                    ),
                    Text(
                      '${context.i10n.playing} ${artist?.name ?? ''}',
                      style: context.textStyle.bodySmall?.copyWith(
                        color: lightColorScheme.yellowLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(4),
                child: CarouselSlider(
                  items: state.tracks[state.artist?.displaySubtitle ?? '']
                      ?.map((Track track) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: CachedNetworkImage(
                        width: size.width - 24,
                        height: size.width - 24,
                        imageUrl: track.art,
                        errorWidget: (_, __, ___) {
                          return _buildErrorWidget(size.width);
                        },
                        placeholder: (_, __) {
                          return _buildErrorWidget(size.width);
                        },
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    //  viewportFraction: 0.9,
                    aspectRatio: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (int ind, _) {
                      context
                          .read<TrackAudioPlayerCubit>()
                          .audioHandler
                          .skipToQueueItem(ind);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        state.artist?.title ?? '',
                        style: context.textStyle.headlineSmall,
                      ),
                    ),
                    GestureDetector(
                      key: ValueKey<String>('${track?.id}${track?.likes}'),
                      onTap: _getCubit(context).likeTrack,
                      behavior: HitTestBehavior.opaque,
                      child: track?.likes.contains(state.user?.id) ?? false
                          ? const Icon(
                              Icons.favorite_rounded,
                              size: 28,
                              color: Colors.white54,
                            )
                          : const Icon(
                              Icons.favorite_outline_rounded,
                              size: 28,
                              color: Colors.white54,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const PlayerProgressIndicator(),
              const SizedBox(height: 16),
              _buildControls(context, state, track),
              ArtistPlayerCard(
                artist: artist,
                bio: bio,
                state: state,
                cubit: _getCubit(context),
                  exploreSubgenre: (String genre, String subgenre){
                    widget.exploreSubgenre(genre, subgenre);
                    Navigator.of(context).pop();
                  }
              ),
              Text(
                context.i10n.songPreview,
                style: context.textStyle.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              LikedTracksView(
                likeTrack: _getCubit(context).likeTrackId,
                artistId: state.artist?.displaySubtitle ?? '',
              ),
              const SizedBox(height: 40),
              SizedBox(height: padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(double width) {
    return Container(
      width: width - 24,
      height: width - 24,
      color: lightColorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildControls(
    BuildContext context,
    TracksAudioPlayerState state,
    Track? track,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _getCubit(context).audioHandler.skipToPrevious,
          behavior: HitTestBehavior.opaque,
          child: const Icon(
            Icons.skip_previous_outlined,
            size: 34,
            color: Colors.white54,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _getCubit(context).setActive,
          behavior: HitTestBehavior.opaque,
          child: state.active
              ? const Icon(
                  Icons.pause_rounded,
                  size: 44,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.play_arrow,
                  size: 44,
                  color: Colors.white54,
                ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _getCubit(context).audioHandler.skipToNext,
          behavior: HitTestBehavior.opaque,
          child: const Icon(
            Icons.skip_next_outlined,
            size: 34,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
