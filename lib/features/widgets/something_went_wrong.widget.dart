import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class SomethingWentWrongWidget extends StatelessWidget {
  const SomethingWentWrongWidget({
    this.onClose,
    super.key,
  });

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (context.router.canPop())
            _AppBarWithCloseButton(
              onPressed: context.router.maybePop,
            )
          else if (onClose != null)
            _AppBarWithCloseButton(
              onPressed: onClose!,
            ),
          Center(
            child: Text(context.i10n.somethingWentWrong),
          ),
        ],
      ),
    );
  }
}

class _AppBarWithCloseButton extends StatelessWidget {
  const _AppBarWithCloseButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
