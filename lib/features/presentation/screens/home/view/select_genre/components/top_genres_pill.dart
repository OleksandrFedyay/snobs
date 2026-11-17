import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class TopGenresPill extends StatelessWidget {
  const TopGenresPill({
    required this.genre,
    required this.selectedGenreOrSub,
    required this.onRandom,
    required this.isGenreWithAllWord,
    super.key,
  });

  final String genre;
  final String selectedGenreOrSub;
  final VoidCallback onRandom;
  final bool isGenreWithAllWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.only(top: 4, right: 4, bottom: 8),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: onRandom,
            child: SvgPicture.asset(Assets.icons.dice, height: 24),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 28,
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 7,
                left: 17,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: lightColorScheme.onPrimaryContainer,
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    ...genre.genreStingToEnum.getColors(.3),
                    lightColorScheme.backgroundGrey.withValues(alpha: 0.5),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    isGenreWithAllWord
                        ? 'ALL ${selectedGenreOrSub.toUpperCase()}'
                        : selectedGenreOrSub.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
