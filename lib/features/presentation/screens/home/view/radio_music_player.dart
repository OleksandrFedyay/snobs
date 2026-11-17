import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/radio/radio_dto.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/artist_player_card.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/show_artist_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/suggested_radio_view.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/player_progress_indicatior.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RadioMusicPlayerDialog extends StatefulWidget {
  const RadioMusicPlayerDialog._({required this.exploreSubgenre});

  final Function(String genre, String subgenre) exploreSubgenre;

  static void showModalDialog(
    BuildContext context,
    Function(String genre, String subgenre) exploreSubgenre,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => RadioMusicPlayerDialog._(
        exploreSubgenre: exploreSubgenre,
      ),
    );
  }

  @override
  State<RadioMusicPlayerDialog> createState() => _MusicPlayerDialogState();
}

class _MusicPlayerDialogState extends State<RadioMusicPlayerDialog> {
  TrackAudioPlayerCubit _getCubit(BuildContext context) => context.read();

  List<RadioDto> _radioStations = <RadioDto>[];
  List<String> _subGenres = <String>[];

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = MediaQuery.of(context).padding;
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<TrackAudioPlayerCubit, TracksAudioPlayerState>(
      builder: (BuildContext context, TracksAudioPlayerState state) {
        final Track? track = state.radioStatus == RadioStatus.active
            ? state.radioTracks.firstWhereOrNull(
                (Track t) => t.id.toString() == state.artist?.id)
            : state.tracks[state.artist?.displaySubtitle]
                ?.where((Track e) => e.id.toString() == state.artist?.id)
                .firstOrNull;

        final String bio = state.artist?.displayDescription ?? '';
        final String decodeArtist =
            state.artist?.extras?['artist'] as String? ?? '';
        final Map<String, dynamic>? map =
            jsonDecode(decodeArtist) as Map<String, dynamic>?;
        final ArtistChartDto? artist =
            map == null ? null : ArtistChartDto.fromJson(map);

        if (_subGenres !=
            ((state.artist?.extras?['subgenres'] as List<String>?) ??
                <String>[])) {
          _getCubit(context)
              .getRadioArtistTracks(artistId: artist?.id ?? '', artist: artist);
          _subGenres = (state.artist?.extras?['subgenres'] as List<String>?) ??
              <String>['NA'];
          _radioStations = _getCubit(context).prepareSuggestedRadios(
              genre: state.radioGenre, subgenres: _subGenres);
        }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                        context.i10n.radio,
                        style: context.textStyle.headlineSmall,
                      ),
                      Text(
                        '${context.i10n.playing} ${state.radioTitle} ${context.i10n.radio}',
                        style: context.textStyle.bodySmall?.copyWith(
                          color: lightColorScheme.yellowLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedNetworkImage(
                      width: size.width - 24,
                      height: size.width - 24,
                      imageUrl: state.artist?.artUri?.toString() ?? '',
                      errorWidget: (_, __, ___) {
                        return _buildErrorWidget(size.width);
                      },
                      placeholder: (_, __) {
                        return _buildErrorWidget(size.width);
                      },
                    ),
                  ),
                ),
                //Todo(Issa): Check may need to remove this logic
                /*      Padding(
                  padding: const EdgeInsets.all(4),
                  child: CarouselSlider(
                    items: _radioStations.map((RadioDto radio) {
                        return   ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(12)),
                          child: CachedNetworkImage(
                            width: size.width - 24,
                            height: size.width - 24,
                            imageUrl: state.artist?.artUri?.toString() ?? '',
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
                ),*/
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 320,
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          state.artist?.title ?? '',
                          style: context.textStyle.headlineSmall,
                          maxLines: 2,
                          minFontSize: 16,
                          maxFontSize: 24,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        key: ValueKey<String>('${track?.id}${track?.likes}'),
                        onTap: _getCubit(context).likeTrack,
                        behavior: HitTestBehavior.opaque,
                        child: track?.likes.contains(state.user?.id) ?? false
                            ? const Icon(
                                Icons.favorite_rounded,
                                size: 24,
                                color: Colors.white54,
                              )
                            : const Icon(
                                Icons.favorite_outline_rounded,
                                size: 24,
                                color: Colors.white54,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const PlayerProgressIndicator(),
                const SizedBox(height: 16),
                _buildControls(
                    context, state, track, _radioStations.firstOrNull, artist),
                //Todo(Issa): Its temporarily needed while some artists with null information
                //Task https://app.asana.com/0/1207103966829624/1209049174000476/f
                Visibility(
                  visible: artist != null,
                  child: Column(
                    children: <Widget>[
                      ArtistPlayerCard(
                          artist: artist,
                          bio: bio,
                          state: state,
                          cubit: _getCubit(context),
                          exploreSubgenre: (String genre, String subgenre) {
                            widget.exploreSubgenre(genre, subgenre);
                            Navigator.of(context).pop();
                          }),
                      Text(
                        context.i10n.suggestedRadio,
                        style: context.textStyle.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SuggestedRadioView(
                        key: UniqueKey(),
                        radios: _radioStations,
                        allGenres: state.allGenres,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(height: padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(double width) {
    return Container(
      width: width - 104,
      height: width - 104,
      color: lightColorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildControls(BuildContext context, TracksAudioPlayerState state,
      Track? track, RadioDto? radio, ArtistChartDto? artist) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (artist != null) {
                _getCubit(context).setIsRadioInfoTracks(true);
                showArtistDialog(context, artist, state, _getCubit(context),
                    (String genre, String subgenre) {
                  Navigator.of(context).pop();
                  widget.exploreSubgenre(genre, subgenre);
                });
              }
            },
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.info_outline_rounded,
              size: 28,
              color: Colors.white54,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _getCubit(context).setActive,
              behavior: HitTestBehavior.opaque,
              child: state.active
                  ? SizedBox(
                      width: 60,
                      child: Lottie.asset(
                        Assets.anim.radioPauseButton,
                        fit: BoxFit.fill,
                      ),
                    )
                  : SvgPicture.asset(
                      Assets.icons.playRadio,
                      width: 53,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          //  if(state.artistCount)
          GestureDetector(
            onTap: _getCubit(context).nextRadio,
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.skip_next_outlined,
              size: 34,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
