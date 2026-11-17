import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/dtos/tag_type.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({this.tag, super.key});

  final TagType? tag;

  @override
  Widget build(BuildContext context) {
    if (tag == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: lightColorScheme.onSurface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(tag!.getEmoji()),
          const SizedBox(width: 4),
          Text(
            tag!.getString(context),
            style: context.textStyle.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
