import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

void showSuccessSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(74)),
      ),
      content: Text(
        text,
        style: context.textStyle.labelMedium?.copyWith(
          color: lightColorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

void showTopSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).size.height - 200,
      ),
      padding: const EdgeInsets.all(16),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(74)),
      ),
      content: Text(
        text,
        style: context.textStyle.labelMedium?.copyWith(
          color: lightColorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

SnackBar infoSnackBar(String text) => SnackBar(
      backgroundColor: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(74)),
      ),
      content: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: Colors.black,
          fontFamily: FontFamily.nunitoSans,
        ),
        textAlign: TextAlign.center,
      ),
    );
