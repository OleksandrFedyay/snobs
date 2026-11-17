import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/vote_genre.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/confirm_dialog.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/cubit/genres_cubit.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/tag_tap_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

class GenresView extends StatefulWidget {
  const GenresView(
    this.artist,
    this.exploreSubgenre, {
    this.onOrganizeArtistTap,
    this.padding,
    super.key,
  });

  final ArtistChartDto artist;
  final Function(String genre, String subgenre) exploreSubgenre;
  final VoidCallback? onOrganizeArtistTap;
  final EdgeInsetsGeometry? padding;

  @override
  State<GenresView> createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView> {
  GenresCubit get cubit => context.read();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenresCubit, GenresState>(
      builder: (BuildContext context, GenresState state) {
        if (state.status == GenresStatus.loading) {
          return const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.status == GenresStatus.error) {
          return const SizedBox.shrink();
        }

        if (state.votes.isEmpty) return const SizedBox.shrink();

        return Container(
          height: 24,
          alignment: Alignment.centerLeft,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: widget.padding,
            children: <Widget>[
              ...state.votes
                  .map((VoteGenre chart) => _buildSubgenre(chart, state)),
              if (widget.onOrganizeArtistTap != null)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    onPressed: widget.onOrganizeArtistTap,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubgenre(VoteGenre chart, GenresState state) {
    final String genreString = state.genreSubgenres.genreType(
      chart: chart,
      subgenresOfGenre: state.subgenresOfGenre,
    );

    final GenreEnum genre = genreString.genreStingToEnum;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          TagTapDialog.showTapDialog(
            context,
            genreString,
            chart.genre,
            widget.exploreSubgenre,
            () {
              context.read<TrackAudioPlayerCubit>().startRadio(
                <ArtistChartDto>[],
                <String>[chart.genre],
                genreString,
              );
            },
            () {
              showDialog<void>(
                context: context,
                builder: (_) {
                  return ConfirmArtistDialog(
                    title: context.i10n.wouldYouLikeToRemove(
                      widget.artist.name,
                      chart.genre.toTitleCase(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      cubit.updateSubgenres(
                        widget.artist,
                        state.subgenres..remove(chart.genre),
                      );
                    },
                  );
                },
              );
            },
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: lightColorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: lightColorScheme.onPrimaryContainer,
              borderRadius: BorderRadius.circular(38),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  ...genre.getColors(.3),
                  lightColorScheme.backgroundGrey.withValues(alpha: 0.5),
                ],
              ),
            ),
            child: Center(
              child: Text(
                chart.genre.toTitleCase(),
                style: context.textStyle.labelSmall?.copyWith(
                  color: lightColorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
