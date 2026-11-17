import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

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
              context.i10n.areYouSureYouWantToDeleteYourAccount,
              style: context.textStyle.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              context.i10n.thisActionCannotBeUndone,
              style: context.textStyle.bodyLarge?.copyWith(
                color: lightColorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: Navigator.of(context).pop,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: lightColorScheme.onSurface,
                ),
                child: Text(
                  context.i10n.goBack.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: context.textStyle.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onPressed,
              behavior: HitTestBehavior.opaque,
              child: Text(
                context.i10n.yesDelete.toUpperCase(),
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
