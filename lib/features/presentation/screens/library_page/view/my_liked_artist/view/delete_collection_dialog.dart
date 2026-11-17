import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/assets.gen.dart';


class DeleteCollectionDialog extends StatelessWidget {
  const DeleteCollectionDialog({
    required this.collectionName,
    required this.onPressed,
    super.key,
  });
  final String collectionName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: lightColorScheme.onSecondaryContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: lightColorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                SvgPicture.asset(Assets.icons.trash),
                const SizedBox(height: 16),
                Text(
                  context.i10n.deleteCollect(collectionName),
                  style: context.textStyle.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              context.i10n.deletingCollectionDoesNot,
              style: context.textStyle.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: Navigator.of(context).pop,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 40,
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
        ),
        Container(
          height: 40,
          width: 1,
          color: lightColorScheme.secondary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 40,
              ),
              child: Text(
                context.i10n.yesDelete.toUpperCase(),
                textAlign: TextAlign.center,
                style: context.textStyle.labelMedium?.copyWith(
                  color: lightColorScheme.red,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
