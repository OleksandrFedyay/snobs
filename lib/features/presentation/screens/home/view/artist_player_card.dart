import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/view/single_artist/show_artist_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

class ArtistPlayerCard extends StatelessWidget {
  const ArtistPlayerCard({
    required this.artist,
    required this.bio,
    required this.state,
    required this.cubit,
    required this.exploreSubgenre,
    super.key,
  });

  final ArtistChartDto? artist;
  final String bio;
  final TracksAudioPlayerState state;
  final TrackAudioPlayerCubit cubit;
  final Function(String genre, String subgenre) exploreSubgenre;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (state.playerType == PlayerType.radio) {
          cubit.setIsRadioInfoTracks(true);
        }
        showArtistDialog(context, artist, state, cubit, exploreSubgenre);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: lightColorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: CachedNetworkImage(
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    imageUrl: artist?.image ?? '',
                    errorWidget: (_, __, ___) {
                      return _buildErrorWidget(88);
                    },
                    placeholder: (_, __) {
                      return _buildErrorWidget(88);
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          artist?.name ?? '',
                          style: context.textStyle.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DefaultTextStyle(
                              maxLines: 2,
                              style: context.textStyle.bodySmall ??
                                  const TextStyle(),
                              child: Html(
                                data: bio.length > 80
                                    ? '${bio.substring(0, 80)}...'
                                    : bio,
                                shrinkWrap: true,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: lightColorScheme.fieldText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: '${context.i10n.tags}: ',
                style: context.textStyle.bodySmall,
                children: <InlineSpan>[
                  TextSpan(
                    text: ((state.artist?.extras?['subgenres']
                                as List<String>?) ??
                            <String>[])
                        .map((String s) => s.toTitleCase())
                        .join(', '),
                    style: context.textStyle.bodySmall?.copyWith(
                      color: lightColorScheme.yellowLight,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(double width) {
    return Container(
      width: width - 24,
      height: width - 24,
      color: lightColorScheme.surfaceContainerHighest,
    );
  }
}
