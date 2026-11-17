import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(this.constraints, {super.key});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxWidth,
      color: lightColorScheme.surfaceContainerHighest,
    );
  }
}
