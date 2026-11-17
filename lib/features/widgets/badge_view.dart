import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/genres_view/tag_tap_dialog.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class BadgeView extends StatelessWidget {
  const BadgeView({
    required this.genre,
    required this.subgenre,
    required this.number,
    required this.onExploreSubgenre,
    super.key,
  });

  final String subgenre;
  final String genre;
  final int number;
  final void Function(String genre, String subgenre) onExploreSubgenre;

  @override
  Widget build(BuildContext context) {
    final GenreEnum genreEnum = genre.genreStingToEnum;
    final Color genreColor = genreEnum.getColors().first;

    return GestureDetector(
      onTap: () => _onBadgeTap(context),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                Assets.badges.background1.path,
                fit: BoxFit.fill,
              ),
            ),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: <Color>[
                    genreColor,
                    genreColor,
                    if (number == 100) genreColor else Colors.grey[700]!
                  ],
                  stops: <double>[0.0, (number / 100), (number / 100)],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Positioned.fill(
                    right: 15,
                    left: 15,
                    bottom: 10,
                    top: 10,
                    child: SvgPicture.asset(
                      Assets.badges.background2,
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                        genreColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: genreColor),
                    ),
                    child: AutoSizeText(
                      subgenre.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 14,
                      maxFontSize: 18,
                      style: TextStyle(
                        fontSize: 16,
                        color: genreColor,
                        fontWeight: FontWeight.w800,
                        fontFamily: FontFamily.nunitoSans,
                      ),
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

  void _onBadgeTap(BuildContext context) {
    TagTapDialog.showTapDialog(
      context,
      genre,
      subgenre,
      onExploreSubgenre,
      () {
        context.read<TrackAudioPlayerCubit>().startRadio(
          <ArtistChartDto>[],
          <String>[subgenre],
          genre,
        );
      },
      null,
    );
  }
}
