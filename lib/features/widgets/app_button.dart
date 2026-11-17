import 'package:flutter/material.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.theme.model.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.width = double.infinity,
    this.style,
    this.enabled = true,
    this.loading = false,
    this.withArrow = true,
  });

  final bool enabled;
  final VoidCallback onPressed;
  final bool loading;
  final double? width;
  final String text;
  final bool withArrow;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: width,
      child: ElevatedButton(
        style: style ??
            AppThemeModel.instance.getOnboardingElevatedButtonTheme().style,
        onPressed: enabled && !loading ? onPressed : null,
        child: Center(
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (!enabled) return Text(text);
    if (loading) {
      return CircularProgressIndicator(
        color: lightColorScheme.onSurface,
      );
    }

    if (!withArrow) {
      return Center(
        child: Text(text),
      );
    }

    return Row(
      children: <Widget>[
        const SizedBox(width: 8),
        Text(text),
        const Spacer(),
        const CircleAvatar(
          backgroundColor: Colors.white24,
          radius: 20,
          child: Icon(
            Icons.keyboard_arrow_right,
            size: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
