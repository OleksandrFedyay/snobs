import 'package:flutter/material.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

//PNG
Future<void> preloadPNGJPG(BuildContext context) async {
  await Future.wait(<Future<void>>[
     _precachePNGJPG(Assets.images.sonyWhCh720n.image(), context),
     _precachePNGJPG(Assets.images.amazonButton.image(), context),
     _precachePNGJPG(Assets.images.ankerSoundcore2.image(), context),
     _precachePNGJPG(Assets.images.afProd3.image(), context),
     _precachePNGJPG(Assets.badges.background1.image(), context),
  ]);
}

Future<void> _precachePNGJPG(Image image, BuildContext context) =>
    precacheImage(
      image.image,
      context,
    );

//SVG
void preloadSVG(BuildContext context) {
  Assets.icons.sensors.precacheSVG(context);
  Assets.logos.premiumCardLogo.precacheSVG(context);
  Assets.tab.activeCardSwipe.precacheSVG(context);
  Assets.tab.activeLibrary.precacheSVG(context);
  Assets.tab.activeProfile.precacheSVG(context);
  Assets.tab.inactiveCardSwipe.precacheSVG(context);
  Assets.tab.inactiveLibrary.precacheSVG(context);
  Assets.tab.inactiveProfile.precacheSVG(context);
  Assets.icons.playRadio.precacheSVG(context);
  Assets.images.recommendedBanner.precacheSVG(context);
  Assets.badges.background2.precacheSVG(context);
  Assets.icons.likeButton.precacheSVG(context);
}
