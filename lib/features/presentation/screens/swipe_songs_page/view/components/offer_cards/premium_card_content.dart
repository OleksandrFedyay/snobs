import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/screens/swipe_songs_page/cubit/swipe_songs_page_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/extensions.dart';
import 'package:kingfishertom/features/widgets/gradient_button.dart';
import 'package:kingfishertom/features/widgets/premium_button_text.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class PremiumCardContent extends StatefulWidget {
  const PremiumCardContent({
    required this.isTrailSubscription,
    required this.constraints,
    super.key,
  });

  final bool isTrailSubscription;
  final BoxConstraints constraints;

  @override
  PremiumCardContentState createState() => PremiumCardContentState();
}

class PremiumCardContentState extends State<PremiumCardContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _button,
        _textContent,
      ],
    );
  }

  Widget get _button => Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const <double>[0.6, 1.0],
            colors: <Color>[
              lightColorScheme.primary.withValues(alpha: 0.4),
              Colors.transparent,
            ],
          ),
        ),
        child: GradientButton(
          onPressed: context.read<SwipeSongsPageCubit>().startTrialOrPremium,
          loading: false,
          horizontalMargin: 12,
          child: PremiumButtonTitle(isTrail: widget.isTrailSubscription),
        ),
      );

  Widget get _textContent => SizedBox(
        height: widget.constraints.maxHeight / 4.9,
        child: Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.i10n.premiumCardContent,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: lightColorScheme.onSecondary,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.i10n.details,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: lightColorScheme.onSecondary,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.isTrailSubscription.getPremiumDetailsText(context),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: lightColorScheme.onSecondary,
                      fontFamily: FontFamily.nunitoSans,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
