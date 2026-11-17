import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/widgets/app_button.dart';


class StreakDialog extends StatelessWidget {
  const StreakDialog._(this.streak);

  final int streak;

  static void showStreakDialog(BuildContext context, int streak) {
    showDialog<void>(
      context: context,
      builder: (_) => StreakDialog._(streak),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int count = streak > 7 ? 7 : streak;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.all(24),
      backgroundColor: lightColorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '🔥',
              style: TextStyle(fontSize: 40),
            ),
            Text(
              streak == 1
                  ? context.i10n.newStreakStarted
                  : context.i10n.dayStreak(streak),
              style: context.textStyle.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: context.i10n.a,
                style: context.textStyle.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: context.i10n.streak,
                    style: context.textStyle.labelMedium,
                  ),
                  TextSpan(
                    text: context.i10n.countsHowConsecutiveDaysYou,
                    style: context.textStyle.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.white12),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                for (int i = count - 1; i >= 0; i--)
                  _buildDays(
                    context,
                    DateTime.now().add(-Duration(days: i)),
                    true,
                  ),
                for (int i = 0; i < 7 - count; i++)
                  _buildDays(
                    context,
                    DateTime.now().add(Duration(days: i + 1)),
                    false,
                  ),
              ],
            ),
            const SizedBox(height: 40),
            _buildControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDays(BuildContext context, DateTime day, bool fill) {
    return Column(
      children: <Widget>[
        Text(
          DateFormat.E().format(day).substring(0, 2),
          style: context.textStyle.titleSmall?.copyWith(
            color: fill
                ? lightColorScheme.yellowLight
                : lightColorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (fill)
          Icon(
            Icons.check_circle_rounded,
            color: lightColorScheme.yellowLight,
            size: 24,
          )
        else
          Icon(
            Icons.circle,
            color: lightColorScheme.onSurface,
            size: 24,
          ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return AppButton(
      withArrow: false,
      style: AppThemeModel.instance.getWelcomeButtonTheme().style,
      onPressed: Navigator.of(context).pop,
      text: context.i10n.continueTitle.toUpperCase(),
    );
  }
}
