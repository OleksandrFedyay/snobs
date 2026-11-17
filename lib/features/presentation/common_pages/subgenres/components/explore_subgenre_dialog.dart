import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';


class ExploreSubgenreDialog extends StatelessWidget {
  const ExploreSubgenreDialog._({
    required this.onPressed,
    required this.subgenre,
  });

  final VoidCallback onPressed;
  final String subgenre;

  static void showExploreSubgenreDialog(
    BuildContext context, {
    required VoidCallback onPressed,
    required String subgenre,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return ExploreSubgenreDialog._(
          subgenre: subgenre,
          onPressed: onPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: lightColorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.i10n.wouldYouLikeExplore(subgenre),
              style: context.textStyle.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: onPressed,
              text: context.i10n.yesSwitchSubgenre.toUpperCase(),
              withArrow: false,
              style: AppThemeModel.instance.getWelcomeButtonTheme().style,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: Navigator.of(context).pop,
              behavior: HitTestBehavior.opaque,
              child: Text(
                context.i10n.goBack.toUpperCase(),
                textAlign: TextAlign.center,
                style: context.textStyle.titleSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
