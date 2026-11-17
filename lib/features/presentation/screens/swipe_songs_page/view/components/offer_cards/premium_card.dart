import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/disliked_container.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/liked_container.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/offer_cards/premium_card_content.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';
import 'package:lottie/lottie.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    required this.isTrailSubscription,
    required this.dx,
    super.key,
  });

  final double dx;
  final bool isTrailSubscription;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: ColoredBox(
            color: lightColorScheme.onPrimary,
            child: Column(
              children: <Widget>[
                _premiumAnimation(context, constraints),
                PremiumCardContent(
                  constraints: constraints,
                  isTrailSubscription: isTrailSubscription,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _premiumAnimation(
    BuildContext context,
    BoxConstraints constraints,
  ) =>
      SizedBox(
        height: constraints.maxHeight / 1.7,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const <double>[0.6, 1.0],
                  colors: <Color>[
                    lightColorScheme.charcoal,
                    lightColorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 5,
                bottom: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SvgPicture.asset(
                    Assets.logos.premiumCardLogo,
                    height: 22,
                  ),
                  Text(
                    context.i10n.fullSongRadio,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                  Text(
                    context.i10n.goBeyond30SecondSongPreviews,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxWidth / 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: const <double>[0.6, 1.0],
                          colors: <Color>[
                            lightColorScheme.darkBlue,
                            lightColorScheme.lightBlue,
                          ],
                        ),
                      ),
                      child: RepaintBoundary(
                        child: Lottie.asset(
                          width: double.infinity,
                          Assets.anim.premiumAnim,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(child: LikedContainer(dx: dx)),
            Center(child: DislikedContainer(dx: dx)),
          ],
        ),
      );
}
