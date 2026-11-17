import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class DislikedContainer extends StatelessWidget {
  const DislikedContainer({required this.dx, super.key});

  final double dx;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: dx < -10 ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: lightColorScheme.iconColor.withValues(alpha:.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 44,
          color: Colors.white.withValues(alpha:.5),
        ),
      ),
    );
  }
}
