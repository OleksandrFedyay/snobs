import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/common_pages/audio_player/cubit/tracks_audio_player_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/premium/trail_premium_view.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';

class NativeAdCardContent extends StatelessWidget {
  const NativeAdCardContent({
    required this.constraints,
    super.key,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: constraints.maxHeight - (constraints.maxHeight / 1.6),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16,
          left: 16,
          top: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              context.i10n.nativeAdDesc,
              style: context.textStyle.displaySmall?.copyWith(
                color: lightColorScheme.onSecondary,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                unawaited(FirebaseAnalytics.instance.logEvent(
                  name: 'native_ad_card_click',
                  parameters: <String, Object>{
                    'source_page': StringsRes.swipePage,
                  },
                ));
                if (context.mounted) {
                  TrailPremiumViewDialog.showDialog(
                    context: context,
                    isTrail: context
                            .read<TrackAudioPlayerCubit>()
                            .state
                            .user
                            ?.daysLeft ==
                        null,
                    pageName: StringsRes.swipePage,
                  );
                }
              },
              child: Text(context.i10n.nativeAdPremium,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1.5,
                    decorationColor: lightColorScheme.onSecondary,
                    fontSize: 14,
                    color: lightColorScheme.onSecondary,
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
