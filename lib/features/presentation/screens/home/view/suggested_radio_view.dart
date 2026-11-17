import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/radio/radio_dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

class SuggestedRadioView extends StatelessWidget {
  const SuggestedRadioView({
    required this.radios,
    required this.allGenres,
    super.key,
  });

  final List<RadioDto> radios;
  final List<Genre> allGenres;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: radios.map((RadioDto radio) {
        final String genreName =
            allGenres.getGenreBySubgenre(radio.subgenres[0]);
        final GenreEnum genre = genreName.genreStingToEnum;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: lightColorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[
                  ...genre.getColors(.3),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  radio.subgenres.first.toTitleCase(),
                  style: context.textStyle.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.read<TrackAudioPlayerCubit>().startRadio(
                          radio.artists,
                          radio.subgenres,
                          radio.genre,
                        );
                  },
                  child: SvgPicture.asset(
                    Assets.icons.playBig,
                    width: 60,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
