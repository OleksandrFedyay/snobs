import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              lightColorScheme.primaryContainer,
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check_circle_rounded,
              color: lightColorScheme.yellowLight,
              size: 120,
            ),
            const SizedBox(height: 32),
            Text(
              context.i10n.thankYou,
              style: context.textStyle.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                context.i10n.weWillReviewASAP,
                style: context.textStyle.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: Navigator.of(context).pop,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightColorScheme.onSurface,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Text(
                  context.i10n.close.toUpperCase(),
                  style: context.textStyle.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
