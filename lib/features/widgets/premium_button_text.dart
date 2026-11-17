import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class PremiumButtonTitle extends StatelessWidget {
  const PremiumButtonTitle({required this.isTrail, super.key});

  final bool isTrail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          isTrail
              ? context.i10n.claimYourFreeTrial.toUpperCase()
              : context.i10n.subscribe.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            wordSpacing: 3,
            fontFamily: FontFamily.nunitoSans,
          ),
        ),
        Text(
          isTrail
              ? context.i10n.limitedTimeOfferClaimNow
              : context.i10n.only799,
          style: context.textStyle.labelSmall?.copyWith(
            color: lightColorScheme.fieldText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
