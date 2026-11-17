import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

class BioView extends StatelessWidget {
  const BioView({
    required this.bio,
    super.key,
  });

  final String bio;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: lightColorScheme.onSecondary,
        fontFamily: FontFamily.nunitoSans,
      ),
      child: Html(data: bio),
    );
  }
}
