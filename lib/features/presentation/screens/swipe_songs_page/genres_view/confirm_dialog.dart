import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ConfirmArtistDialog extends StatelessWidget {
  const ConfirmArtistDialog({
    required this.onPressed,
    required this.title,
    super.key,
  });

  final VoidCallback onPressed;
  final String title;

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
              title,
              style: context.textStyle.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onPressed,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: lightColorScheme.onSurface,
                ),
                child: Text(
                  context.i10n.confirm.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: context.textStyle.titleSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
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

class SuccessView extends StatelessWidget {
  const SuccessView._(
    this.artist,
    this.genre,
  );

  final String artist;
  final String genre;

  static void showSuccessDialog(
    BuildContext context,
    String artist,
    String genre,
  ) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SuccessView._(artist, genre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: lightColorScheme.onPrimary,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
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
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check_circle_rounded,
              color: lightColorScheme.yellow,
              size: 60,
            ),
            const SizedBox(height: 24),
            Text(
              context.i10n.thankYou,
              style: context.textStyle.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              context.i10n.willIncludedInYourCollection(artist, genre),
              style: context.textStyle.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
