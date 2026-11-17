import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class ConfirmUnlikeDialog extends StatelessWidget {
  const ConfirmUnlikeDialog({
    required this.artistName,
    required this.onTap,
    super.key,
  });

  final String artistName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: lightColorScheme.homeBackground2,
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 22),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.i10n.unlikeArtistFrom(artistName),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: FontFamily.nunitoSans,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              context.i10n.thisWillRemove,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: FontFamily.nunitoSans,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _button(context),
            const SizedBox(height: 8),
            _button(context, isConfirm: false),
          ],
        ),
      ),
    );
  }

  Widget _button(BuildContext context, {bool isConfirm = true}) =>
      GestureDetector(
        onTap: isConfirm ? onTap : Navigator.of(context).pop,
        child: Container(
          width: double.infinity,
          height: isConfirm ? 60 : 50,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color:
                isConfirm ? lightColorScheme.yellowLight : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              isConfirm ? context.i10n.yesUnlike : context.i10n.noGoBack,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isConfirm ? lightColorScheme.fieldText : Colors.white,
                fontFamily: FontFamily.nunitoSans,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}
