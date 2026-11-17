import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/home/cubit/home_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class GenresTopPanel extends StatelessWidget {
  const GenresTopPanel({
    required this.genre,
    required this.selectedGenreOrSub,
    required this.isTrialOrSubscriptionActive,
    required this.onGenresTap,
    super.key,
  });

  final String genre;
  final String selectedGenreOrSub;
  final bool isTrialOrSubscriptionActive;
  final VoidCallback onGenresTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SvgPicture.asset(isTrialOrSubscriptionActive
                ? Assets.logos.snobsLogoPremium
                : Assets.logos.snobsLogoImage),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: context.read<HomeCubit>().randomGenreSubgenre,
                  child: SvgPicture.asset(Assets.icons.dice, height: 24),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onGenresTap,
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
                          selectedGenreOrSub.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: FontFamily.nunitoSans,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
