import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingfishertom/features/presentation/common_pages/premium/cubit/trail_premium_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/widgets/gradient_button.dart';
import 'package:kingfishertom/features/widgets/premium_button_text.dart';
import 'package:kingfishertom/gen/assets.gen.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TrailPremiumViewDialog extends StatelessWidget {
  const TrailPremiumViewDialog._(
      {required this.isTrail, required this.pageName});

  final bool isTrail;
  final String pageName;

  static Future<void> showDialog(
      {required BuildContext context,
      required bool isTrail,
      required String pageName}) async {
    await showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider<TrailPremiumCubit>(
        create: (BuildContext context) => TrailPremiumCubit.create(),
        child: TrailPremiumViewDialog._(isTrail: isTrail, pageName: pageName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BlocConsumer<TrailPremiumCubit, TrailPremiumState>(
        listener: (BuildContext context, TrailPremiumState state) {},
        builder: _buildContent,
      ),
    );
  }

  Widget _buildContent(BuildContext context, TrailPremiumState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const Color(0xFF08000F),
                lightColorScheme.onPrimary,
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              SvgPicture.asset(Assets.logos.premium),
              const SizedBox(height: 50),
              Text(
                context.i10n.shufflePlayAnyCollection,
                style: context.textStyle.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                context.i10n.fullSongAdFreeExperience,
                style: context.textStyle.displaySmall?.copyWith(
                  color: lightColorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
            child: Container(
              height: 205,
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
              child: Lottie.asset(
                width: double.infinity,
                Assets.anim.premiumAnim,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        GradientButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await context.read<TrailPremiumCubit>().startTrial(pageName);
          },
          loading: false,
          horizontalMargin: 12,
          child: PremiumButtonTitle(isTrail: isTrail),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Text(
            isTrail.getPremiumDetailsText(context),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: lightColorScheme.onSecondary,
              fontFamily: FontFamily.nunitoSans,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }
}
