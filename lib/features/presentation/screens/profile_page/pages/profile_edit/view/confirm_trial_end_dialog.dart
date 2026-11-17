import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';


class ConfirmTrialEndDialog extends StatelessWidget {
  const ConfirmTrialEndDialog({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: lightColorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: context.i10n.areYouSureYouWantToCancel,
                      style: context.textStyle.headlineMedium,
                      children: <InlineSpan>[
                        TextSpan(
                          text: context.i10n.premium,
                          style: context.textStyle.headlineMedium
                              ?.copyWith(color: lightColorScheme.yellowLight),
                        ),
                        TextSpan(
                          text: ' ${context.i10n.subscription}?',
                          style: context.textStyle.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.i10n.youWillLoseAndFullSong,
                    style: context.textStyle.bodyLarge?.copyWith(
                      color: lightColorScheme.onSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    onPressed: Navigator.of(context).pop,
                    text: context.i10n.goBack.toUpperCase(),
                    withArrow: false,
                    style: AppThemeModel.instance.getGreyButtonTheme().style,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onPressed,
                    child: Text(
                      context.i10n.yesCancelSubscription.toUpperCase(),
                      style: context.textStyle.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
