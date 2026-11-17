import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/disliked_container.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/view/components/offer_cards/native_ad_card_content.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({required this.dx, super.key});

  final double dx;

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNativeAd();
  }

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
                _adBlock(constraints),
                NativeAdCardContent(constraints: constraints),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _adBlock(BoxConstraints constraints) => SizedBox(
        height: constraints.maxHeight / 1.6,
        child: ColoredBox(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (!_isAdLoaded)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Positioned(
                    right: 3,
                    left: 3,
                    bottom: 3,
                    top: 10,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 300,
                        minHeight: 350,
                        maxHeight: 400,
                        maxWidth: 450,
                      ),
                      child: RepaintBoundary(child: AdWidget(ad: _nativeAd!)),
                    )),
              Center(child: DislikedContainer(dx: widget.dx)),
            ],
          ),
        ),
      );

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: Platform.isAndroid
          ? kDebugMode
              ? StringsRes.nativeAdUnitAndroidDebugId
              : StringsRes.nativeAdUnitAndroidId
          : StringsRes.nativeAdUnitId,
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.square,
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        cornerRadius: 16,
        mainBackgroundColor: Colors.black,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: lightColorScheme.yellow,
          style: NativeTemplateFontStyle.normal,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          style: NativeTemplateFontStyle.bold,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white70,
        ),
      ),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          unawaited(FirebaseAnalytics.instance.logEvent(
            name: 'native_ad_card_impression',
            parameters: <String, Object>{
              'source_page': StringsRes.swipePage,
            },
          ));
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Failed to load native ad: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
