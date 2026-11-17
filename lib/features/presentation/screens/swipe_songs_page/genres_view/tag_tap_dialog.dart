import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/core/services/di/injection.dart';
import 'package:kingfishertom/core/services/purchases/purchases_cat.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/premium/trail_premium_view.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TagTapDialog extends StatelessWidget {
  const TagTapDialog._(
    this.genre,
    this.subgenre,
    this.exploreSubgenre,
    this.startRadio,
    this.removeSubgenre,
  );

  final String genre;
  final String subgenre;
  final Function(String genre, String subgenre) exploreSubgenre;
  final VoidCallback startRadio;
  final VoidCallback? removeSubgenre;

  static void showTapDialog(
    BuildContext context,
    String genre,
    String subgenre,
    void Function(String genre, String subgenre) exploreSubgenre,
    VoidCallback startRadio,
    VoidCallback? removeSubgenre,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TagTapDialog._(
        genre,
        subgenre,
        exploreSubgenre,
        startRadio,
        removeSubgenre,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GenreEnum g = genre.genreStingToEnum;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: Navigator.of(context).pop,
              child: Text(
                context.i10n.cancel.toUpperCase(),
                style: context.textStyle.labelMedium,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              g.getGenreIcon(),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.i10n.youTapped,
                    style: context.textStyle.labelSmall?.copyWith(
                      color: lightColorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subgenre.toTitleCase(),
                    style: context.textStyle.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            context.i10n.whatWouldYouLikeDo,
            style: context.textStyle.displaySmall?.copyWith(
              color: lightColorScheme.onSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightColorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                _buildActionRow(
                  context,
                  () {
                    exploreSubgenre(genre, subgenre);
                    Navigator.of(context).pop();
                  },
                  context.i10n.exploreArtists,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset(
                      Assets.tab.activeCardSwipe,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        lightColorScheme.iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(52, 8, 8, 8),
                  color: lightColorScheme.onSurface,
                  width: double.infinity,
                  height: 1,
                ),
                _buildActionRow(
                  context,
                  () => _startRadio(context),
                  context.i10n.startRadio,
                  SvgPicture.asset(
                    Assets.icons.playBig,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      lightColorScheme.iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(52, 8, 8, 8),
                  color: lightColorScheme.onSurface,
                  width: double.infinity,
                  height: 1,
                ),
                _buildActionRow(
                  context,
                  () {
                    router.pushGenreSubgenresRouteRoute(
                      genre,
                      subgenre,
                      exploreSubgenre,
                      GenrePageType.subgenre,
                    );
                  },
                  context.i10n.viewMyCollections,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(
                      Assets.tab.activeLibrary,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        lightColorScheme.iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                if (removeSubgenre != null)
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(52, 8, 8, 8),
                        color: lightColorScheme.onSurface,
                        width: double.infinity,
                        height: 1,
                      ),
                      _buildActionRow(
                        context,
                        () {
                          Navigator.of(context).pop();
                          removeSubgenre!();
                        },
                        context.i10n.removeSubgenreTag,
                        SvgPicture.asset(
                          Assets.icons.pushPin,
                          height: 36,
                          colorFilter: ColorFilter.mode(
                            lightColorScheme.iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    VoidCallback onTap,
    String title,
    Widget image,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: <Widget>[
            image,
            const SizedBox(width: 12),
            Text(title, style: context.textStyle.bodyLarge),
          ],
        ),
      ),
    );
  }

  Future<void> _startRadio(BuildContext context) async {
    if (await getIt<PurchasesCat>().isActiveOffer()) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      startRadio();
    } else {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'trial_30_day_library_impression',
        parameters: <String, Object>{
          'source_page': StringsRes.genrePage,
        },
      ));
      if (context.mounted) {
        TrailPremiumViewDialog.showDialog(
          context: context,
          isTrail: context.read<TrackAudioPlayerCubit>().state.user?.daysLeft ==
              null,
          pageName: StringsRes.genrePage,
        );
      }
    }
  }
}
