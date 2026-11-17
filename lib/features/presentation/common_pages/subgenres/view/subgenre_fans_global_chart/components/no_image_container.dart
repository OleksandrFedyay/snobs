import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';


///Used for CachedNetworkImage's errorWidget and placeholder to show initials instead

class NoImageContainer extends StatelessWidget {
  const NoImageContainer({
    this.name,
    this.lastName,
    super.key,
  });

  final String? name;
  final String? lastName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        color: lightColorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Text(
          '${name?.characters.firstOrNull?.toUpperCase() ?? ''}${lastName?.characters.firstOrNull?.toUpperCase() ?? ''}',
          style: context.textStyle.displayMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
