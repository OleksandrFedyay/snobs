import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class LikedContainer extends StatelessWidget {
  const LikedContainer({required this.dx, super.key});

  final double dx;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: dx > 10 ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: lightColorScheme.deepPurple.withValues(alpha:.7),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.favorite,
          size: 44,
          color: Colors.white,
        ),
      ),
    );
  }
}
