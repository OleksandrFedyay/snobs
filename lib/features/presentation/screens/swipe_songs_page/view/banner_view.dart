import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class BannerView extends StatelessWidget {
  const BannerView({
    required this.bannerAd,
    required this.loaded,
    super.key,
  });

  final BannerAd bannerAd;
  final bool loaded;

  @override
  Widget build(BuildContext context) {
    if (!loaded) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: lightColorScheme.greyTextColor,
          ),
          child: Text(
            context.i10n.ad,
            style: context.textStyle.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            ),
          ),
        ),
      ],
    );
  }
}
