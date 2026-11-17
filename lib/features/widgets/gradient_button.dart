import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.loading,
    required this.onPressed,
    required this.child,
    this.width = double.infinity,
    this.horizontalMargin = 32,
    super.key,
  });

  final VoidCallback onPressed;
  final bool loading;
  final Widget child;
  final double width;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: horizontalMargin),
      width: width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        gradient: LinearGradient(
          begin: Alignment(0.7, -4),
          end: Alignment.bottomLeft,
          stops: <double>[0, 0.13, 0.25, 0.75, 0.98],
          colors: <Color>[
            Color(0xFFF1CB70),
            Color(0xFFA08648),
            Color(0xFFEBC66D),
            Color(0xFFD7B565),
            Color(0xFF856F3A),
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: lightColorScheme.onPrimary,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          textStyle: context.textStyle.titleSmall?.copyWith(
            color: lightColorScheme.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: !loading ? onPressed : null,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
