import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class NumberBuble extends StatelessWidget {
  const NumberBuble({required this.number, super.key});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: lightColorScheme.secondary),
        borderRadius: BorderRadius.circular(120),
      ),
      child: Text(
        number.toString(),
        style: context.textStyle.headlineMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
